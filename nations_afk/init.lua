local afk_data = {}

local function get_pos_hash(pos)
    return math.floor(pos.x) .. ":" .. math.floor(pos.y) .. ":" .. math.floor(pos.z)
end

minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    afk_data[name] = {
        last_pos = get_pos_hash(player:get_pos()),
        last_move_time = os.time(),
        warned = false
    }
end)

minetest.register_on_leaveplayer(function(player)
    local name = player:get_player_name()
    afk_data[name] = nil
end)

minetest.register_globalstep(function(dtime)
    for name, data in pairs(afk_data) do
        local player = minetest.get_player_by_name(name)
        if not player then goto continue end

        local pos_hash = get_pos_hash(player:get_pos())

        if pos_hash ~= data.last_pos then
            data.last_pos = pos_hash
            data.last_move_time = os.time()
            data.warned = false
        else
            local idle = os.time() - data.last_move_time

            if idle >= 10 and not data.warned then
                minetest.chat_send_player(name, "[AFK] Tu sembles AFK. Utilise /afk pour relancer le compteur.")
                data.warned = true
            elseif idle >= 20 and data.warned then
                minetest.kick_player(name, "AFK interdit sur ce serveur.")
            end
        end

        ::continue::
    end
end)

minetest.register_chatcommand("afk", {
    description = "Relance le compteur AFK",
    privs = { interact = true },
    func = function(name)
        local data = afk_data[name]
        if not data then return false, "Erreur interne." end
        data.last_move_time = os.time()
        data.warned = false
        return true, "[AFK] Compteur relancé."
    end
})

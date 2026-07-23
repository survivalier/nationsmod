local afk_data = {}

local function get_pos_hash(pos)
    return math.floor(pos.x) .. ":" .. math.floor(pos.y) .. ":" .. math.floor(pos.z)
end

minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    afk_data[name] = {
        last_pos = get_pos_hash(player:get_pos()),
        last_move_time = os.time(),
        warned = false,
        warn_time = 0
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

        -- Si le joueur bouge → reset complet
        if pos_hash ~= data.last_pos then
            data.last_pos = pos_hash
            data.last_move_time = os.time()
            data.warned = false
            data.warn_time = 0
        else
            local idle = os.time() - data.last_move_time

            -- 5 minutes sans bouger → avertissement + son
            if idle >= 300 and not data.warned then
                minetest.chat_send_player(name, "[AFK] Tu sembles AFK. Utilise /afk dans les 30 secondes pour éviter d'être kick.")

                minetest.sound_play("alert", {
                    to_player = name,
                    gain = 1.0,
                    pitch = 1.0
                })

                data.warned = true
                data.warn_time = os.time()

            -- 30 secondes après l'avertissement → kick
            elseif data.warned and (os.time() - data.warn_time >= 30) then
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
        data.warn_time = 0

        return true, "[AFK] Compteur relancé."
    end
})
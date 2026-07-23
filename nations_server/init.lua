local worldpath = minetest.get_worldpath()
local spawn_file = worldpath .. "/nations_spawn.json"
local server_spawn = {x = 0, y = 10, z = 0}
local f = io.open(spawn_file, "r")
if f then
    local data = minetest.parse_json(f:read("*a"))
    f:close()
    if data and data.x then
        server_spawn = data
    end
end

local function save_spawn()
    local f = io.open(spawn_file, "w")
    if f then
        f:write(minetest.write_json(server_spawn))
        f:close()
    end
end
minetest.register_chatcommand("spawn", {
    description = "Se téléporter au spawn du serveur",
    privs = { interact = true },
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Erreur interne."
        end
        player:set_pos(server_spawn)
        return true, "Téléportation au spawn."
    end
})
minetest.register_chatcommand("s", {
    params = "setspawn",
    description = "Définir le spawn du serveur",
    privs = { server = true },
    func = function(name, param)
        if param ~= "setspawn" then
            return false, "Utilisation : /s setspawn"
        end
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Erreur interne."
        end
        server_spawn = player:get_pos()
        save_spawn()
        return true, "Spawn du serveur défini à ta position."
    end
})
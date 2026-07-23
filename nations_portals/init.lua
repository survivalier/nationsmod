local modname = minetest.get_current_modname()
minetest.register_node(modname .. ":portal", {
    description = "Portail",
    drawtype = "mesh",
    mesh = "portal.obj",
    tiles = { "portal.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    use_texture_alpha = "blend",
    sunlight_propagates = true,
    walkable = false,
    pointable = true,
    diggable = true,
    groups = { cracky = 1 },
    selection_box = {
        type = "fixed",
        fixed = {
            { -1.5, -1.5, -0.5, 1.5, 1.5, 0.5 }
        }
    },
    collision_box = {
        type = "fixed",
        fixed = {
            { -1.5, -1.5, -0.5, 1.5, 1.5, 0.5 }
        }
    }
})
local function find_safe_random_pos()
    local x = math.random(-30000, 30000)
    local z = math.random(-30000, 30000)
    local y = 100
    while y > -100 do
        local node = minetest.get_node({x=x, y=y, z=z})
        if node and node.name ~= "air" then
            return {x=x, y=y+2, z=z}
        end
        y = y - 1
    end
    return {x=0, y=10, z=0}
end
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        local pos = player:get_pos()
        local node = minetest.get_node(pos)
        if node and node.name == modname .. ":portal" then
            local newpos = find_safe_random_pos()
            player:set_pos(newpos)
            minetest.chat_send_player(player:get_player_name(),
                "[PORTAIL] Téléportation vers un endroit aléatoire du monde.")
        end
    end
end)
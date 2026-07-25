minetest.register_tool("nations_stuff:sword", {
    description = "Épée",
    inventory_image = "sword.png",
    tool_capabilities = {
        full_punch_interval = 0.8,
        max_drop_level = 1,
        groupcaps = {
            fleshy = {times = {[2]=0.8, [3]=0.4}, uses = 20, maxlevel = 1},
        },
        damage_groups = {fleshy = 5},
    },
})
minetest.register_tool("nations_stuff:pickaxe", {
    description = "Pioche",
    inventory_image = "pickaxe.png",
    tool_capabilities = {
        full_punch_interval = 0.9,
        max_drop_level = 0,
        groupcaps = {
            cracky = {
                times = {[1]=3.00, [2]=1.50, [3]=0.70},
                uses = 100,
                maxlevel = 1
            }
        },
        damage_groups = {fleshy = 2},
    },
})
minetest.register_tool("nations_stuff:axe", {
    description = "Hache",
    inventory_image = "axe.png",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 0,
        groupcaps = {
            choppy = {
                times = {[1]=2.50, [2]=1.20, [3]=0.60},
                uses = 100,
                maxlevel = 1
            }
        },
        damage_groups = {fleshy = 3},
    },
})
minetest.register_tool("nations_stuff:shovel", {
    description = "Pelle",
    inventory_image = "shovel.png",
    tool_capabilities = {
        full_punch_interval = 0.8,
        max_drop_level = 0,
        groupcaps = {
            crumbly = {
                times = {[1]=1.50, [2]=0.70, [3]=0.30}, 
                uses = 100,
                maxlevel = 1
            }
        },
        damage_groups = {fleshy = 1},
    },
})
local MODNAME = minetest.get_current_modname()
local START_SLOTS = {
    [1] = { item = "nations_stuff:sword",      count = 1 },
    [2] = { item = "nations_stuff:pickaxe",       count = 1 },
    [3] = { item = "nations_stuff:axe",    count = 1 },
    [4] = { item = "nations_stuff:shovel",     count = 1 },
    [5] = { item = "default:torch",           count = 16 },
}
local function give_start_stuff(player)
    if not player then return end
    local inv = player:get_inventory()
    if not inv then return end
    for slot, def in pairs(START_SLOTS) do
        if def.item and def.count and def.count > 0 then
            local stack = ItemStack(def.item .. " " .. def.count)
            inv:set_stack("main", slot, stack)
        end
    end
end
minetest.register_on_joinplayer(function(player)
    if not player then return end
    local meta = player:get_meta()
    local flag = meta:get_string("nationsmods_first_join")
    if flag == "" then
        give_start_stuff(player)
        meta:set_string("nationsmods_first_join", "1")
        minetest.chat_send_player(
            player:get_player_name(),
            "[NATIONS] Stuff de départ reçu."
        )
    end
end)
minetest.register_chatcommand("stuff", {
    params = "<pseudo>",
    description = "Donner le stuff de départ Nations Mods à un joueur",
    privs = { server = true },
    func = function(name, param)
        if param == "" then
            return false, "Utilisation : /nationsmods_givestuff <pseudo>"
        end
        local target = minetest.get_player_by_name(param)
        if not target then
            return false, "Joueur introuvable."
        end
        give_start_stuff(target)
        return true, "[NATIONS MODS] Stuff de départ donné à " .. param .. "."
    end
})
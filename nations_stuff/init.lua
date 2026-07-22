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
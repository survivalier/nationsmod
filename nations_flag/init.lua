minetest.register_node("nations_flag:flag_red", {
    description = "Drapeau Rouge",
    tiles = {"flag.png^flag_red.png"},
    drawtype = "mesh",
    mesh = "flag.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    selection_box = {
        type = "fixed",
        fixed = {-0.166, -1.0, -0.5, 0.166, 1.0, 0.5},
    },
    collision_box = {
        type = "fixed",
        fixed = {-0.166, -1.0, -0.5, 0.166, 1.0, 0.5},
    },
})
minetest.register_node("nations_flag:flag_blue", {
    description = "Drapeau Bleu",
    tiles = {"flag.png^flag_blue.png"},
    drawtype = "mesh",
    mesh = "flag.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    selection_box = {
        type = "fixed",
        fixed = {-0.166, -1.0, -0.5, 0.166, 1.0, 0.5},
    },
    collision_box = {
        type = "fixed",
        fixed = {-0.166, -1.0, -0.5, 0.166, 1.0, 0.5},
    },
})
minetest.register_node("nations_flag:flag_yellow", {
    description = "Drapeau Jaune",
    tiles = {"flag.png^flag_yellow.png"},
    drawtype = "mesh",
    mesh = "flag.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    selection_box = {
        type = "fixed",
        fixed = {-0.166, -1.0, -0.5, 0.166, 1.0, 0.5},
    },
    collision_box = {
        type = "fixed",
        fixed = {-0.166, -1.0, -0.5, 0.166, 1.0, 0.5},
    },
})
minetest.register_node("nations_flag:wall_red", {
    description = "Drapeau Rouge",
    tiles = {"flag_wall.png^flag_wall_red.png"},
    drawtype = "mesh",
    mesh = "flag_wall.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -1.5, 0.25, 0.5, 1.5, 0.5},
    },
    collision_box = {
        type = "fixed",
        fixed = {-0.5, -1.5, 0.25, 0.5, 1.5, 0.5},
    },
})
minetest.register_node("nations_flag:wall_blue", {
    description = "Drapeau Bleu",
    tiles = {"flag_wall.png^flag_wall_blue.png"},
    drawtype = "mesh",
    mesh = "flag_wall.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -1.5, 0.25, 0.5, 1.5, 0.5},
    },
    collision_box = {
        type = "fixed",
        fixed = {-0.5, -1.5, 0.25, 0.5, 1.5, 0.5},
    },
})
minetest.register_node("nations_flag:wall_yellow", {
    description = "Drapeau Jaune",
    tiles = {"flag_wall.png^flag_wall_yellow.png"},
    drawtype = "mesh",
    mesh = "flag_wall.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -1.5, 0.25, 0.5, 1.5, 0.5},
    },
    collision_box = {
        type = "fixed",
        fixed = {-0.5, -1.5, 0.25, 0.5, 1.5, 0.5},
    },
})
minetest.register_node("nations_flag:floor_red", {
    description = "Drapeau Rouge",
    tiles = {"flag_floor.png^flag_floor_red.png"},
    drawtype = "mesh",
    mesh = "flag_floor.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    selection_box = {
        type = "fixed",
        fixed = { -0.166, -0.5, -0.5, 0.166, 6.0, 0.5 },
    },
    collision_box = {
        type = "fixed",
        fixed = { -0.166, -0.5, -0.5, 0.166, 6.0, 0.5 },
    },
})
minetest.register_node("nations_flag:floor_blue", {
    description = "Drapeau Bleu",
    tiles = {"flag_floor.png^flag_floor_blue.png"},
    drawtype = "mesh",
    mesh = "flag_floor.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    selection_box = {
        type = "fixed",
        fixed = { -0.166, -0.5, -0.5, 0.166, 6.0, 0.5 },
    },
    collision_box = {
        type = "fixed",
        fixed = { -0.166, -0.5, -0.5, 0.166, 6.0, 0.5 },
    },
})
minetest.register_node("nations_flag:floor_yellow", {
    description = "Drapeau Jaune",
    tiles = {"flag_floor.png^flag_floor_yellow.png"},
    drawtype = "mesh",
    mesh = "flag_floor.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    selection_box = {
        type = "fixed",
        fixed = { -0.166, -0.5, -0.5, 0.166, 6.0, 0.5 },
    },
    collision_box = {
        type = "fixed",
        fixed = { -0.166, -0.5, -0.5, 0.166, 6.0, 0.5 },
    },
})
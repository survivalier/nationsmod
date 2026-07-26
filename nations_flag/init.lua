minetest.register_node("nations_flag:flag_red", {
    description = "Drapeau rouge",
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
    description = "Drapeau bleu",
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
    description = "Drapeau jaune",
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
    description = "Drapeau murale rouge",
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
    description = "Drapeau murale bleu",
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
    description = "Drapeau murale jaune",
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
    description = "Drapeau sur pied rouge",
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
minetest.register_node("nations_flag:floor_red_b", {
    description = "Double drapeau sur pied rouge",
    tiles = {"flag_floor.png^flag_floor_red.png"},
    drawtype = "mesh",
    mesh = "flag_floor_b.obj",
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
    description = "Drapeau sur pied Bleu",
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
minetest.register_node("nations_flag:floor_blue_b", {
    description = "Double drapeau sur pied bleu",
    tiles = {"flag_floor.png^flag_floor_blue.png"},
    drawtype = "mesh",
    mesh = "flag_floor_b.obj",
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
    description = "Drapeau sur pied jaune",
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
minetest.register_node("nations_flag:floor_yellow_b", {
    description = "Double drapeau sur pied Jaune",
    tiles = {"flag_floor.png^flag_floor_yellow.png"},
    drawtype = "mesh",
    mesh = "flag_floor_b.obj",
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
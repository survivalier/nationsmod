minetest.register_node("nations_decorations:barrier", {
    description = "Barrière",
    tiles = {"barrier.png"},
    drawtype = "mesh",
    mesh = "barrier.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    collision_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, 0.0, 0.5, 0.5, 0.5},
    },
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, 0.0, 0.5, 0.5, 0.5},
    },
})
minetest.register_node("nations_decorations:barrier_corner", {
    description = "Barrière",
    tiles = {"barrier_corner.png"},
    drawtype = "mesh",
    mesh = "barrier_corner.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    collision_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, 0.0, 0.0, 0.5, 0.5},
    },
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, 0.0, 0.0, 0.5, 0.5};
    },
})
minetest.register_node("nations_decorations:barrier_bannister", {
    description = "Barrière",
    tiles = {"barrier_bannister.png"},
    drawtype = "mesh",
    mesh = "barrier_bannister.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    collision_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, 0.0, 0.5, 0.5, 0.5},
    },
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, 0.0, 0.5, 0.5, 0.5},
    },
})
minetest.register_node("nations_decorations:barrier_bannister_b", {
    description = "Barrière",
    tiles = {"barrier_bannister.png"},
    drawtype = "mesh",
    mesh = "barrier_bannister_b.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    collision_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, 0.0, 0.5, 0.5, 0.5},
    },
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, 0.0, 0.5, 0.5, 0.5},
    },
})
minetest.register_node("nations_decorations:logo", {
    description = "Nations Logo",
    tiles = {"nations.png"},
    drawtype = "mesh",
    mesh = "nations.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    collision_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, 0.4, 0.5, 0.5, 0.5},
    },
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, 0.4, 0.5, 0.5, 0.5},
    },
})
minetest.register_node("nations_decorations:pedestal", {
    description = "Pedestal",
    tiles = {"pedestal.png"},
    drawtype = "mesh",
    mesh = "pedestal.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
})
minetest.register_node("nations_decorations:fences", {
    description = "Barrière",
    tiles = {"fences.png"},
    drawtype = "mesh",
    mesh = "fences.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.1, 0.1, 1.0, 0.1}
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.1, 0.1, 1.0, 0.1}
        }
    },
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
})
minetest.register_node("nations_decorations:fences_b", {
    description = "Barrière",
    tiles = {"fences_b.png"},
    drawtype = "mesh",
    mesh = "fences_b.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.1, 0.5, 1.0, 0.1}
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.1, 0.5, 1.0, 0.1}
        }
    },
})
minetest.register_node("nations_decorations:fences_c", {
    description = "Barrière",
    tiles = {"fences_c.png"},
    drawtype = "mesh",
    mesh = "fences_c.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.1, -0.5, -0.5, 0.1, 1.0, 0.1},
            {-0.5, -0.5, -0.1, -0.1, 1.0, 0.1}
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.1, -0.5, -0.5, 0.1, 1.0, 0.1},
            {-0.5, -0.5, -0.1, -0.1, 1.0, 0.1}
        }
    },
})
minetest.register_node("nations_decorations:carpet_red", {
    description = "Tapis Rouge",
    tiles = {"carpet_red.png"},
    drawtype = "mesh",
    mesh = "carpet.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    selection_box = {
        type = "fixed",
        fixed = {
            {-1.5, -0.5, -1.5, 1.5, -0.375, 1.5}
        }
    },
    collision_box = {
        type = "fixed",
        fixed = {
            {-1.5, -0.5, -1.5, 1.5, -0.375, 1.5}
        }
    },
})
minetest.register_node("nations_decorations:carpet_red_b", {
    description = "Tapis Rouge",
    tiles = {"carpet_red_b.png"},
    drawtype = "mesh",
    mesh = "carpet.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    selection_box = {
        type = "fixed",
        fixed = {
            {-1.5, -0.5, -1.5, 1.5, -0.375, 1.5}
        }
    },
    collision_box = {
        type = "fixed",
        fixed = {
            {-1.5, -0.5, -1.5, 1.5, -0.375, 1.5}
        }
    },
})
minetest.register_node("nations_decorations:carpet_blue", {
    description = "Tapis Bleu",
    tiles = {"carpet_blue.png"},
    drawtype = "mesh",
    mesh = "carpet.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    selection_box = {
        type = "fixed",
        fixed = {
            {-1.5, -0.5, -1.5, 1.5, -0.375, 1.5}
        }
    },
    collision_box = {
        type = "fixed",
        fixed = {
            {-1.5, -0.5, -1.5, 1.5, -0.375, 1.5}
        }
    },
})
minetest.register_node("nations_decorations:carpet_blue_b", {
    description = "Tapis Bleu",
    tiles = {"carpet_blue_b.png"},
    drawtype = "mesh",
    mesh = "carpet.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    selection_box = {
        type = "fixed",
        fixed = {
            {-1.5, -0.5, -1.5, 1.5, -0.375, 1.5}
        }
    },
    collision_box = {
        type = "fixed",
        fixed = {
            {-1.5, -0.5, -1.5, 1.5, -0.375, 1.5}
        }
    },
})
minetest.register_node("nations_decorations:carpet_yellow", {
    description = "Tapis Jaune",
    tiles = {"carpet_yellow.png"},
    drawtype = "mesh",
    mesh = "carpet.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    selection_box = {
        type = "fixed",
        fixed = {
            {-1.5, -0.5, -1.5, 1.5, -0.375, 1.5}
        }
    },
    collision_box = {
        type = "fixed",
        fixed = {
            {-1.5, -0.5, -1.5, 1.5, -0.375, 1.5}
        }
    },
})
minetest.register_node("nations_decorations:carpet_yellow_b", {
    description = "Tapis Jaune",
    tiles = {"carpet_yellow_b.png"},
    drawtype = "mesh",
    mesh = "carpet.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    selection_box = {
        type = "fixed",
        fixed = {
            {-1.5, -0.5, -1.5, 1.5, -0.375, 1.5}
        }
    },
    collision_box = {
        type = "fixed",
        fixed = {
            {-1.5, -0.5, -1.5, 1.5, -0.375, 1.5}
        }
    },
})
minetest.register_node("nations_decorations:coins_gold", {
    description = "Or",
    tiles = {"coins_gold.png"},
    drawtype = "mesh",
    mesh = "coins_gold.obj",
    use_texture_alpha = "blend",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    selection_box = {
        type = "fixed",
        fixed = { -0.5, -0.5, -0.5, 0.5, -0.25, 0.5 }
    },
    collision_box = {
        type = "fixed",
        fixed = { -0.5, -0.5, -0.5, 0.5, -0.25, 0.5 }
    },
})
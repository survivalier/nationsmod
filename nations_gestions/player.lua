local function get_player_skin(name)
    local player = minetest.get_player_by_name(name)
    if player then
        local skin = skins.get_player_skin(player)
        if skin then
            return skin:get_texture()
        end
    end
    if skins.get_player_skin_by_name then
        local skin = skins.get_player_skin_by_name(name)
        if skin then
            return skin:get_texture()
        end
    end
    return "playerdefault.png"
end
local function get_player_info(name)
    local nation = nations_gestions.player_nation[name]
    local rank = ""
    if nation then
        if nations_gestions.nations[nation].owner == name then
            rank = "Fondateur"
        else
            rank = "Membre"
        end
    else
        rank = "Aucune nation"
    end
    local claim_count = 0
    for _, owner in pairs(nations_gestions.claims) do
        if owner == nation then
            claim_count = claim_count + 1
        end
    end
    return {
        nation = nation or "-",
        rank = rank,
        claims = claim_count
    }
end
local function get_player_formspec(target)
    local skin = get_player_skin(target)
    local info = get_player_info(target)
    local nation_button = ""
    if info.nation ~= "-" then
        nation_button = "button[13,7;8,1;view_nation;Voir la nation]"
    end
    return table.concat({
        "formspec_version[4]",
        "size[24,12]",
        "image[1,1;10,10;playerbackground.png]",
        "model[3,2;6,8;player_model;playermodel.obj;" .. skin .. ";0,180;false;false;0]",
        "model_animation[player_model;stand;0;79;30]",
        "label[13,1;Profil du joueur]",
        "label[13,2;Pseudo :]",
        "label[16,2;" .. target .. "]",
        "label[13,3;Nation :]",
        "label[16,3;" .. info.nation .. "]",
        "label[13,4;Rang :]",
        "label[16,4;" .. info.rank .. "]",
        "label[13,5;Chunks claimés :]",
        "label[18,5;" .. info.claims .. "]",
        nation_button
    })
end
minetest.register_chatcommand("p", {
    params = "<playername>",
    description = "Affiche le profil d'un joueur",
    privs = { interact = true },
    func = function(name, param)
        local target = param:trim()
        if target == "" then
            target = name
        end
        if not minetest.player_exists(target) then
            return false, "Ce joueur n'existe pas."
        end
        nations_gestions.selected_player_profile = nations_gestions.selected_player_profile or {}
        nations_gestions.selected_player_profile[name] = target
        minetest.show_formspec(name, "nations_gestions:player_profile",
            get_player_formspec(target))
        return true, "Ouverture du profil de " .. target
    end
})
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "nations_gestions:player_profile" then
        return
    end
    local name = player:get_player_name()
    local target = nations_gestions.selected_player_profile[name]
    if not target then return end
    if fields.view_nation then
        local nation = nations_gestions.player_nation[target]
        if not nation then
            minetest.chat_send_player(name, "Ce joueur n'appartient à aucune nation.")
            return
        end
        minetest.show_formspec(name, "nations_gestions:list",
            nations_gestions.get_list_formspec(nation, name))
    end
end)
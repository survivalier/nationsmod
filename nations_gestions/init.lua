local worldpath = minetest.get_worldpath()
nations_gestions = nations_gestions or {}
nations_gestions.selected_nation_by_player = nations_gestions.selected_nation_by_player or {}
nations_gestions.selected_player_profile = nations_gestions.selected_player_profile or {}
local nations_file = worldpath .. "/nations.json"
local player_nation_file = worldpath .. "/player_nation.json"
local claims_file = worldpath .. "/nations_claims.json"
local nations_home_file = worldpath .. "/nations_home.json"
local nations = {}
local player_nation = {}
local claims = {}
local nations_home = {}
do
    local f = io.open(nations_home_file, "r")
    if f then
        local data = f:read("*a")
        f:close()
        nations_home = minetest.parse_json(data) or {}
    end
end
local function save_nations_home()
    local f = io.open(nations_home_file, "w")
    if f then
        f:write(minetest.write_json(nations_home))
        f:close()
    end
end
do
    local f = io.open(nations_file, "r")
    if f then
        local data = f:read("*a")
        f:close()
        nations = minetest.parse_json(data) or {}
    end
end
do
    local f = io.open(player_nation_file, "r")
    if f then
        local data = f:read("*a")
        f:close()
        player_nation = minetest.parse_json(data) or {}
    end
end
do
    local f = io.open(claims_file, "r")
    if f then
        local data = f:read("*a")
        f:close()
        claims = minetest.parse_json(data) or {}
    end
end
local function save_nations()
    local f = io.open(nations_file, "w")
    if f then
        f:write(minetest.write_json(nations))
        f:close()
    end
end
local function save_player_nation()
    local f = io.open(player_nation_file, "w")
    if f then
        f:write(minetest.write_json(player_nation))
        f:close()
    end
end
local function save_claims()
    local f = io.open(claims_file, "w")
    if f then
        f:write(minetest.write_json(claims))
        f:close()
    end
end
local function save_data()
    save_nations()
    save_player_nation()
    save_claims()
    save_nations_home()
end
nations_gestions.nations = nations
nations_gestions.player_nation = player_nation
nations_gestions.claims = claims
nations_gestions.nations_home = nations_home
nations_gestions.claims_file = claims_file
nations_gestions.save_nations = save_nations
nations_gestions.save_player_nation = save_player_nation
nations_gestions.save_claims = save_claims
nations_gestions.save_nations_home = save_nations_home
nations_gestions.save_data = save_data
nations_gestions.selected_nation_by_player = nations_gestions.selected_nation_by_player or {}
nations_gestions.selected_player_profile = nations_gestions.selected_player_profile or {}
local function player_color(name)
    return minetest.colorize("#ff4040", name)
end
local function nation_color(name)
    return minetest.colorize("#ff9900", name)
end
local function command_color(cmd)
    return minetest.colorize("#55cfff", cmd)
end
local function get_create_formspec(player_name)
    return table.concat({
        "formspec_version[4]",
        "size[20,10]",
        "image[0.5,0.5;9,9;createnations.png]",
        "label[11,1;Crée ta nation sur le serveur]",
        "label[11,2;Fonder une nation te permet d’obtenir un territoire protégé,]",
        "label[11,2.7;d’avoir des membres, des droits, et de gérer ton propre pays.]",
        "label[11,3.4;Tu pourras ensuite étendre ton territoire, créer des alliances,]",
        "label[11,4.1;et organiser la vie de ta nation comme tu le souhaites.]",
        "field[11,5.5;7,1;nation_name;Nom de ta nation;]",
        "button[11,7;7,1;found;Fonder]"
    })
end
local function get_list_formspec(selected, pname)
    local nations_list = {}
    for name, _ in pairs(nations) do
        table.insert(nations_list, name)
    end
    table.sort(nations_list)
    local founder = ""
    local members = ""
    if selected and nations[selected] then
        founder = nations[selected].owner
        members = table.concat(nations[selected].members, ", ")
    end
    local claim_count = 0
    if selected then
        for _, owner in pairs(claims) do
            if owner == selected then
                claim_count = claim_count + 1
            end
        end
    end
    local button_text = ""
    local button_name = ""
    local my_nation = player_nation[pname]
    if not selected then
        button_text = "Rejoindre cette nation"
        button_name = ""
    else
        if not my_nation then
            button_text = "Rejoindre cette nation"
            button_name = "join_nation"
        elseif my_nation == selected then
            if nations[selected].owner == pname then
                button_text = "Supprimer la nation"
                button_name = "delete_nation"
            else
                button_text = "Quitter ma nation"
                button_name = "leave_nation"
            end
        else
            button_text = "Tu appartiens déjà à une nation"
            button_name = ""
        end
    end
    return table.concat({
        "formspec_version[4]",
        "size[22,12]",
        "label[1,1;Liste des nations]",
        "textlist[1,2;8,9;nations_list;" .. table.concat(nations_list, ",") .. ";" .. (selected and (table.indexof(nations_list, selected) + 1) or 0) .. "]",
        "label[11,1;Informations sur la nation]",
        "label[11,2;Nom :]",
        "label[13,2;" .. (selected or "Aucune sélection") .. "]",
        "label[11,3;Fondateur :]",
        "label[13,3;" .. (founder ~= "" and founder or "-") .. "]",
        "label[11,4;Membres :]",
        "label[13,4;" .. (members ~= "" and members or "-") .. "]",
        "label[11,5;Chunks claimés :]",
        "label[13,5;".. claim_count .."]",
        "button[11,9.3;10,1;tp_home;Se téléporter]",
        "button[11,10.5;10,1;" .. button_name .. ";" .. button_text .. "]"
    })
end
nations_gestions.get_list_formspec = get_list_formspec
minetest.register_on_player_receive_fields(function(player, formname, fields)
    local pname = player:get_player_name()
    if formname == "nations_gestions:create" then
        if not fields.found then return end
        local nation = (fields.nation_name or ""):trim()
        if nation == "" then
            minetest.chat_send_player(pname, "[NATIONS] Le nom de la nation ne peut pas être vide.")
            return
        end
        if player_nation[pname] then
            minetest.chat_send_player(pname, "[NATIONS] Tu appartiens déjà à une nation.")
            return
        end
        if nations[nation] then
            minetest.chat_send_player(pname, "[NATIONS] Cette nation existe déjà.")
            return
        end
        nations[nation] = { owner = pname, members = { pname } }
        player_nation[pname] = nation
        save_data()
        minetest.chat_send_all("[NATIONS] " .. player_color(pname) ..
            " vient de fonder la nation « " .. nation_color(nation) .. " » !")
        minetest.chat_send_player(pname,
            "[NATIONS] Utilise " .. command_color("/f claim") .. " pour protéger ton territoire.")
        return
    end
    if formname ~= "nations_gestions:list" then return end
    if fields.nations_list then
        local event = minetest.explode_textlist_event(fields.nations_list)
        if event.type == "CHG" then
            local list = {}
            for name in pairs(nations) do table.insert(list, name) end
            table.sort(list)
            local selected = list[event.index]
            nations_gestions.selected_nation_by_player[pname] = selected
            minetest.show_formspec(pname, "nations_gestions:list",
                get_list_formspec(selected, pname))
            return
        end
    end
    if fields.join_nation then
        local selected = nations_gestions.selected_nation_by_player[pname]
        if not selected or not nations[selected] then
            minetest.chat_send_player(pname, "[NATIONS] Aucune nation sélectionnée.")
            return
        end
        if player_nation[pname] then
            minetest.chat_send_player(pname, "[NATIONS] Tu appartiens déjà à une nation.")
            return
        end
        table.insert(nations[selected].members, pname)
        player_nation[pname] = selected
        save_data()
        minetest.chat_send_player(pname,
            "[NATIONS] Tu as rejoint la nation « " .. nation_color(selected) .. " ».")
        return
    end
    if fields.leave_nation then
        local nation = player_nation[pname]
        if not nation then
            minetest.chat_send_player(pname, "[NATIONS] Tu n'appartiens à aucune nation.")
            return
        end
        if nations[nation].owner == pname then
            minetest.chat_send_player(pname,
                "[NATIONS] Tu es le fondateur, tu ne peux pas quitter ta nation.")
            return
        end
        for i, member in ipairs(nations[nation].members) do
            if member == pname then table.remove(nations[nation].members, i) break end
        end
        player_nation[pname] = nil
        save_data()
        minetest.chat_send_player(pname,
            "[NATIONS] Tu as quitté la nation « " .. nation_color(nation) .. " ».")
        minetest.show_formspec(pname, "nations_gestions:list",
            get_list_formspec(nil, pname))
        return
    end
    if fields.delete_nation then
        local nation = player_nation[pname]
        if not nation then
            minetest.chat_send_player(pname, "[NATIONS] Tu n'appartiens à aucune nation.")
            return
        end
        if nations[nation].owner ~= pname then
            minetest.chat_send_player(pname,
                "[NATIONS] Seul le fondateur peut supprimer la nation.")
            return
        end
        for _, member in ipairs(nations[nation].members) do
            player_nation[member] = nil
        end
        for key, owner_nation in pairs(claims) do
            if owner_nation == nation then claims[key] = nil end
        end
        nations[nation] = nil
        save_data()
        save_claims()
        minetest.chat_send_all("[NATIONS] La nation « " ..
            nation_color(nation) .. " » a été supprimée par son fondateur.")
        minetest.show_formspec(pname, "nations_gestions:list",
            get_list_formspec(nil, pname))
        return
    end
    if fields.tp_home then
        local nation = player_nation[pname]
        if not nation then
            minetest.chat_send_player(pname, "[NATIONS] Tu n'appartiens à aucune nation.")
            return
        end
        local home = nations_home[nation]
        if not home then
            minetest.chat_send_player(pname, "[NATIONS] Cette nation n'a pas défini de /f home.")
            return
        end
        minetest.chat_send_player(pname, "[NATIONS] Téléportation dans 5 secondes... Ne bouge pas.")
        minetest.after(5, function()
            local player2 = minetest.get_player_by_name(pname)
            if not player2 then return end
            player2:set_pos(home)
            minetest.chat_send_player(pname, "[NATIONS] Téléportation effectuée.")
        end)
        return
    end
end)
minetest.register_chatcommand("n", {
    params = "<create|list>",
    description = "Gestion des nations",
    privs = { interact = true },
    func = function(name, param)
        local args = param:split(" ")
        if args[1] == "create" then
            minetest.show_formspec(name, "nations_gestions:create",
                get_create_formspec(name))
            return true, "Ouverture du formulaire de création."
        end
        if args[1] == "list" then
            minetest.show_formspec(name, "nations_gestions:list",
                get_list_formspec(nil, name))
            return true, "Ouverture de la liste des nations."
        end
        return false, "Paramètre inconnu. Utilise " .. command_color("/n create") .. " ou " .. command_color("/n list") .. "."
    end
})
dofile(minetest.get_modpath("nations_gestions") .. "/player.lua")
dofile(minetest.get_modpath("nations_gestions") .. "/claim.lua")
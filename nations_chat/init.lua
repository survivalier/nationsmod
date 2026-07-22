minetest.send_join_message = function(name)
end
minetest.send_leave_message = function(name)
end
local function nation_color(name)
    return minetest.colorize("#ff9900", name)
end
local function player_color(name)
    return minetest.colorize("#ff4040", name)
end
local NATIONS_VERSION = "1.0"
minetest.get_server_status = function()
    local gameid = minetest.get_game_info().id or "unknown"
    local players = minetest.get_connected_players()
    local line1 = "# Nations: version: " .. NATIONS_VERSION .. " | game: " .. gameid
    local same_nation_list = {}
    local other_nations_list = {}
    local reference_nation = nil
    if players[1] then
        local refname = players[1]:get_player_name()
        reference_nation = nations_gestions.player_nation[refname]
    end
    for _, player in ipairs(players) do
        local name = player:get_player_name()
        local nation = nations_gestions.player_nation[name]
        if nation then
            if nation == reference_nation then
                table.insert(same_nation_list, player_color(name))
            else
                table.insert(other_nations_list,
                    "[" .. nation_color(nation) .. "] " .. player_color(name)
                )
            end
        else
            table.insert(other_nations_list, player_color(name))
        end
    end
    local line2
    if reference_nation then
        line2 = "# Nations: joueurs de la nation " ..
                nation_color(reference_nation) .. ": " ..
                table.concat(same_nation_list, ", ")
    else
        line2 = "# Nations: aucun joueur n'a de nation."
    end
    local line3 = "# Nations: joueurs des autres nations: " ..
                  table.concat(other_nations_list, ", ")
    return line1 .. "\n" .. line2 .. "\n" .. line3
end
local old_get_modnames = minetest.get_modnames
minetest.get_modnames = function()
    local mods = old_get_modnames()
    local nations_mods = {}
    for i = #mods, 1, -1 do
        local m = mods[i]
        if m:sub(1, 8) == "nations_" then
            table.insert(nations_mods, m)
            table.remove(mods, i)
        end
    end
    if #nations_mods > 0 then
        table.insert(mods, "Nations Modpack")
    end
    local line = "# Nations: liste des mods: " .. table.concat(mods, ", ")
    return { line }
end



if not nations_gestions then
    minetest.log("error", "[nations_chat] Le mod nations_gestions n'est pas chargé !")
    return
end
local player_nation = nations_gestions.player_nation
minetest.register_on_chat_message(function(name, message)
    local nation = player_nation[name]
    if not nation then
        return false
    end
    local formatted =
        "[" .. nation_color(nation) .. "] " ..
        "<" .. player_color(name) .. "> : " ..
        message
    minetest.chat_send_all(formatted)
    return true
end)
local function update_nametag(player)
    local name = player:get_player_name()
    local nation = player_nation[name]

    if nation then
        player:set_nametag_attributes({
            text = "[" .. nation_color(nation) .. "] " .. player_color(name)
        })
    else
        player:set_nametag_attributes({
            text = player_color(name)
        })
    end
end
minetest.register_on_joinplayer(function(player)
    update_nametag(player)
end)
minetest.register_globalstep(function()
    for _, player in ipairs(minetest.get_connected_players()) do
        update_nametag(player)
    end
end)
minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    local nation = player_nation[name]
    if nation then
        minetest.chat_send_all(
            "[" .. nation_color(nation) .. "]" .. player_color(name) .. " a rejoint le serveur !"
        )
    else
        minetest.chat_send_all(
            player_color(name) .. " a rejoint le serveur !"
        )
    end
    return true
end)
minetest.register_on_leaveplayer(function(player)
    local name = player:get_player_name()
    local nation = player_nation[name]
    if nation then
        minetest.chat_send_all(
            "[" .. nation_color(nation) .. "]" .. player_color(name) .. " a quitté le serveur."
        )
    else
        minetest.chat_send_all(
            player_color(name) .. " a quitter le serveur."
        )
    end
    return true
end)
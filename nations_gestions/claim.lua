local nations = nations_gestions.nations
local player_nation = nations_gestions.player_nation
local claims = nations_gestions.claims
local claims_file = nations_gestions.claims_file
local save_claims = nations_gestions.save_claims
local nations_home = nations_gestions.nations_home
local save_nations_home = nations_gestions.save_nations_home
local worldpath = minetest.get_worldpath()
local bans_file = worldpath .. "/nations_bans.json"
local bans = {}
local invites = {}
local player_invite = {}
local hud_ids = {}
local show_claims = {}
local pending_teleports = {}
local TELEPORT_DELAY = 5
local MOVE_TOLERANCE = 0.25
local VELOCITY_TOLERANCE = 0.2 
local function player_color(name) return minetest.colorize("#ff4040", name) end
local function nation_color(name) return minetest.colorize("#ff9900", name) end
local function command_color(cmd) return minetest.colorize("#55cfff", cmd) end
local function load_bans()
    local f = io.open(bans_file, "r")
    if not f then return end
    local data = f:read("*a")
    f:close()
    bans = minetest.parse_json(data) or {}
end
load_bans()
local function save_bans()
    local f = io.open(bans_file, "w")
    if f then
        f:write(minetest.write_json(bans))
        f:close()
    end
end
local function load_claims()
    local f = io.open(claims_file, "r")
    if not f then return end
    local data = f:read("*a")
    f:close()
    claims = minetest.parse_json(data) or {}
    nations_gestions.claims = claims
end
load_claims()
local function get_chunk(pos)
    local cx = math.floor(pos.x / 16)
    local cz = math.floor(pos.z / 16)
    return cx, cz
end
local function norm(s)
    if not s then return "" end
    return s:match("^%s*(.-)%s*$")
end
local function is_banned_from_chunk(playername, cx, cz)
    if not playername then return false end
    local key = cx .. "," .. cz
    local nation = claims[key]
    if not nation then return false end
    local bn = bans[nation]
    if not bn then return false end
    return bn[playername] ~= nil
end
local function is_member_of_chunk(playername, cx, cz)
    if not playername then return false end
    local key = cx .. "," .. cz
    local nation = claims[key]
    if not nation then return false end
    return player_nation[playername] == nation
end
local function is_member_or_invited_of_chunk(playername, cx, cz)
    if not playername then return false end
    local key = cx .. "," .. cz
    local nation = claims[key]
    if not nation then return false end
    if player_nation[playername] == nation then return true end
    if invites[nation] and invites[nation][playername] then return true end
    return false
end
local function ban_player_from_nation(nation, target, by, reason)
    if not nation or not target then return false end
    bans[nation] = bans[nation] or {}
    bans[nation][target] = { by = by or "unknown", time = os.time(), reason = reason or "" }
    save_bans()
    if invites[nation] then invites[nation][target] = nil end
    if player_invite[target] == nation then player_invite[target] = nil end
    return true
end
local function unban_player_from_nation(nation, target)
    if not nation or not target then return false end
    if bans[nation] then
        bans[nation][target] = nil
        local empty = true
        for _ in pairs(bans[nation]) do empty = false break end
        if empty then bans[nation] = nil end
        save_bans()
    end
    return true
end
local function invite_player_to_nation(nation, target, by)
    if not nation or not target then return false end
    invites[nation] = invites[nation] or {}
    invites[nation][target] = { by = by or "unknown", time = os.time() }
    player_invite[target] = nation
    return true
end
local function uninvite_player_from_nation(nation, target)
    if not nation or not target then return false end
    if invites[nation] then
        invites[nation][target] = nil
        local empty = true
        for _ in pairs(invites[nation]) do empty = false break end
        if empty then invites[nation] = nil end
    end
    if player_invite[target] == nation then player_invite[target] = nil end
    return true
end
minetest.register_on_leaveplayer(function(player)
    local pname = player:get_player_name()
    local nation = player_invite[pname]
    if nation then
        if invites[nation] then invites[nation][pname] = nil end
        player_invite[pname] = nil
        if invites[nation] then
            local empty = true
            for _ in pairs(invites[nation]) do empty = false break end
            if empty then invites[nation] = nil end
        end
    end
    if pending_teleports[pname] then
        pending_teleports[pname] = nil
    end
end)
local function dist2(a, b)
    local dx = a.x - b.x
    local dy = a.y - b.y
    local dz = a.z - b.z
    return dx*dx + dy*dy + dz*dz
end
local function start_delayed_teleport(player, target_pos)
    local pname = player:get_player_name()
    if minetest.check_player_privs(pname, {server = true}) then
        player:set_pos(target_pos)
        minetest.chat_send_player(pname, "[NATIONS] Téléportation instantanée (admin).")
        return
    end
    if pending_teleports[pname] then
        minetest.chat_send_player(pname, "[NATIONS] Téléportation déjà en cours.")
        return
    end
    local pos = player:get_pos()
    local hp = (player.get_hp and player:get_hp()) or nil
    pending_teleports[pname] = {
        remaining = TELEPORT_DELAY,
        target = { x = target_pos.x, y = target_pos.y, z = target_pos.z },
        start_pos = { x = pos.x, y = pos.y, z = pos.z },
        start_hp = hp
    }
    minetest.chat_send_player(pname,
        "[NATIONS] Téléportation dans " .. TELEPORT_DELAY .. " secondes... Ne bouge pas.")
end
local function cancel_delayed_teleport(pname, reason)
    if not pending_teleports[pname] then return end
    pending_teleports[pname] = nil
    if reason then
        minetest.chat_send_player(pname, "[NATIONS] Téléportation annulée : " .. reason)
    else
        minetest.chat_send_player(pname, "[NATIONS] Téléportation annulée.")
    end
end
minetest.register_globalstep(function(dtime)
    if not next(pending_teleports) then return end
    for pname, info in pairs(pending_teleports) do
        local player = minetest.get_player_by_name(pname)
        if not player then
            pending_teleports[pname] = nil
        else
            local pos = player:get_pos()
            if not pos then
                cancel_delayed_teleport(pname, "position inconnue.")
            else
                if dist2(pos, info.start_pos) > (MOVE_TOLERANCE * MOVE_TOLERANCE) then
                    cancel_delayed_teleport(pname, "tu as bougé.")
                else
                    local hp = (player.get_hp and player:get_hp()) or nil
                    if hp and info.start_hp and hp < info.start_hp then
                        cancel_delayed_teleport(pname, "tu as subi des dégâts.")
                    else
                        local vel = (player.get_velocity and player:get_velocity()) or { x = 0, y = 0, z = 0 }
                        local speed2 = vel.x*vel.x + vel.y*vel.y + vel.z*vel.z
                        if speed2 > (VELOCITY_TOLERANCE * VELOCITY_TOLERANCE) then
                            cancel_delayed_teleport(pname, "tu as été déplacé.")
                        else
                            info.remaining = info.remaining - dtime
                            if info.remaining <= 0 then
                                player:set_pos(info.target)
                                minetest.chat_send_player(pname, "[NATIONS] Téléportation effectuée.")
                                pending_teleports[pname] = nil
                            else
                                local rem = math.ceil(info.remaining)
                                if rem == 3 or rem == 2 or rem == 1 then
                                    minetest.chat_send_player(pname, "[NATIONS] Téléportation dans " .. rem .. "s...")
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)
minetest.register_chatcommand("f", {
    params = "<claim|unclaim|show|ban|unban|banlist|invite|uninvite|invitelist|sethome|home> [args]",
    description = "Gestion des claims, invitations, bannissements et home de nation",
    privs = { interact = true },
    func = function(name, param)
        local cmd, rest = param:match("^(%S*)%s*(.-)$")
        cmd = norm(cmd)
        rest = norm(rest)
        if cmd == "ban" then
            local target = rest
            if target == "" then return false, "[NATIONS] Utilisation : /f ban <pseudo>" end
            local nation = player_nation[name]
            if not nation then return false, "[NATIONS] Tu dois appartenir à une nation." end
            if nations[nation].owner ~= name then return false, "[NATIONS] Seul le fondateur peut bannir un joueur." end
            if target == name then return false, "[NATIONS] Tu ne peux pas te bannir toi-même." end
            ban_player_from_nation(nation, target, name, "")
            return true, "[NATIONS] Le joueur " .. player_color(target) .. " est banni de la nation « " .. nation_color(nation) .. " »."
        end
        if cmd == "unban" then
            local target = rest
            if target == "" then return false, "[NATIONS] Utilisation : /f unban <pseudo>" end
            local nation = player_nation[name]
            if not nation then return false, "[NATIONS] Tu dois appartenir à une nation." end
            if nations[nation].owner ~= name then return false, "[NATIONS] Seul le fondateur peut débannir un joueur." end
            unban_player_from_nation(nation, target)
            return true, "[NATIONS] Le joueur " .. player_color(target) .. " est désormais autorisé dans la nation « " .. nation_color(nation) .. " »."
        end
        if cmd == "banlist" then
            local nation = player_nation[name]
            if not nation then return false, "[NATIONS] Tu dois appartenir à une nation." end
            local bn = bans[nation]
            if not bn then return true, "[NATIONS] Aucun joueur banni pour la nation « " .. nation_color(nation) .. " »." end
            local lines = {}
            for p, info in pairs(bn) do
                local t = os.date("%Y-%m-%d %H:%M", info.time or 0)
                local by = info.by or "?"
                table.insert(lines, player_color(p) .. " (banni par " .. player_color(by) .. " le " .. t .. (info.reason and (" — " .. info.reason) or "") .. ")")
            end
            table.sort(lines)
            return true, "[NATIONS] Bannissements pour « " .. nation_color(nation) .. " » :\n" .. table.concat(lines, "\n")
        end
        if cmd == "invite" then
            local target = rest
            if target == "" then return false, "[NATIONS] Utilisation : /f invite <pseudo>" end
            local nation = player_nation[name]
            if not nation then return false, "[NATIONS] Tu dois appartenir à une nation pour inviter." end
            if nations[nation].owner ~= name then return false, "[NATIONS] Seul le fondateur peut inviter un joueur." end
            if target == name then return false, "[NATIONS] Tu es déjà membre." end
            if bans[nation] and bans[nation][target] then return false, "[NATIONS] Ce joueur est banni de ta nation." end
            invite_player_to_nation(nation, target, name)
            minetest.chat_send_player(target, "[NATIONS] Tu as été invité par " .. player_color(name) .. " à interagir dans la nation « " .. nation_color(nation) .. " ». L'invitation est valable tant que tu restes connecté.")
            return true, "[NATIONS] Le joueur " .. player_color(target) .. " est invité pour la nation « " .. nation_color(nation) .. " »."
        end
        if cmd == "uninvite" then
            local target = rest
            if target == "" then return false, "[NATIONS] Utilisation : /f uninvite <pseudo>" end
            local nation = player_nation[name]
            if not nation then return false, "[NATIONS] Tu dois appartenir à une nation pour retirer une invitation." end
            if nations[nation].owner ~= name then return false, "[NATIONS] Seul le fondateur peut retirer une invitation." end
            uninvite_player_from_nation(nation, target)
            minetest.chat_send_player(target, "[NATIONS] Ton invitation pour la nation « " .. nation_color(nation) .. " » a été retirée par " .. player_color(name) .. ".")
            return true, "[NATIONS] L'invitation de " .. player_color(target) .. " a été retirée."
        end
        if cmd == "invitelist" then
            local nation = player_nation[name]
            if not nation then return false, "[NATIONS] Tu dois appartenir à une nation." end
            if not invites[nation] then return true, "[NATIONS] Aucun joueur invité pour la nation « " .. nation_color(nation) .. " »." end
            local lines = {}
            for p, info in pairs(invites[nation]) do
                local t = os.date("%Y-%m-%d %H:%M", info.time or 0)
                table.insert(lines, player_color(p) .. " (invité par " .. player_color(info.by or "?") .. " le " .. t .. ")")
            end
            table.sort(lines)
            return true, "[NATIONS] Invitations pour « " .. nation_color(nation) .. " » :\n" .. table.concat(lines, "\n")
        end
        if cmd == "claim" or param == "claim" then
            local nation = player_nation[name]
            if not nation then return false, "[NATIONS] Tu dois appartenir à une nation pour claim." end
            local player = minetest.get_player_by_name(name)
            if not player then return false end
            local pos = player:get_pos()
            local cx, cz = get_chunk(pos)
            local key = cx .. "," .. cz
            if claims[key] then return false, "[NATIONS] Ce chunk est déjà claim par la nation « " .. nation_color(claims[key]) .. " »." end
            claims[key] = nation
            save_claims()
            minetest.chat_send_all("[NATIONS] " .. player_color(name) .. " (nation « " .. nation_color(nation) .. " ») vient de claim un chunk !")
            return true
        end
        if cmd == "unclaim" or param == "unclaim" then
            local nation = player_nation[name]
            if not nation then return false, "[NATIONS] Tu dois appartenir à une nation pour unclaim." end
            local player = minetest.get_player_by_name(name)
            if not player then return false end
            local pos = player:get_pos()
            local cx, cz = get_chunk(pos)
            local key = cx .. "," .. cz
            if not claims[key] then return false, "[NATIONS] Ce chunk n'est claim par aucune nation." end
            if claims[key] ~= nation then return false, "[NATIONS] Ce chunk appartient à la nation « " .. nation_color(claims[key]) .. " », pas à la tienne." end
            claims[key] = nil
            save_claims()
            minetest.chat_send_player(name, "[NATIONS] Le chunk a été déclaim avec succès.")
            return true
        end
        if cmd == "show" or param == "show" then
            show_claims[name] = not show_claims[name]
            if show_claims[name] then
                minetest.chat_send_player(name, "[NATIONS] Affichage des bordures activé.")
            else
                minetest.chat_send_player(name, "[NATIONS] Affichage des bordures désactivé.")
            end
            return true
        end
        if cmd == "sethome" then
            local nation = player_nation[name]
            if not nation then
                return false, "[NATIONS] Tu dois appartenir à une nation."
            end
            if nations[nation].owner ~= name then
                return false, "[NATIONS] Seul le fondateur peut définir le home."
            end
            local player = minetest.get_player_by_name(name)
            if not player then return false end
            local pos = player:get_pos()
            nations_home[nation] = { x = pos.x, y = pos.y, z = pos.z }
            if save_nations_home then save_nations_home() end
            return true, "[NATIONS] Le home de la nation « " .. nation_color(nation) .. " » a été défini."
        end
if cmd == "home" then
    local target_nation
    if rest ~= "" then
        target_nation = rest
        if not nations[target_nation] then
            return false, "[NATIONS] Cette nation n'existe pas."
        end
    else
        target_nation = player_nation[name]
        if not target_nation then
            return false, "[NATIONS] Tu dois appartenir à une nation."
        end
    end
    local home = nations_home[target_nation]
    if not home then
        return false, "[NATIONS] Aucun home n'a été défini pour la nation « " .. nation_color(target_nation) .. " »."
    end
    local player = minetest.get_player_by_name(name)
    if not player then return false end
    if minetest.check_player_privs(name, {server = true}) then
        player:set_pos(home)
        return true, "[NATIONS] Téléportation instantanée vers la nation « " .. nation_color(target_nation) .. " »."
    end
    start_delayed_teleport(player, home)
    return true, "[NATIONS] Téléportation en cours vers la nation « " .. nation_color(target_nation) .. " »..."
end
        return false, "Paramètre inconnu. Utilise " ..
            command_color("/f claim") .. ", " ..
            command_color("/f unclaim") .. ", " ..
            command_color("/f show") .. ", " ..
            command_color("/f ban") .. ", " ..
            command_color("/f invite") .. ", " ..
            command_color("/f sethome") .. ", " ..
            command_color("/f home")
    end
})
local _orig_is_protected = minetest.is_protected
minetest.is_protected = function(pos, name)
    if not name then
        if _orig_is_protected then
            return _orig_is_protected(pos, name)
        end
        return false
    end
    if minetest.check_player_privs(name, {server = true}) then
        return false
    end
    local cx, cz = get_chunk(pos)
    local key = cx .. "," .. cz
    local nation = claims[key]
    if not nation then
        return false
    end
    if is_banned_from_chunk(name, cx, cz) then
        return true
    end
    if player_nation[name] == nation then
        return false
    end
    if invites[nation] and invites[nation][name] then
        return false
    end
    return true
end
minetest.register_on_protection_violation(function(pos, name)
    if not name then return end
    local cx, cz = get_chunk(pos)
    local key = cx .. "," .. cz
    local nation = claims[key]
    if not nation then return end
    if is_banned_from_chunk(name, cx, cz) then
        minetest.chat_send_player(name, "[NATIONS] Tu es banni de cette nation, tu ne peux pas interagir ici.")
        return true
    end
    if player_nation[name] ~= nation and not (invites[nation] and invites[nation][name]) then
        minetest.chat_send_player(name, "[NATIONS] Tu ne peux pas interagir ici, ce chunk appartient à la nation « " .. nation_color(nation) .. " ».")
        return true
    end
end)
minetest.register_on_placenode(function(pos, newnode, placer)
    if not placer then return end
    local pname = placer:get_player_name()
    local cx, cz = get_chunk(pos)
    local key = cx .. "," .. cz
    local nation = claims[key]
    if not nation then return end
    if is_banned_from_chunk(pname, cx, cz) then
        minetest.chat_send_player(pname, "[NATIONS] Tu es banni de cette nation, tu ne peux pas construire ici.")
        return true
    end
    if player_nation[pname] == nation or (invites[nation] and invites[nation][pname]) then
        return
    end
    minetest.chat_send_player(pname, "[NATIONS] Tu ne peux pas construire ici, ce chunk appartient à la nation « " .. nation_color(nation) .. " ».")
    return true
end)
minetest.register_on_dignode(function(pos, oldnode, digger)
    if not digger then return end
    local pname = digger:get_player_name()
    local cx, cz = get_chunk(pos)
    local key = cx .. "," .. cz
    local nation = claims[key]
    if not nation then return end
    if is_banned_from_chunk(pname, cx, cz) then
        minetest.chat_send_player(pname, "[NATIONS] Tu es banni de cette nation, tu ne peux pas casser ici.")
        return true
    end
    if player_nation[pname] == nation or (invites[nation] and invites[nation][pname]) then
        return
    end
    minetest.chat_send_player(pname, "[NATIONS] Tu ne peux pas casser ici, ce chunk appartient à la nation « " .. nation_color(nation) .. " ».")
    return true
end)
local function chest_open_allowed(clicker, pos)
    if not clicker then return false end
    local pname = clicker:get_player_name()
    local cx, cz = get_chunk(pos)
    local key = cx .. "," .. cz
    local nation = claims[key]
    if not nation then return true end
    if is_banned_from_chunk(pname, cx, cz) then return false end
    if player_nation[pname] == nation then return true end
    return false
end
local chest_nodes = {
    "default:chest",
    "default:chest_open",
    "default:chest_locked",
    "default:chest_locked_open"
}
for _, nodename in ipairs(chest_nodes) do
    local node_def = minetest.registered_nodes[nodename]
    if node_def then
        local orig_on_rightclick = node_def.on_rightclick
        minetest.override_item(nodename, {
            on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
                local pname = clicker and clicker:get_player_name() or nil
                if not pname then return itemstack end
                if not chest_open_allowed(clicker, pos) then
                    local cx, cz = get_chunk(pos)
                    if is_banned_from_chunk(pname, cx, cz) then
                        minetest.chat_send_player(pname, "[NATIONS] Tu es banni de cette nation, tu ne peux pas ouvrir les coffres ici.")
                    else
                        local key = cx .. "," .. cz
                        local nation = claims[key]
                        if nation then
                            minetest.chat_send_player(pname, "[NATIONS] Tu ne peux pas ouvrir ce coffre, il appartient à la nation « " .. nation_color(nation) .. " ».")
                        else
                            minetest.chat_send_player(pname, "[NATIONS] Tu ne peux pas ouvrir ce coffre ici.")
                        end
                    end
                    return itemstack
                end
                if orig_on_rightclick then
                    return orig_on_rightclick(pos, node, clicker, itemstack, pointed_thing)
                end
                return itemstack
            end
        })
    end
end
local function update_hud(player, nation)
    local pname = player:get_player_name()
    local text = nation and ("Territoire : " .. nation) or "Territoire : Aucun"
    local color = nation and 0xFF9900 or 0xFFFFFF
    if hud_ids[pname] then
        player:hud_change(hud_ids[pname], "text", text)
        player:hud_change(hud_ids[pname], "number", color)
        return
    end
    hud_ids[pname] = player:hud_add({
        hud_elem_type = "text",
        position = { x = 1, y = 0 },
        offset = { x = -20, y = 20 },
        alignment = { x = -1, y = 1 },
        scale = { x = 100, y = 100 },
        number = color,
        text = text
    })
end
local function particle_for_player(player, x, y, z)
    minetest.add_particle({
        pos = { x = x, y = y, z = z },
        velocity = { x = 0, y = 0, z = 0 },
        expirationtime = 0.2,
        size = 3,
        collisiondetection = false,
        vertical = false,
        texture = "claim_red.png",
        playername = player:get_player_name(),
    })
end
local function show_chunk_border(player, cx, cz)
    local y = 9
    local x1 = cx * 16
    local x2 = x1 + 16
    local z1 = cz * 16
    local z2 = z1 + 16
    for z = z1, z2 do particle_for_player(player, x1, y, z) end
    for z = z1, z2 do particle_for_player(player, x2, y, z) end
    for x = x1, x2 do particle_for_player(player, x, y, z1) end
    for x = x1, x2 do particle_for_player(player, x, y, z2) end
end
local last_chunk = {}
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        local pname = player:get_player_name()
        local pos = player:get_pos()
        if not pos then goto continue end
        local cx, cz = get_chunk(pos)
        local key = cx .. "," .. cz
        if last_chunk[pname] ~= key then
            update_hud(player, claims[key])
            last_chunk[pname] = key
        end
        if show_claims[pname] then
            for k, nation in pairs(claims) do
                local scx, scz = k:match("(-?%d+),(-?%d+)")
                if scx and scz then
                    show_chunk_border(player, tonumber(scx), tonumber(scz))
                end
            end
        end
        ::continue::
    end
end)
nations_gestions.bans = bans
nations_gestions.save_bans = save_bans
nations_gestions.ban_player_from_nation = ban_player_from_nation
nations_gestions.unban_player_from_nation = unban_player_from_nation
nations_gestions.is_banned_from_chunk = is_banned_from_chunk
nations_gestions.invites = invites
nations_gestions.player_invite = player_invite
nations_gestions.invite_player_to_nation = invite_player_to_nation
nations_gestions.uninvite_player_from_nation = uninvite_player_from_nation
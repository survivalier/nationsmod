local modname = minetest.get_current_modname()
local worldpath = minetest.get_worldpath()
local bank_file = worldpath .. "/" .. modname .. "_nations_bank.json"
local playtime_file = worldpath .. "/" .. modname .. "_playtime.json"
local last_collect_file = worldpath .. "/" .. modname .. "_last_collect.json"
nations_bank = nations_bank or {}
local bank = {}
local total_playtime = {}
local join_time = {}
local last_collect = {}

local function load_json_file(path, default)
    local f = io.open(path, "r")
    if not f then return default end
    local data = f:read("*a")
    f:close()
    return minetest.parse_json(data) or default
end
local function save_json_file(path, tbl)
    local f = io.open(path, "w")
    if not f then return false end
    f:write(minetest.write_json(tbl))
    f:close()
    return true
end
local function load_bank() bank = load_json_file(bank_file, {}) end
local function save_bank() save_json_file(bank_file, bank) end
local function load_playtime() total_playtime = load_json_file(playtime_file, {}) end
local function save_playtime() save_json_file(playtime_file, total_playtime) end
local function load_last_collect() last_collect = load_json_file(last_collect_file, {}) end
local function save_last_collect() save_json_file(last_collect_file, last_collect) end

local function get_balance(playername)
    if not playername then return 0 end
    return bank[playername] or 0
end
local function set_balance(playername, amount)
    if not playername then return false end
    bank[playername] = math.max(0, math.floor(amount))
    save_bank()
    return true
end
local function add_balance(playername, amount)
    if not playername then return false end
    local cur = get_balance(playername)
    bank[playername] = math.max(0, math.floor(cur + amount))
    save_bank()
    return true
end
local function sub_balance(playername, amount)
    if not playername then return false end
    local cur = get_balance(playername)
    if amount > cur then return false end
    bank[playername] = math.max(0, math.floor(cur - amount))
    save_bank()
    return true
end
nations_bank.get_balance = get_balance
nations_bank.set_balance = set_balance
nations_bank.add_balance = add_balance
nations_bank.sub_balance = sub_balance
nations_bank.save = save_bank
load_bank()
load_playtime()
load_last_collect()
minetest.register_on_joinplayer(function(player)
    local pname = player:get_player_name()
    join_time[pname] = os.time()
    total_playtime[pname] = total_playtime[pname] or 0
end)
minetest.register_on_leaveplayer(function(player)
    local pname = player:get_player_name()
    local jt = join_time[pname]
    if jt then
        local delta = os.time() - jt
        total_playtime[pname] = (total_playtime[pname] or 0) + delta
        join_time[pname] = nil
        save_playtime()
    end
end)
local function current_total_playtime(playername)
    local t = total_playtime[playername] or 0
    if join_time[playername] then
        t = t + (os.time() - join_time[playername])
    end
    return t
end
local function get_last_collect(playername)
    local v = last_collect[playername]
    if v == nil then
        v = current_total_playtime(playername)
        last_collect[playername] = v
        save_last_collect()
    end
    return v
end
local function set_last_collect(playername, value)
    last_collect[playername] = value
    save_last_collect()
end

local function player_color(name)
    return minetest.colorize("#ff4040", name)
end
local function format_money(n)
    return "$" .. tostring(n)
end
local hud_ids = {}
local LABEL_OFFSET = { x = -200, y = 45 }
local AMOUNT_OFFSET = { x = -150, y = 45 }
local function create_or_update_hud(player)
    if not player then return end
    local pname = player:get_player_name()
    local bal = get_balance(pname)
    local label_text = "Banque :"
    local amount_text = format_money(bal)
    if hud_ids[pname] then
        pcall(function()
            if hud_ids[pname].label then player:hud_change(hud_ids[pname].label, "text", label_text) end
            if hud_ids[pname].amount then player:hud_change(hud_ids[pname].amount, "text", amount_text) end
        end)
        return
    end
    minetest.after(0.6, function()
        if hud_ids[pname] then
            local pl = minetest.get_player_by_name(pname)
            if pl then
                pcall(function()
                    if hud_ids[pname].label then pl:hud_change(hud_ids[pname].label, "text", label_text) end
                    if hud_ids[pname].amount then pl:hud_change(hud_ids[pname].amount, "text", amount_text) end
                end)
            end
            return
        end
        local pl = minetest.get_player_by_name(pname)
        if not pl then return end
        local ok, label_id = pcall(function()
            return pl:hud_add({
                type = "text",
                position = { x = 1, y = 0 },
                offset = LABEL_OFFSET,
                text = label_text,
                number = 0xFFFFFF,
                alignment = { x = 1, y = 0 },
                scale = { x = 100, y = 100 },
            })
        end)
        local ok2, amount_id = pcall(function()
            return pl:hud_add({
                type = "text",
                position = { x = 1, y = 0 },
                offset = AMOUNT_OFFSET,
                text = amount_text,
                number = 0x00FF00,
                alignment = { x = 1, y = 0 },
                scale = { x = 100, y = 100 },
            })
        end)
        hud_ids[pname] = { label = (ok and label_id) or nil, amount = (ok2 and amount_id) or nil }
    end)
end
local function remove_hud(player)
    if not player then return end
    local pname = player:get_player_name()
    if not hud_ids[pname] then return end
    pcall(function()
        if hud_ids[pname].label then player:hud_remove(hud_ids[pname].label) end
        if hud_ids[pname].amount then player:hud_remove(hud_ids[pname].amount) end
    end)
    hud_ids[pname] = nil
end
minetest.register_on_joinplayer(function(player)
    minetest.after(0.8, function() create_or_update_hud(player) end)
end)
minetest.register_on_leaveplayer(function(player)
    remove_hud(player)
end)
minetest.register_chatcommand("pay", {
    params = "<player> <amount>",
    description = "Payer un autre joueur",
    privs = { interact = true },
    func = function(name, param)
        local target, amt = param:match("^(%S+)%s+(%S+)$")
        if not target or not amt then return false, "[BANK] Utilisation : /pay <player> <montant>" end
        local amount = tonumber(amt)
        if not amount or amount <= 0 then return false, "[BANK] Montant invalide." end
        if target == name then return false, "[BANK] Tu ne peux pas te payer toi-même." end
        if amount > get_balance(name) then return false, "[BANK] Solde insuffisant." end
        add_balance(target, amount)
        sub_balance(name, amount)
        local tp = minetest.get_player_by_name(target)
        if tp then create_or_update_hud(tp) end
        local sp = minetest.get_player_by_name(name)
        if sp then create_or_update_hud(sp) end
        minetest.chat_send_player(name, "[BANK] Tu as payé " .. player_color(target) .. " " .. minetest.colorize("#00FF00", format_money(amount)) .. ". Nouveau solde : " .. minetest.colorize("#00FF00", format_money(get_balance(name))))
        if tp then minetest.chat_send_player(target, "[BANK] Tu as reçu " .. minetest.colorize("#00FF00", format_money(amount)) .. " de " .. player_color(name) .. ". Nouveau solde : " .. minetest.colorize("#00FF00", format_money(get_balance(target)))) end
        return true
    end
})
minetest.register_chatcommand("balance", {
    params = "[player]",
    description = "Afficher le solde (seuls les admins peuvent voir le solde des autres)",
    privs = { interact = true },
    func = function(name, param)
        local target = (param ~= "" and param) or name
        if target ~= name then
            if not minetest.check_player_privs(name, { server = true }) then
                return false, "[BANK] Accès refusé. Seuls les admins peuvent voir le solde des autres."
            end
            return true, "[BANK] Solde de " .. player_color(target) .. " : " .. minetest.colorize("#00FF00", format_money(get_balance(target)))
        end
        return true, "[BANK] Ton solde : " .. minetest.colorize("#00FF00", format_money(get_balance(name)))
    end
})
minetest.register_globalstep(function(dtime)
    nations_bank._save_acc = (nations_bank._save_acc or 0) + dtime
    if nations_bank._save_acc >= 60 then
        nations_bank._save_acc = 0
        save_bank()
        save_playtime()
        save_last_collect()
    end
end)
minetest.register_on_shutdown(function()
    for pname, jt in pairs(join_time) do
        local delta = os.time() - jt
        total_playtime[pname] = (total_playtime[pname] or 0) + delta
        join_time[pname] = nil
    end
    save_bank()
    save_playtime()
    save_last_collect()
end)
local collector_name = modname .. ":collector"
local function format_seconds(sec)
    sec = math.max(0, math.floor(sec or 0))
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = sec % 60
    if h > 0 then return string.format("%dh %02dm %02ds", h, m, s) end
    if m > 0 then return string.format("%dm %02ds", m, s) end
    return string.format("%ds", s)
end
local function accumulated_from_elapsed(elapsed_seconds)
    return math.floor(elapsed_seconds / 60) * 2
end
local function pos_to_string(pos) return pos.x .. "," .. pos.y .. "," .. pos.z end
local function string_to_pos(s)
    local x, y, z = s:match("(-?%d+),(-?%d+),(-?%d+)")
    if not x then return nil end
    return { x = tonumber(x), y = tonumber(y), z = tonumber(z) }
end
local function collector_formspec(pos, viewer_name)
    local last_play = get_last_collect(viewer_name)
    local now_play = current_total_playtime(viewer_name)
    local elapsed = math.max(0, now_play - last_play)
    local accumulated = accumulated_from_elapsed(elapsed)
    local fs = "size[8,6]" ..
               "image[0.2,0.2;3.6,5.6;" .. modname .. "_bankbackground.png]" ..
               "label[4.2,0.6;Joueur: " .. minetest.formspec_escape(viewer_name) .. "]" ..
               "label[4.2,1.4;Temps joué depuis dernière récolte:]" ..
               "label[4.2,2.0;" .. minetest.formspec_escape(format_seconds(elapsed)) .. "]" ..
               "label[4.2,3.0;Montant accumulé: " .. minetest.formspec_escape(format_money(accumulated)) .. "]" ..
               "button[4.2,4.2;3.2,0.8;collector_collect;Récupérer]" ..
               "label[4.2,5.2;2$ toutes les 1 minute de jeu]"
    return fs
end
minetest.register_node(collector_name, {
    description = "Collecteur d'argent",
    drawtype = "mesh",
    mesh = "atm.obj",
    tiles = { "atm.png" },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { cracky = 2, oddly_breakable_by_hand = 1 },
    selection_box = {
        type = "fixed",
        fixed = { -0.5, -0.5, -0.5, 0.5, 1.5, 0.5 }
    },
    collision_box = {
        type = "fixed",
        fixed = { -0.5, -0.5, -0.5, 0.5, 1.5, 0.5 }
    },
    after_place_node = function(pos, placer, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos)
        meta:set_string("placed_time", tostring(os.time()))
        if placer and type(placer.get_player_name) == "function" then
            meta:set_string("placed_by", placer:get_player_name())
        end
    end,
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        if not clicker or type(clicker.get_player_name) ~= "function" then
            return
        end
        local pname = clicker:get_player_name()
        if not pname then return end
        local fs = collector_formspec(pos, pname)
        local formspec_name = "nations_bank:collector_formspec:" .. pos_to_string(pos)
        minetest.show_formspec(pname, formspec_name, fs)
    end,
})
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if not formname:match("^nations_bank:collector_formspec:") then return end
    local pos_str = formname:match("^nations_bank:collector_formspec:(.+)$")
    if not pos_str then return end
    local pos = string_to_pos(pos_str)
    if not pos then return end
    local pname = player:get_player_name()
    local meta = minetest.get_meta(pos)
    if not meta then
        minetest.chat_send_player(pname, "[COLLECTEUR] Collecteur introuvable.")
        return
    end
    if fields.collector_collect then
        local last_play = get_last_collect(pname)
        local now_play = current_total_playtime(pname)
        local elapsed = math.max(0, now_play - last_play)
        local accumulated = accumulated_from_elapsed(elapsed)
        if accumulated <= 0 then
            minetest.chat_send_player(pname, "[COLLECTEUR] Aucun montant à récupérer pour l'instant.")
            minetest.show_formspec(pname, formname, collector_formspec(pos, pname))
            return
        end
        add_balance(pname, accumulated)
        set_last_collect(pname, now_play)
        local pl = minetest.get_player_by_name(pname)
        if pl then create_or_update_hud(pl) end
        minetest.chat_send_player(pname, "[COLLECTEUR] Tu as récupéré " .. minetest.colorize("#00FF00", format_money(accumulated)) .. " depuis ce collecteur.")
        save_bank()
        save_playtime()
        minetest.show_formspec(pname, formname, collector_formspec(pos, pname))
    end
end)
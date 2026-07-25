local DEFAULT_PRICE = 7
local CUSTOM_PRICES = {
    -- Exemple :
    -- ["default:stone"] = 5,
    -- ["default:dirt"]  = 3,
}
local function bank_get_balance(name)
    if nations_bank and nations_bank.get_balance then
        return nations_bank.get_balance(name)
    end
    return 0
end
local function bank_add_balance(name, amount)
    if nations_bank and nations_bank.add_balance then
        nations_bank.add_balance(name, amount)
        nations_bank.save()
        return true
    end
    return false
end
local function bank_sub_balance(name, amount)
    if nations_bank and nations_bank.sub_balance then
        nations_bank.sub_balance(name, amount)
        nations_bank.save()
        return true
    end
    return false
end
local ALL_NODES = {}
local function build_node_list()
    ALL_NODES = {}
    for name, def in pairs(minetest.registered_nodes) do
        if not def.groups or (not def.groups.not_in_creative_inventory) then
            table.insert(ALL_NODES, name)
        end
    end
    table.sort(ALL_NODES)
end
build_node_list()
local PAGE_SIZE = 4 * 8
local function get_page_count()
    return math.max(1, math.ceil(#ALL_NODES / PAGE_SIZE))
end
local function get_price(node_name)
    return CUSTOM_PRICES[node_name] or DEFAULT_PRICE
end
local worldpath = minetest.get_worldpath()
local price_file = worldpath .. "/nations_shop_prices.json"
local function load_prices()
    local f = io.open(price_file, "r")
    if not f then return end
    local data = f:read("*a")
    f:close()
    local t = minetest.parse_json(data)
    if type(t) == "table" then
        CUSTOM_PRICES = t
    end
end
local function save_prices()
    local f = io.open(price_file, "w")
    if not f then return end
    f:write(minetest.write_json(CUSTOM_PRICES))
    f:close()
end
load_prices()
local function get_shop_formspec(player_name, page, selected_node, qty)
    local page_count = get_page_count()
    if page < 1 then page = 1 end
    if page > page_count then page = page_count end
    local start_index = (page - 1) * PAGE_SIZE + 1
    local end_index = math.min(#ALL_NODES, start_index + PAGE_SIZE - 1)
    if not qty or qty < 1 then qty = 1 end
    local fs = {}
    table.insert(fs, "size[10,8]")
    table.insert(fs, "label[0,0;Nations Shop]")
    table.insert(fs, "label[6,0;Page " .. page .. "/" .. page_count .. "]")
    local row = 0
    local col = 0
    for i = start_index, end_index do
        local node_name = ALL_NODES[i]
        local x = col * 1.0
        local y = 1 + row * 1.0
        table.insert(fs,
            "item_image_button[" .. x .. "," .. y .. ";1,1;" ..
            node_name .. ";node_" .. i .. ";]")
        col = col + 1
        if col >= 8 then
            col = 0
            row = row + 1
        end
    end
    table.insert(fs, "button[6,1;2,1;prev_page;<<]")
    table.insert(fs, "button[8,1;2,1;next_page;>>]")
    local desc = ""
    local price = 0
    if selected_node then
        local def = minetest.registered_nodes[selected_node]
        desc = def and def.description or selected_node
        price = get_price(selected_node)
    end
    table.insert(fs, "box[0,5;10,0.1;#FFFFFF]")
    table.insert(fs, "label[0,5.2;Bloc sélectionné :]")
    if selected_node then
        table.insert(fs, "item_image[0,5.7;1,1;" .. selected_node .. "]")
        table.insert(fs, "label[1.2,5.7;" .. minetest.formspec_escape(desc) .. "]")
        table.insert(fs, "label[1.2,6.2;Prix à l'unité : " .. price .. " dollars]")
    else
        table.insert(fs, "label[0,5.7;Aucun bloc sélectionné]")
    end
    table.insert(fs, "field[6,5.7;2,1;qty;Quantité;" .. qty .. "]")
    if selected_node then
        local total = price * qty
        table.insert(fs, "label[6,6.2;Total : " .. total .. " dollars]")
        table.insert(fs, "button[8,5.7;2,1;pay;Payer]")
    else
        table.insert(fs, "label[6,6.2;Total : -]")
    end
    local balance = bank_get_balance(player_name)
    table.insert(fs, "label[0,7.2;Solde : " .. balance .. " dollars]")
    return table.concat(fs, "")
end
local player_state = {}
local function get_state(name)
    if not player_state[name] then
        player_state[name] = {
            page = 1,
            selected_node = nil,
            qty = 1,
        }
    end
    return player_state[name]
end
local function show_shop(name)
    local st = get_state(name)
    local fs = get_shop_formspec(name, st.page, st.selected_node, st.qty)
    minetest.show_formspec(name, "nations_shop:main", fs)
end
minetest.register_chatcommand("shop", {
    description = "Ouvrir le Nations Shop",
    privs = { interact = true },
    func = function(name, param)
        show_shop(name)
        return true
    end
})
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "nations_shop:main" then
        return false
    end
    local name = player:get_player_name()
    local st = get_state(name)
    if fields.prev_page then
        st.page = st.page - 1
        if st.page < 1 then st.page = 1 end
    end
    if fields.next_page then
        st.page = st.page + 1
        local pc = get_page_count()
        if st.page > pc then st.page = pc end
    end
    for k, _ in pairs(fields) do
        if k:sub(1, 5) == "node_" then
            local idx = tonumber(k:sub(6))
            if idx and ALL_NODES[idx] then
                st.selected_node = ALL_NODES[idx]
            end
        end
    end
    if fields.qty then
        local q = tonumber(fields.qty)
        if q and q > 0 then
            st.qty = math.floor(q)
        else
            st.qty = 1
        end
    end
    if fields.pay and st.selected_node then
        local price = get_price(st.selected_node)
        local qty = st.qty or 1
        local total = price * qty
        local balance = bank_get_balance(name)
        if balance < total then
            minetest.chat_send_player(name,
                "[NATIONS_SHOP] Solde insuffisant. Il te manque " .. (total - balance) .. " dollars.")
        else
            if not bank_sub_balance(name, total) then
                minetest.chat_send_player(name,
                    "[NATIONS_SHOP] Erreur : impossible de débiter ton compte.")
            else
                local inv = player:get_inventory()
                local stack = ItemStack(st.selected_node .. " " .. qty)
                inv:add_item("main", stack)
                minetest.chat_send_player(name,
                    "[NATIONS_SHOP] Achat réussi : " .. qty .. "x " ..
                    st.selected_node .. " pour " .. total .. " dollars.")
            end
        end
    end
    show_shop(name)
    return true
end)
minetest.register_chatcommand("shop_setprice", {
    params = "<node> <prix>",
    description = "Définir un prix custom pour un node",
    privs = { server = true },
    func = function(name, param)
        local node, price = param:match("^(%S+)%s+(%d+)$")
        if not node or not price then
            return false, "Utilisation : /shop_setprice <node> <prix>"
        end
        price = tonumber(price)
        if not minetest.registered_nodes[node] then
            return false, "Node inconnu : " .. node
        end
        CUSTOM_PRICES[node] = price
        save_prices()
        return true, "Prix de " .. node .. " défini à " .. price .. " dollars."
    end
})
local player_inventory = {}

local nations_mods = {
	"nations_inv",
	"nations_stuff",
	"nations_portals",
	"nations_players",
	"nations_flag",
	"nations_decorations",
	"nations_bank"
}

local function is_nations_mod(name)
	local modname = name:match("^([^:]+):")
	if not modname then
		return false
	end
	for _, allowed_mod in ipairs(nations_mods) do
		if modname == allowed_mod then
			return true
		end
	end
	return false
end

local function get_nations_items()
	local items = {}
	for name, def in pairs(minetest.registered_items) do
		if is_nations_mod(name) then
			local groups = def.groups or {}
			if groups.not_in_creative_inventory ~= 1 and def.description and def.description ~= "" then
				items[#items + 1] = name
			end
		end
	end
	table.sort(items)
	return items
end

local function init_nations_inventory(player)
	local player_name = player:get_player_name()
	local inv_name = "nations_" .. player_name

	if minetest.get_inventory({
		type = "detached",
		name = inv_name
	}) then
		minetest.remove_detached_inventory(inv_name)
	end

	player_inventory[player_name] = {
		size = 0,
		start_i = 0
	}

	minetest.create_detached_inventory(inv_name, {
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player2)
			local name = player2 and player2:get_player_name() or ""
			if not minetest.is_creative_enabled(name) or to_list == "main" then
				return 0
			end
			return count
		end,

		allow_put = function()
			return 0
		end,

		allow_take = function(inv, listname, index, stack, player2)
			local name = player2 and player2:get_player_name() or ""
			if not minetest.is_creative_enabled(name) then
				return 0
			end
			return -1
		end,

		on_take = function(inv, listname, index, stack, player2)
			if stack and stack:get_count() > 0 then
				local name = player2 and player2:get_player_name() or ""
				minetest.log("action", name .. " takes " .. stack:get_name() .. " from Nations inventory")
			end
		end
	}, player_name)

	return player_inventory[player_name]
end

local function update_nations_inventory(player_name)
	local inv = player_inventory[player_name]

	if not inv then
		local player = minetest.get_player_by_name(player_name)
		if not player then
			return
		end
		inv = init_nations_inventory(player)
	end

	local detached = minetest.get_inventory({
		type = "detached",
		name = "nations_" .. player_name
	})

	if not detached then
		return
	end

	local items = get_nations_items()

	detached:set_size("main", #items)
	detached:set_list("main", items)

	inv.size = #items

	local page_size = 8 * 4

	if inv.start_i >= inv.size then
		inv.start_i = math.max(0, inv.size - page_size)
	end
end

local trash = minetest.create_detached_inventory("nations_trash", {
	allow_put = function(inv, listname, index, stack, player)
		return stack:get_count()
	end,

	on_put = function(inv, listname)
		inv:set_list(listname, {})
	end,

	allow_take = function()
		return 0
	end,

	allow_move = function()
		return 0
	end
})

trash:set_size("main", 1)

minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	init_nations_inventory(player)
	update_nations_inventory(player_name)
end)

minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
	local inv_name = "nations_" .. player_name

	player_inventory[player_name] = nil

	if minetest.get_inventory({
		type = "detached",
		name = inv_name
	}) then
		minetest.remove_detached_inventory(inv_name)
	end
end)

sfinv.register_page("nations_inv:overview", {
	title = "Nations",

	is_in_nav = function(self, player, context)
		return true
	end,

	get = function(self, player, context)
		local player_name = player:get_player_name()

		update_nations_inventory(player_name)

		local inv = player_inventory[player_name]

		if not inv then
			inv = init_nations_inventory(player)
			update_nations_inventory(player_name)
		end

		local page_size = 8 * 4
		local pagenum = math.floor(inv.start_i / page_size) + 1
		local pagemax = math.max(math.ceil(inv.size / page_size), 1)

		local formspec =
			"label[5.8,4.15;" ..
			minetest.colorize("#FFFF00", tostring(pagenum) .. " / " .. tostring(pagemax)) ..
			"]" ..

			"listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]" ..

			"image[4.08,4.2;0.8,0.8;creative_trash_icon.png]" ..
			"list[detached:nations_trash;main;4.02,4.1;1,1;]" ..

			"image_button[5,4.05;0.8,0.8;creative_prev_icon.png;nations_prev;]" ..
			"image_button[7.25,4.05;0.8,0.8;creative_next_icon.png;nations_next;]" ..

			"tooltip[nations_prev;Page précédente]" ..
			"tooltip[nations_next;Page suivante]" ..

			"listring[detached:nations_" .. player_name .. ";main]" ..

			"list[detached:nations_" ..
			player_name ..
			";main;0,0;8,4;" ..
			tostring(inv.start_i) ..
			"]" ..

			"listring[current_player;main]" ..

			"list[current_player;main;0,5;8,4;]"

		return sfinv.make_formspec(player, context, formspec)
	end,

	on_enter = function(self, player, context)
		local player_name = player:get_player_name()
		local inv = player_inventory[player_name]

		if inv then
			inv.start_i = 0
		end

		update_nations_inventory(player_name)
	end,

	on_player_receive_fields = function(self, player, context, fields)
		local player_name = player:get_player_name()
		local inv = player_inventory[player_name]

		if not inv then
			return
		end

		local page_size = 8 * 4
		local start_i = inv.start_i or 0

		if fields.nations_prev then
			start_i = start_i - page_size

			if start_i < 0 then
				start_i = math.max(0, inv.size - page_size)

				if inv.size > 0 then
					start_i = math.floor(start_i / page_size) * page_size
				end
			end

		elseif fields.nations_next then
			start_i = start_i + page_size

			if start_i >= inv.size then
				start_i = 0
			end
		end

		inv.start_i = start_i

		sfinv.set_player_inventory_formspec(player)
	end
})
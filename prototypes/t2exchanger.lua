local item_sounds = require("__base__.prototypes.item_sounds")

data:extend({
	  {
		type = "item",
		name = "geothermal-t2-exchanger",
		icon  = "__Geothermal__/graphics/icons/heat-pipe.png",
		subgroup = "energy",
		order = "c[geothermal-well]",
		inventory_move_sound = item_sounds.steam_inventory_move,
		pick_sound = item_sounds.steam_inventory_pickup,
		drop_sound = item_sounds.steam_inventory_move,
		--place_result = "geothermal-t2-exchanger",
		stack_size = 10,
		weight = 250*kg
	  },
	  {
		type = "recipe",
		name = "geothermal-t2-exchanger",
		energy_required = 30,
		enabled = false,
		ingredients = {
			{type = "item", name = "heat-pipe", amount = 50},
			{type = "item", name = "refined-concrete", amount = 500},
			{type = "item", name = "pump", amount = 20},
			{type = "item", name = "processing-unit", amount = 10},
		},
		results = {{type="item", name="geothermal-t2-exchanger", amount=1}}
	  },
})
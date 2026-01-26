local item_sounds = require("__base__.prototypes.item_sounds")

require "__DragonIndustries__.registration"

local input = {
	type = "furnace",
	name = "geothermal-exchanger-fluid-input",
	icon = "__Geothermal__/graphics/icons/heat-exchanger.png",
    flags = {"placeable-off-grid", "not-on-map", "not-blueprintable", "not-deconstructable"},
    collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
	collision_mask = {layers={}},
	source_inventory_size = 1,
	result_inventory_size = 1,
	destructible = false,
    selectable_in_game = false,
	max_health = 20,
	crafting_speed = 1,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions = 0,
    },
    energy_usage = "50kW",
    crafting_categories = {"geothermal-exchanger"},
    --fixed_recipe = "geothermal-exchanger",
    allowed_effects = nil,
    effect_receiver = {},
    working_sound = nil,
    fluid_boxes =
    {
      {
        production_type = "input",
        --pipe_picture = assembler2pipepictures(),
        --pipe_covers = pipecoverspictures(),
        volume = 1000,
        pipe_connections = {{ flow_direction="input", direction = defines.direction.north, position = {0, -0.5} }},
        secondary_draw_orders = { north = -1 }
      }
    },
    fluid_boxes_off_when_no_fluid_recipe = false,
    animation =
    {
	  icon = "__core__/graphics/empty.png",
      priority = "high",
      width = 32,
      height = 32,
      frame_count = 1,
      direction_count = 1,
    },
}

data:extend({
	input,
	  {
		type = "recipe-category",
		name = "geothermal-exchanger"
	  },
		{
			type = "recipe",
			name = "lava-geothermal-exchange",
			category = "geothermal-exchanger",
			icon = "__core__/graphics/empty.png",
			enabled = true,
			hidden = true,
			energy_required = 0.1,
			ingredients = {
				{type = "fluid", name = "lava", amount = 40},
			},
			results = {
				{type = "item", name = "stone", amount = 2},
			},
		},
		{
			type = "recipe",
			name = "water-geothermal-exchange",
			category = "geothermal-exchanger",
			icon = "__core__/graphics/empty.png",
			enabled = true,
			hidden = true,
			energy_required = 0.2,
			ingredients = {
				{type = "fluid", name = "geothermal-water", amount = 8}, --was 100
			},
			results = {
				{type = "item", name = "stone", amount = 1},
			},
		},
	  {
		type = "recipe",
		name = "geothermal-exchanger-basic",
		energy_required = 30,
		enabled = false,
		ingredients = {
			{type = "item", name = "heat-exchanger", amount = 2},
			{type = "item", name = "concrete", amount = 200},
			{type = "item", name = "pump", amount = 10},
			{type = "item", name = "advanced-circuit", amount = 50},
		},
		results = {{type="item", name="geothermal-exchanger-basic", amount=1}}
	  },
	  {
		type = "recipe",
		name = "geothermal-exchanger-hot",
		energy_required = 30,
		enabled = false,
		ingredients = {
			{type = "item", name = "geothermal-exchanger-basic", amount = 1},
			{type = "item", name = "refined-concrete", amount = 100},
			{type = "item", name = "heat-pipe", amount = 200},
			{type = "item", name = "processing-unit", amount = 50},
		},
		results = {{type="item", name="geothermal-exchanger-hot", amount=1}}
	  },
})

if settings.startup["geothermal-uses-tungsten"].value then
	table.insert(data.raw.recipe["geothermal-exchanger-basic"].ingredients, {type = "item", name = "tungsten-plate", amount = 10})
end

if settings.startup["geothermal-t2-uses-tungsten"].value then
	table.insert(data.raw.recipe["geothermal-exchanger-hot"].ingredients, {type = "item", name = "tungsten-plate", amount = 25})
end

function createGeothermalBoiler(name, hot)
local temp = hot and 625 or 325, --bob mk2 turbine @ 615, bob mk2 steam engine @ 315

data:extend({
	  {
		type = "item",
		name = "geothermal-exchanger-" .. name,
		icon = hot and "__Geothermal__/graphics/icons/heat-exchanger-2.png" or "__Geothermal__/graphics/icons/heat-exchanger.png",
		subgroup = "energy",
		order = "c[geothermal-well]",
		inventory_move_sound = item_sounds.steam_inventory_move,
		pick_sound = item_sounds.steam_inventory_pickup,
		drop_sound = item_sounds.steam_inventory_move,
		place_result = "geothermal-exchanger-" .. name,
		stack_size = 10,
		weight = 250*kg
	  }
})

	addDerivative("boiler", "boiler",
	  {
		name = "geothermal-exchanger-" .. name,
		icon = "__Geothermal__/graphics/icons/heat-exchanger.png",
		minable = {mining_time = 0.5, result = "geothermal-exchanger-" .. name},
		max_health = 500,
		energy_consumption = "25MW",
		created_effect = {
			type = "direct",
			action_delivery = {
				type = "instant",
				source_effects = {
					type = "script",
					effect_id = "on-create-geothermal-exchanger",
				},
			},
		},
		output_fluid_box =
		{
		  volume = 50,
		  pipe_covers = pipecoverspictures(),
		  pipe_connections =
		  {
			{flow_direction = "output", direction = defines.direction.north, position = {0, -0.5}}
		  },
		  production_type = "output",
		  filter = "steam"
		},
		target_temperature = temp,
		energy_source =
		{
		  type = "heat",
		  max_temperature = temp,
		  specific_heat = "1MJ",
		  max_transfer = "2GW",
		  min_working_temperature = 100,
		  minimum_glow_temperature = 200,
		  connections = {},
		  pipe_covers = nil,
		  heat_pipe_covers = nil,
		},
	  }
	)
end

createGeothermalBoiler("basic", false)
createGeothermalBoiler("hot", true)
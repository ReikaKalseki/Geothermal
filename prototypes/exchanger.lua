local item_sounds = require("__base__.prototypes.item_sounds")

require "geobase"

local input = {
	type = "furnace",
	name = "geothermal-exchanger-fluid-input",
	icon = "__core__/graphics/empty.png",
    flags = {"placeable-off-grid", "not-on-map", "not-blueprintable", "not-deconstructable"},
    collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
	collision_mask = {layers={}},
	source_inventory_size = 1,
	result_inventory_size = 1,
	destructible = false,
    selectable_in_game = false,
	max_health = 20,
	crafting_speed = 1,--[[
    energy_source =
    {
      type = "void",
	  render_no_power_icon = false,
	  render_no_network_icon = false,
    },
    energy_usage = "1W",--]]
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
		--[[ for later
		{
			type = "recipe",
			name = "water-geothermal-exchange",
			category = "geothermal-exchanger",
			icon = "__core__/graphics/empty.png",
			enabled = "true",
			hidden = true,
			energy_required = 0.2,
			ingredients = {
				{type = "fluid", name = "geothermal-water", amount = 40},
			},
			results = {
				{type = "item", name = "stone", amount = 1},
			},
		},
		--]]
	  {
		type = "item",
		name = "geothermal-exchanger",
		icon  = "__Geothermal__/graphics/icons/heat-pipe.png",
		subgroup = "energy",
		order = "c[geothermal-well]",
		inventory_move_sound = item_sounds.steam_inventory_move,
		pick_sound = item_sounds.steam_inventory_pickup,
		drop_sound = item_sounds.steam_inventory_move,
		place_result = "geothermal-exchanger",
		stack_size = 10,
		weight = 250*kg
	  },
	  {
		type = "recipe",
		name = "geothermal-exchanger",
		energy_required = 30,
		enabled = false,
		ingredients = {
			{type = "item", name = "heat-exchanger", amount = 2},
			{type = "item", name = "concrete", amount = 200},
			{type = "item", name = "pump", amount = 10},
			{type = "item", name = "advanced-circuit", amount = 10},
		},
		results = {{type="item", name="geothermal-exchanger", amount=1}}
	  },
})

if settings.startup["geothermal-uses-tungsten"].value then
	table.insert(data.raw.recipe["geothermal-exchanger"].ingredients, {type = "item", name = "tungsten-plate", amount = 10})
end

addDerivative("boiler", "heat-exchanger",
  {
    name = "geothermal-exchanger",
    icon = "__Geothermal__/graphics/icons/heat-pipe.png",
    minable = {mining_time = 0.5, result = "geothermal-exchanger"},
    max_health = 500,
    energy_consumption = "10MW",
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
      volume = 40,
      pipe_covers = pipecoverspictures(),
      pipe_connections =
      {
        {flow_direction = "output", direction = defines.direction.north, position = {0, -0.5}}
      },
      production_type = "output",
      filter = "steam"
    },
    energy_source =
    {
	  type = "heat",
      max_temperature = 625, --for bob mk2 turbine @ 615
      specific_heat = "1kJ",
      max_transfer = "2GW",
      min_working_temperature = 100,
      minimum_glow_temperature = 200,
      connections = {},
      pipe_covers = nil,
      heat_pipe_covers = nil,
    },
      heat_picture =
      {
        north = apply_heat_pipe_glow
        {
          filename = "__Geothermal__/graphics/entity/heat-exchanger/heatex-N-heated.png",
          priority = "extra-high",
          width = 44,
          height = 96,
          shift = util.by_pixel(-0.5, 8.5),
          scale = 0.5
        },
        east = apply_heat_pipe_glow
        {
          filename = "__Geothermal__/graphics/entity/heat-exchanger/heatex-E-heated.png",
          priority = "extra-high",
          width = 80,
          height = 80,
          shift = util.by_pixel(-21, -13),
          scale = 0.5
        },
        south = apply_heat_pipe_glow
        {
          filename = "__Geothermal__/graphics/entity/heat-exchanger/heatex-S-heated.png",
          priority = "extra-high",
          width = 28,
          height = 40,
          shift = util.by_pixel(-1, -30),
          scale = 0.5
        },
        west = apply_heat_pipe_glow
        {
          filename = "__Geothermal__/graphics/entity/heat-exchanger/heatex-W-heated.png",
          priority = "extra-high",
          width = 64,
          height = 76,
          shift = util.by_pixel(23, -13),
          scale = 0.5
        }
      },
    pictures =
    {
      north =
      {
        structure =
        {
          layers =
          {
            {
              filename = "__Geothermal__/graphics/entity/heat-exchanger/heatex-N-idle.png",
              priority = "extra-high",
              width = 269,
              height = 221,
              shift = util.by_pixel(-1.25, 5.25),
              scale = 0.5
            },
            {
              filename = "__base__/graphics/entity/boiler/boiler-N-shadow.png",
              priority = "extra-high",
              width = 274,
              height = 164,
              scale = 0.5,
              shift = util.by_pixel(20.5, 9),
              draw_as_shadow = true
            }
          }
        }
      },
      east =
      {
        structure =
        {
          layers =
          {
            {
              filename = "__Geothermal__/graphics/entity/heat-exchanger/heatex-E-idle.png",
              priority = "extra-high",
              width = 211,
              height = 301,
              shift = util.by_pixel(-1.75, 1.25),
              scale = 0.5
            },
            {
              filename = "__base__/graphics/entity/boiler/boiler-E-shadow.png",
              priority = "extra-high",
              width = 184,
              height = 194,
              scale = 0.5,
              shift = util.by_pixel(30, 9.5),
              draw_as_shadow = true
            }
          }
        }
      },
      south =
      {
        structure =
        {
          layers =
          {
            {
              filename = "__Geothermal__/graphics/entity/heat-exchanger/heatex-S-idle.png",
              priority = "extra-high",
              width = 260,
              height = 201,
              shift = util.by_pixel(4, 10.75),
              scale = 0.5
            },
            {
              filename = "__base__/graphics/entity/boiler/boiler-S-shadow.png",
              priority = "extra-high",
              width = 311,
              height = 131,
              scale = 0.5,
              shift = util.by_pixel(29.75, 15.75),
              draw_as_shadow = true
            }
          }
        }
      },
      west =
      {
        structure =
        {
          layers =
          {
            {
              filename = "__Geothermal__/graphics/entity/heat-exchanger/heatex-W-idle.png",
              priority = "extra-high",
              width = 196,
              height = 273,
              shift = util.by_pixel(1.5, 7.75),
              scale = 0.5
            },
            {
              filename = "__base__/graphics/entity/boiler/boiler-W-shadow.png",
              priority = "extra-high",
              width = 206,
              height = 218,
              scale = 0.5,
              shift = util.by_pixel(19.5, 6.5),
              draw_as_shadow = true
            }
          }
        }
      },
    },
  }
)
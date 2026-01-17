require "__DragonIndustries__.registration"

local item_sounds = require("__base__.prototypes.item_sounds")
--require ("prototypes.entity.entity-util") -- for full resist

data:extend({
	  {
		type = "item",
		name = "geothermal-heat-well",
		icon  = "__base__/graphics/icons/heat-pipe.png",
		subgroup = "energy",
		order = "c[geothermal-well]",
		inventory_move_sound = item_sounds.steam_inventory_move,
		pick_sound = item_sounds.steam_inventory_pickup,
		drop_sound = item_sounds.steam_inventory_move,
		place_result = "geothermal-heat-well",
		stack_size = 5,
		weight = 500*kg
	  },
	  {
		type = "recipe",
		name = "geothermal-heat-well",
		energy_required = 30,
		enabled = false,
		ingredients = {
			{type = "item", name = "heat-pipe", amount = 100},
			{type = "item", name = "refined-concrete", amount = 200},
			{type = "item", name = "tungsten-plate", amount = 100},
			{type = "item", name = "processing-unit", amount = 10},
		},
		results = {{type="item", name="geothermal-heat-well", amount=1}}
	  },
})

addDerivative("heat-interface", "heat-interface",
  {
    name = "geothermal-heat-well",
    icon = "__base__/graphics/icons/heat-pipe.png",
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {mining_time = 0.5, result = "geothermal-heat-well"},
    max_health = 600,
    corpse = "medium-remnants",
    collision_mask = {layers={object=true, train=true, is_object=true, is_lower_object=true}}, -- collide just with object-layer and train-layer which don't collide with water, this allows us to build on 1 tile wide ground
    collision_box = {{-2.4, -2.4}, {2.4, 2.4}},
    selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
	tile_buildability_rules =
    {
      {area = {{-1.4, -1.4}, {1.4, 1.4}}, required_tiles = {layers={ground_tile=true}}, colliding_tiles = {layers={water_tile=true}}, remove_on_collision = true},
    },
    gui_mode = "none", -- all, none, admins
    --resistances = full_resistances(),
    resistances =
    {
      {
        type = "fire",
        percent = 100
      }
    },
	created_effect = {
		type = "direct",
		action_delivery = {
			type = "instant",
			source_effects = {
				type = "script",
				effect_id = "on-create-geothermal-well",
			},
		},
	},
    heat_buffer =
    {
      max_temperature = 625, --for bob mk2 turbine @ 615C
      specific_heat = "2MJ",
      max_transfer = "30GW",
      default_temperature = 0,
      min_working_temperature = 500,
      connections =
      {
        {
          position = {-1, -2},
          direction = defines.direction.north
        },
        {
          position = {1, -2},
          direction = defines.direction.north
        },
        {
          position = {2, -1},
          direction = defines.direction.east
        },
        {
          position = {2, 1},
          direction = defines.direction.east
        },
        {
          position = {1, 2},
          direction = defines.direction.south
        },
        {
          position = {-1, 2},
          direction = defines.direction.south
        },
        {
          position = {-2, 1},
          direction = defines.direction.west
        },
        {
          position = {-2, -1},
          direction = defines.direction.west
        }
      },

      heat_picture = "nil"
    },
    picture =
    {
      layers = {
        {
          filename = "__base__/graphics/icons/heat-interface.png",
          width = 32,
          height = 32,
        }
      }
    },
  }
)

addDerivative("reactor", "nuclear-reactor",
  {
    name = "geothermal-heat-well-graphics",
    icon = "__core__/graphics/empty.png",
    minable = "nil",
    max_health = 600,
    destructible = false,
    collision_mask = {layers={}},
    selectable_in_game = false,
    energy_source = {
      ["*"] = "nil",
      type = "electric",
      usage_priority = "secondary-input"
    },
    light = "nil",
    heat_buffer =
    {
      max_temperature = 999,
      specific_heat = "1kJ",
      max_transfer = "1kW",
      default_temperature = 0,
      min_working_temperature = 500,
      minimum_glow_temperature = 500,
      connections = {},
      heat_picture = apply_heat_pipe_glow
      {
        filename = "__Geothermal__/graphics/entity/wellv2/center-glow.png",
          width = 202,
          height = 168,
          scale = 0.5,
          shift = util.by_pixel(0, 12*0),
      },
    },
    working_light_picture = {
      layers = {
        {
          filename = "__Geothermal__/graphics/entity/wellv2/fan.png",
          width = 210,
          height = 280,
          scale = 0.5625,
          flags = {"no-crop"},
          animation_speed = 0.5,
          line_length = 10,
          frame_count = 60,
          shift = util.by_pixel(22, 28),
        }
        }
      },
    picture =
    {
      layers = {
        {
          filename = "__Geothermal__/graphics/entity/wellv2/center.png",
          width = 202,
          height = 168,
          scale = 0.5,
          flags = {"no-crop"},
          shift = util.by_pixel(0, 4),
        },
      }
    },
    working_sound = "nil",--[[
    {
      sound = sound_variations("__base__/sound/nuclear-reactor", 2, 0.55, volume_multiplier("main-menu", 0.8)),
      max_sounds_per_prototype = 3,
      fade_in_ticks = 4,
      fade_out_ticks = 20
    },--]]

    lower_layer_picture =
    {
      filename = "__Geothermal__/graphics/entity/wellv2/pipes.png",
      width = 320,
      height = 320,
      scale = 0.5,
      shift = {0, 0},
    },
    heat_lower_layer_picture = apply_heat_pipe_glow
    {
      filename = "__Geothermal__/graphics/entity/wellv2/pipes-heated.png",
      width = 320,
      height = 320,
      scale = 0.5,
      shift = {0, 0},
    },
    connection_patches_connected =
    {
      sheet =
      {
        filename = "__base__/graphics/entity/nuclear-reactor/reactor-connect-patches.png",
        width = 64,
        height = 64,
        variation_count = 12,
        scale = 0.5
      }
    },

    connection_patches_disconnected =
    {
      sheet =
      {
        filename = "__base__/graphics/entity/nuclear-reactor/reactor-connect-patches.png",
        width = 64,
        height = 64,
        variation_count = 12,
        y = 64,
        scale = 0.5
      }
    },

    heat_connection_patches_connected =
    {
      sheet = apply_heat_pipe_glow
      {
        filename = "__base__/graphics/entity/nuclear-reactor/reactor-connect-patches-heated.png",
        width = 64,
        height = 64,
        variation_count = 12,
        scale = 0.5
      }
    },

    heat_connection_patches_disconnected =
    {
      sheet = apply_heat_pipe_glow
      {
        filename = "__base__/graphics/entity/nuclear-reactor/reactor-connect-patches-heated.png",
        width = 64,
        height = 64,
        variation_count = 12,
        y = 64,
        scale = 0.5
      }
    },
  }
)
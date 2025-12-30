require "geobase"

local item_sounds = require("__base__.prototypes.item_sounds")
--require ("prototypes.entity.entity-util") -- for full resist

data:extend({
	  {
		type = "item",
		name = "geothermal-heat-well",
		icon  = "__Geothermal__/graphics/icons/heat-pipe.png",
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
    icon = "__Geothermal__/graphics/icons/heat-pipe.png",
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
        percent = 90
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
      specific_heat = "20MJ",
      max_transfer = "30GW",
      default_temperature = 15,
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

      heat_picture = apply_heat_pipe_glow
      {
        filename = "__base__/graphics/entity/nuclear-reactor/reactor-heated.png",
        width = 216,
        height = 256,
        scale = 0.5,
        shift = util.by_pixel(3, -6.5)
      },
    },
    picture =
    {
      filename = "__base__/graphics/icons/heat-interface.png",
      height = 64,
      width = 64,
      scale = 2.5,
      flags = {"no-crop"}
    },

    lower_layer_picture =
    {
      filename = "__base__/graphics/entity/nuclear-reactor/reactor-pipes.png",
      width = 320,
      height = 316,
      scale = 0.5,
      shift = util.by_pixel(-1, -5)
    },
    heat_lower_layer_picture = apply_heat_pipe_glow
    {
      filename = "__base__/graphics/entity/nuclear-reactor/reactor-pipes-heated.png",
      width = 320,
      height = 316,
      scale = 0.5,
      shift = util.by_pixel(-0.5, -4.5)
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
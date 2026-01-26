require "__DragonIndustries__.registration"

local item_sounds = require("__base__.prototypes.item_sounds")
--require ("prototypes.entity.entity-util") -- for full resist

data:extend({
	  {
		type = "item",
		name = "geothermal-heat-well",
    icon = "__Geothermal__/graphics/icons/heat-interface.png",
		subgroup = "energy",
		order = "c[geothermal-well]",
		inventory_move_sound = item_sounds.steam_inventory_move,
		pick_sound = item_sounds.steam_inventory_pickup,
		drop_sound = item_sounds.steam_inventory_move,
		place_result = "geothermal-heat-well-preview",
		stack_size = 5,
		weight = 500*kg
	  },
	  {
		type = "recipe",
		name = "geothermal-heat-well",
		energy_required = 30,
		enabled = false,
		ingredients = {
			{type = "item", name = "heat-pipe", amount = 500},
			{type = "item", name = "refined-concrete", amount = 1000},
			{type = "item", name = "tungsten-plate", amount = 400},
			{type = "item", name = "electric-engine-unit", amount = 200},
			{type = "item", name = "processing-unit", amount = 300},
		},
		results = {{type="item", name="geothermal-heat-well", amount=1}}
	  },
})

local well = addDerivative("heat-interface", "heat-interface",
  {
    name = "geothermal-heat-well",
    factoriopedia_alternative = "geothermal-heat-well-preview",
    icon = "__Geothermal__/graphics/icons/heat-interface.png",
    placeable_by = {item="geothermal-heat-well", count=1},
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {mining_time = 0.5, result = "geothermal-heat-well"},
    max_health = 600,
    corpse = "medium-remnants",
    custom_tooltip_fields = {
      {
				name = { "custom-tooltips.heat-well-quality" },
				value = { "custom-tooltips.heat-well-quality-value" },
				quality_values = {}, -- populated in a loop
      }
    },
    collision_mask = {layers={object=true, train=true, is_object=true, is_lower_object=true}}, -- collide just with object-layer and train-layer which don't collide with water, this allows us to build on 1 tile wide ground
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
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
    heat_buffer =
    {
      max_temperature = 1000,
      specific_heat = "2MJ",
      max_transfer = "30GW",
      default_temperature = 0,
      min_working_temperature = 500,
      minimum_glow_temperature = 500,
      
      heat_lower_layer_picture = apply_heat_pipe_glow
      {
        filename = "__Geothermal__/graphics/entity/wellv2/pipes-small-heated.png",
        width = 192,
        height = 192,
        scale = 0.5,
        shift = {0, 0},
      },
      connections =
      {
        {
          position = {0, -1},
          direction = defines.direction.north
        },
        {
          position = {1, 0},
          direction = defines.direction.east
        },
        {
          position = {0, 1},
          direction = defines.direction.south
        },
        {
          position = {-1, 0},
          direction = defines.direction.west
        },
      },

      heat_picture = "nil"
    },
    picture =
    {
      layers = {--[[
      {
        filename = "__Geothermal__/graphics/entity/wellv2/pipes.png",
        width = 320,
        height = 320,
        scale = 0.5,
        shift = {0, 0},
      },--]]
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
  }
)

for _, quality in pairs(data.raw.quality) do
	well.custom_tooltip_fields[1].quality_values[quality.name] = {"", tostring(100*getHeatWellEfficiency(quality)/getHeatWellEfficiency(data.raw.quality.legendary)), "%"}
end


addDerivative("heat-interface", "geothermal-heat-well",
  {
    name = "geothermal-heat-well-preview",
    localised_name = {"entity-name.geothermal-heat-well"},
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
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
    picture =
    {
      layers = {
      {
        filename = "__Geothermal__/graphics/entity/wellv2/pipes-small.png",
        width = 192,
        height = 192,
        scale = 0.5,
        shift = {0, 0},
      },
        {
          filename = "__Geothermal__/graphics/entity/wellv2/center.png",
          width = 202,
          height = 168,
          scale = 0.5,
          flags = {"no-crop"},
          shift = util.by_pixel(0, 4),
        },
        {
          filename = "__Geothermal__/graphics/entity/wellv2/fan.png",
          width = 210,
          height = 280,
          scale = 0.5625,
          flags = {"no-crop"},
          animation_speed = 0.5,
          line_length = 10,
          frame_count = 60,
          shift = util.by_pixel(23, 29),
        }
      }
    },
  }
)

data:extend({
  {
    type = "animation",
    name = "heat-well-animation",
          filename = "__Geothermal__/graphics/entity/wellv2/fan.png",
          width = 210,
          height = 280,
          scale = 0.5625,
          flags = {"no-crop"},
          animation_speed = 0.5,
          line_length = 10,
          frame_count = 60,
          shift = util.by_pixel(23, 29),
          draw_as_light = false,
          draw_as_glow = false,
          apply_special_effect = false,
  }
})

local function createPatch(name)
data:extend({
  {
    type = "sprite",
    name = "heat-well-patch-" .. name,
          filename = "__Geothermal__/graphics/entity/wellv2/patch-" .. name .. ".png",
          width = 320,
          height = 320,
          scale = 0.5,
          flags = {"no-crop"},
          shift = util.by_pixel(0, 0),
          draw_as_light = false,
          draw_as_glow = false,
          apply_special_effect = false,
  }
})
end

for patch,coord in pairs(WELL_PATCHES) do
  createPatch(patch)
end

addDerivative("reactor", "nuclear-reactor",
  {
    name = "geothermal-heat-well-graphics",
    localised_name = {"entity-name.geothermal-heat-well"},
    icon = "__Geothermal__/graphics/icons/heat-interface.png",
    minable = "nil",
    max_health = 600,
    destructible = false,
    collision_mask = {layers={}},
    selectable_in_game = false,
    energy_source = {
      --[[
      light_flicker = "nil",
      emissions_per_minute = "nil",
      render_no_power_icon = false,
      render_no_network_icon = false,
      effectivity = 0.01,
      --]]
      ["*"] = "nil",
      type = "electric",
      usage_priority = "secondary-input",
      drain = "50kW",
    },
    light = "nil",--[[{
      type = "basic",
      intensity = 0,
      size = 0,
      flicker_interval = 0,
      flicker_min_modifier = 0,
      flicker_max_modifier = 0
    },--]]
    heat_buffer =
    {
      max_temperature = 1000,
      specific_heat = "1MJ",
      max_transfer = "1kW",
      default_temperature = 0,
      min_working_temperature = 500,
      minimum_glow_temperature = 400,
      connections = {},
      heat_picture = apply_heat_pipe_glow
      {
        filename = "__Geothermal__/graphics/entity/wellv2/center-glow.png", 
          width = 202,
          height = 168,
          scale = 0.5,
          shift = util.by_pixel(0, 4),
          --blend_mode = "additive",
          --draw_as_glow = true,
      },
    },
    working_light_picture = "nil",--[[{
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
          shift = util.by_pixel(23, 29),
          draw_as_light = false,
          draw_as_glow = false,
          apply_special_effect = false,
        }
        }
      },--]]
    picture =
    {
      layers = {
        {
          filename = "__core__/graphics/empty.png",
          width = 1,
          height = 1,
        },
      }
    },
    working_sound = 
    {
      sound = { filename = "__Geothermal__/sound/heat-well.ogg" },
      max_sounds_per_prototype = 3,
      fade_in_ticks = 4,
      fade_out_ticks = 20
    },

    lower_layer_picture =         {
      filename = "__Geothermal__/graphics/entity/wellv2/pipes-small.png",
      width = 192,
      height = 192,
      scale = 0.5,
      shift = {0, 0},
        },
    heat_lower_layer_picture = apply_heat_pipe_glow
    {
      filename = "__Geothermal__/graphics/entity/wellv2/pipes-small-heated.png",
      width = 192,
      height = 192,
      scale = 0.5,
      shift = {0, 0},
    },
  }
)
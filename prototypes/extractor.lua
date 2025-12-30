require "geobase"

--require ("prototypes.entity.pipecovers")
--require ("circuit-connector-sprites")
--require ("prototypes.entity.assemblerpipes")

local input = {
	type = "furnace",
	name = "geothermal-extractor-fluid-input",
	icon = "__core__/graphics/empty.png"
	selectable_in_game = false
	max_health = 20,
	crafting_speed = 1,
    energy_source =
    {
      type = "void",
	  render_no_power_icon = false,
	  render_no_network_icon = false,
    },
    energy_usage = "0kW",
    crafting_categories = {"geothermal-extractor"},
    --fixed_recipe = "geothermal-extractor",
    allowed_effects = {},
    effect_receiver = {},
    working_sound = nil,
    fluid_boxes =
    {
      {
        production_type = "input",
        --pipe_picture = assembler2pipepictures(),
        --pipe_covers = pipecoverspictures(),
        volume = 1000,
        pipe_connections = {{ flow_direction="input", direction = defines.direction.north, position = {0, -1} }},
        secondary_draw_orders = { north = -1 }
      }
    },
    fluid_boxes_off_when_no_fluid_recipe = false,
}

local function createGeothermalSource(fluid, yield)
	if not yield then yield = 1 end
	return {
		type = "recipe",
		name = fluid .. "-powered-geothermal",
		icon = "__core__/graphics/empty.png"
		category = "geothermal-extractor",
		subgroup = "internal-process",
		order = "b[internal-process]-b[geothermal]",
		energy_required = 10/yield,
		main_product = "",
		ingredients = {{type = "fluid", name = fluid, amount = 200/yield}},
		results = {{type="item", name="geothermal-reactor-fuel", amount=1}},
		enabled = true,
		hidden = true,
		auto_recycle = false,
		allow_decomposition = false,
		allow_speed = false,
		allow_productivity = false,
		allow_pollution = false,
		allow_quality = false,
		allowed_module_categories = {},
	  },
end

data:extend({
	input,
	  {
		type = "recipe-category",
		name = "geothermal-extractor"
	  },
	  {
		type = "fuel-category",
		name = "geothermal-extractor"
	  },
	  {
		type = "item",
		name = "geothermal-extractor",
		icon  = "__Geothermal__/graphics/icons/extractor.png",
		subgroup = "energy",
		order = "c[geothermal-extractor]",
		inventory_move_sound = item_sounds.steam_inventory_move,
		pick_sound = item_sounds.steam_inventory_pickup,
		drop_sound = item_sounds.steam_inventory_move,
		place_result = "geothermal-extractor",
		stack_size = 5,
		weight = 500*kg
	  },
	  createGeothermalSource("lava"),
	  createGeothermalSource("geothermal-water"),
})

addDerivative("item", "uranium-fuel-cell", {
    name = "geothermal-reactor-fuel",
	icon = "__core__/graphics/empty.png"
    subgroup = "internal-process",
    fuel_category = "geothermal-extractor",
    fuel_value = "1GJ",
    stack_size = 1,
})

addDerivative("reactor", "heating-tower", 
  {
    name = "geothermal-extractor",
    icon  = "__Geothermal__/graphics/icons/extractor.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.5, result = "geothermal-extractor"},
    max_health = 500,
	created_effect = {
		type = "direct",
		action_delivery = {
			type = "instant",
			source_effects = {
				type = "script",
				effect_id = "on-create-geothermal-extractor",
			},
		},
	},
    corpse = "heating-tower-remnants",
    dying_explosion = "heating-tower-explosion",
    surface_conditions =
    {
      {
        property = "pressure",
        min = 10
      }
    },
    consumption = "10MW",
    neighbour_bonus = 0,
    energy_source =
    {
      type = "burner",
      fuel_categories = {"geothermal-extractor"},
      emissions_per_minute = {},
      effectivity = 1,
      fuel_inventory_size = 1,
      burnt_inventory_size = 0,
      light_flicker =
      {
        color = {0,0,0},
        minimum_intensity = 0.7,
        maximum_intensity = 0.95
      }
    },
    collision_box = {{-1.25, -1.25}, {1.25, 1.25}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    damaged_trigger_effect = hit_effects.entity(),
    drawing_box_vertical_extension = 1,

    picture =
    {
      layers =
      {
        util.sprite_load("__space-age__/graphics/entity/heating-tower/heating-tower-main", {
         scale = 0.5
        }),
        util.sprite_load("__space-age__/graphics/entity/heating-tower/heating-tower-shadow", {
          scale = 0.5,
          draw_as_shadow = true
        })
      }
    },

    working_light_picture =
    {
      layers = {
        util.sprite_load("__space-age__/graphics/entity/heating-tower/heating-tower-working-fire", {
          frame_count = 24,
          scale = 0.5,
          blend_mode = "additive",
          draw_as_glow = true,
          animation_speed = 0.333
        }),
        util.sprite_load("__space-age__/graphics/entity/heating-tower/heating-tower-working-light", {
          frame_count = 1,
          repeat_count = 24,
          scale = 0.5,
          blend_mode = "additive",
          draw_as_glow = true
        })
      }
    },

    heat_buffer =
    {
      max_temperature = 625, --for bob mk2 turbine @ 615C
      specific_heat = "25MJ",
      max_transfer = "10GW",
      minimum_glow_temperature = 100,
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

    heat_picture = apply_heat_pipe_glow(
      util.sprite_load("__space-age__/graphics/entity/heating-tower/heating-tower-glow", {
        scale = 0.5,
        blend_mode = "additive"
      }))
    },

    connection_patches_connected =
    {
      sheet = util.sprite_load("__space-age__/graphics/entity/heating-tower/heating-tower-pipes", {
        scale = 0.5,
        variation_count = 4
      })
    },

    connection_patches_disconnected =
    {
      sheet = util.sprite_load("__space-age__/graphics/entity/heating-tower/heating-tower-pipes-disconnected", {
        scale = 0.5,
        variation_count = 4
      })
    },

    heat_connection_patches_connected =
    {
      sheet = apply_heat_pipe_glow(
        util.sprite_load("__space-age__/graphics/entity/heating-tower/heating-tower-pipes-heat", {
        scale = 0.5,
        variation_count = 4
      }))
    },

    heat_connection_patches_disconnected =
    {
      sheet = apply_heat_pipe_glow(
        util.sprite_load("__space-age__/graphics/entity/heating-tower/heating-tower-pipes-heat-disconnected", {
        scale = 0.5,
        variation_count = 4
      }))
    },

    open_sound = sounds.steam_open,
    close_sound = sounds.steam_close,
    working_sound =
    {
      sound = {filename = "__Geothermal__/sound/exchanger.ogg", volume = 1.0},
      max_sounds_per_prototype = 2,
      fade_in_ticks = 4,
      fade_out_ticks = 20
    },

    default_temperature_signal = {type = "virtual", name = "signal-T"},
    circuit_wire_max_distance = reactor_circuit_wire_max_distance,
    circuit_connector = circuit_connector_definitions["heating-tower"]
  },
  }
)
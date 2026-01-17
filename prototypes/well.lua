addDerivative("item", "pumpjack", {
    name = "geothermal-well",
    icon = "__Geothermal__/graphics/icons/geothermal-well.png",
    icon_size = 32,
    order = "b[steam-power]-b[geothermal-well]",
    place_result = "geothermal-well",
    stack_size = 10,
})

data:extend(
{
   {
    type = "recipe",
    name = "geothermal-well",
    enabled = false,
		energy_required = 90,
		ingredients =
		{
			{type = "item", name = "pipe", amount = 100},
			{type = "item", name = "concrete", amount = 300},
			{type = "item", name = "electric-engine-unit", amount = 80},
			{type = "item", name = "steel-plate", amount = 200},
		},
		results = {{type = "item", name = "geothermal-well", amount = 1}},
  }
}
)

local yield = settings.startup["geothermal-power-factor"].value
addDerivative("mining-drill", "pumpjack", {
    name = "geothermal-well",
    icon = "__Geothermal__/graphics/icons/geothermal-well.png",
    icon_size = 32,
    order = "b[steam-power]-b[geothermal-well]",
    minable = {mining_time = 1, result = "geothermal-well"},
    max_health = 800,
    resource_categories = {"geothermal"},
    collision_box = {{ -1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{ -1.5, -1.5}, {1.5, 1.5}},
    drawing_box = {{-1.6, -2.5}, {1.5, 1.6}},
    fast_replaceable_group = "geothermal-well",
    uses_force_mining_productivity_bonus = false,
	  allowed_effects = {},
    module_slots = 0,
    quality_affects_mining_radius = false,
    energy_source =
    {
      emissions_per_minute = {pollution=5},
	    drain = 100*yield .. "kW",
    },
    energy_usage = 250*yield .. "kW",
    mining_speed = yield,
    output_fluid_box =
    {
      pipe_connections =
      {
        {
          direction = defines.direction.east,
          position = {1, -1},
          flow_direction = "output"
        },
        {
          direction = defines.direction.east,
          position = {1, 1},
          flow_direction = "output"
        },
        {
          direction = defines.direction.west,
          position = {-1, -1},
          flow_direction = "output"
        },
        {
          direction = defines.direction.west,
          position = {-1, 1},
          flow_direction = "output"
        },
        {
          direction = defines.direction.south,
          position = {1, 1},
          flow_direction = "output"
        },
        {
          direction = defines.direction.north,
          position = {1, -1},
          flow_direction = "output"
        },
        {
          direction = defines.direction.south,
          position = {-1, 1},
          flow_direction = "output"
        },
        {
          direction = defines.direction.north,
          position = {-1, -1},
          flow_direction = "output"
        },
      }
    },
    radius_visualisation_picture =
    {
      filename = "__Geothermal__/graphics/entity/well/radius-visualization.png",
      width = 12,
      height = 12
    },
    base_picture =
    {
      sheets = {
        {
          filename = "__Geothermal__/graphics/entity/well/base.png",
          width = 261,
          height = 273,
          shift = util.by_pixel(-2.25, -4.75),
          scale = 0.5,
          frames = 1,
        },
        {
          filename = "__Geothermal__/graphics/entity/well/base-shadow.png",
          width = 220,
          height = 220,
          scale = 0.5,
          draw_as_shadow = true,
          shift = util.by_pixel(6, 0.5),
          frames = 1,
        }
      }
    },
    graphics_set = {
      animation =
      {
        north =
        {
          layers = {
            {
              width = 116,
              height = 110,
              line_length = 10,
              frame_count = 40,
              shift = util.by_pixel(16, 4),
              filename = "__Geothermal__/graphics/entity/well/well.png",
              scale = 1.1,
              animation_speed = 0.5,
            },
            {
              width = 116,
              height = 110,
              line_length = 10,
              frame_count = 40,
              shift = util.by_pixel(16, 4),
              filename = "__Geothermal__/graphics/entity/well/glow.png",
              scale = 1.1,
              animation_speed = 0.5,
              blend_mode = "additive",
              draw_as_glow = true,
            }
          }
        }
      }
    },
    working_sound =
    {
      sound = { filename = "__Geothermal__/sound/geothermal-well.ogg" },
      apparent_volume = 1.5,
    },
})






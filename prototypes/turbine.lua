data:extend(
{
  {
    type = "item",
    name = "geothermal-heat-exchanger",
    icon = "__Geothermal__/graphics/icons/geothermal-turbine.png",
	icon_size = 32,
    flags = {},
    subgroup = "energy",
    order = "b[steam-power]-b[geothermal-heat-exchanger]",
    place_result = "geothermal-heat-exchanger",
    stack_size = 10,
  }
}
)

data:extend(
{
  {
    type = "recipe",
    name = "geothermal-heat-exchanger",
    enabled = "false",
    energy_required = 120,
    ingredients =
    {
		{"stone-brick", 160},
		{"concrete", 120},
		{"advanced-circuit", 40},
		{"steel-plate", 40}
    },
    result = "geothermal-heat-exchanger",
  }
}
)

data:extend(
{
    {
    type = "assembling-machine",
    name = "geothermal-heat-exchanger",
    icon = "__Geothermal__/graphics/icons/geothermal-turbine.png",
	icon_size = 32,
    flags = {"placeable-neutral","placeable-player", "player-creation"},
    minable = {mining_time = 1, result = "geothermal-heat-exchanger"},
    max_health = 500,
    corpse = "big-remnants",
    dying_explosion = "massive-explosion",
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},

    animation = make_4way_animation_from_spritesheet({ layers =
    {
      {
        filename = "__Geothermal__/graphics/entity/chemical-plant/chemical-plant.png",
        width = 122,
        height = 134,
        frame_count = 1,
        shift = util.by_pixel(-5, -4.5),
        hr_version = {
          filename = "__Geothermal__/graphics/entity/chemical-plant/hr-chemical-plant.png",
          width = 244,
          height = 268,
          frame_count = 1,
          shift = util.by_pixel(-5, -4.5),
          scale = 0.5
          }
      },
      {
        filename = "__Geothermal__/graphics/entity/chemical-plant/chemical-plant-shadow.png",
        width = 175,
        height = 110,
        frame_count = 1,
        shift = util.by_pixel(31.5, 11),
        draw_as_shadow = true,
        hr_version = {
          filename = "__Geothermal__/graphics/entity/chemical-plant/hr-chemical-plant-shadow.png",
          width = 350,
          height = 219,
          frame_count = 1,
          shift = util.by_pixel(31.5, 10.75),
          draw_as_shadow = true,
          scale = 0.5
          }
      },
    }}),
    working_visualisations =
    {
      {
        north_position = util.by_pixel(30, -24),
        west_position = util.by_pixel(1, -49.5),
        south_position = util.by_pixel(-30, -48),
        east_position = util.by_pixel(-11, -1),
        apply_recipe_tint = "primary",
        animation =
        {
          filename = "__Geothermal__/graphics/entity/chemical-plant/boiling-green-patch.png",
          frame_count = 32,
          width = 15,
          height = 10,
          animation_speed = 0.5,
          hr_version = {
            filename = "__Geothermal__/graphics/entity/chemical-plant/hr-boiling-green-patch.png",
            frame_count = 32,
            width = 30,
            height = 20,
            animation_speed = 0.5,
            scale = 0.5
          }
        }
      },

      {
        north_position = util.by_pixel(30, -24),
        west_position = util.by_pixel(1, -49.5),
        south_position = util.by_pixel(-30, -48),
        east_position = util.by_pixel(-11, -1),
        apply_recipe_tint = "secondary",
        animation =
        {
          filename = "__Geothermal__/graphics/entity/chemical-plant/boiling-green-patch-mask.png",
          frame_count = 32,
          width = 15,
          height = 10,
          animation_speed = 0.5,
          hr_version = {
            filename = "__Geothermal__/graphics/entity/chemical-plant/hr-boiling-green-patch-mask.png",
            frame_count = 32,
            width = 30,
            height = 20,
            animation_speed = 0.5,
            scale = 0.5
          }
        }
      },


      {
        apply_recipe_tint = "tertiary",
        north_position = {0, 0},
        west_position = {0, 0},
        south_position = {0, 0},
        east_position = {0, 0},
        north_animation =
        {
          filename = "__Geothermal__/graphics/entity/chemical-plant/boiling-window-green-patch.png",
          frame_count = 1,
          width = 87,
          height = 60,
          shift = util.by_pixel(0, -5),
          hr_version = {
            filename = "__Geothermal__/graphics/entity/chemical-plant/hr-boiling-window-green-patch.png",
            x = 0,
            frame_count = 1,
            width = 174,
            height = 119,
            shift = util.by_pixel(0, -5.25),
            scale = 0.5
          }
        },
        east_animation =
        {
          filename = "__Geothermal__/graphics/entity/chemical-plant/boiling-window-green-patch.png",
          x = 87,
          frame_count = 1,
          width = 87,
          height = 60,
          shift = util.by_pixel(0, -5),
          hr_version = {
            filename = "__Geothermal__/graphics/entity/chemical-plant/hr-boiling-window-green-patch.png",
            x = 174,
            frame_count = 1,
            width = 174,
            height = 119,
            shift = util.by_pixel(0, -5.25),
            scale = 0.5
          }
        },
        south_animation =
        {
          filename = "__Geothermal__/graphics/entity/chemical-plant/boiling-window-green-patch.png",
          x = 174,
          frame_count = 1,
          width = 87,
          height = 60,
          shift = util.by_pixel(0, -5),
          hr_version = {
            filename = "__Geothermal__/graphics/entity/chemical-plant/hr-boiling-window-green-patch.png",
            x = 348,
            frame_count = 1,
            width = 174,
            height = 119,
            shift = util.by_pixel(0, -5.25),
            scale = 0.5
          }
        }
      }
    },
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound =
      {
        {
          filename = "__Geothermal__/sound/exchanger.ogg",
          volume = 1.0
        }
      },
      idle_sound = { filename = "__Geothermal__/sound/exchanger-idle.ogg", volume = 0.6 },
      apparent_volume = 1.5,
    },
    crafting_speed = 4,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions_per_minute = 0,
	  drain = "30kW",
    },
    energy_usage = 60*Config.powerFactor*Config.powerFactor .. "kW",
    ingredient_count = 2,
    crafting_categories = {"geothermal"},
    fluid_boxes =
    {
      {
        production_type = "input",
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {-1, -2} }}
      },
      {
        production_type = "input",
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {1, -2} }}
      },
      {
        production_type = "output",
        pipe_covers = pipecoverspictures(),
        base_level = 1,
        pipe_connections = {{ position = {-1, 2} }}
      },
      {
        production_type = "output",
        pipe_covers = pipecoverspictures(),
        base_level = 1,
        pipe_connections = {{ position = {1, 2} }}
      }
    }
  }
}
)






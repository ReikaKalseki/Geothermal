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
	normal = {
		energy_required = 120,
		ingredients =
		{
			{"stone-brick", 120},
			{"pipe", 60},
			{"advanced-circuit", 30},
			{"steel-plate", 40},
			{"iron-gear-wheel", 50}
		},
		result = "geothermal-heat-exchanger",
	},
	expensive = {
		energy_required = 200,
		ingredients =
		{
			{"stone-brick", 180},
			{"pipe", 120},
			{"advanced-circuit", 50},
			{"steel-plate", 90},
			{"iron-gear-wheel", 200}
		},
		result = "geothermal-heat-exchanger",
	},
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

    animation =
    {
      filename = "__Geothermal__/graphics/entity/heat-exchanger/exchanger-horizontal.png",
      priority = "high",
      width = 128,
      height = 128,
      frame_count = 16,
      line_length = 16,
      shift = {0.35, -0.1},
      animation_speed = 0.8
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
        pipe_picture = assembler2pipepictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {0, -2} }}
      },
      {
        production_type = "input",
        pipe_covers = pipecoverspictures(),
        pipe_picture = assembler2pipepictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {-2, 0} }}
      },
      {
        production_type = "output",
        pipe_covers = pipecoverspictures(),
        pipe_picture = assembler2pipepictures(),
        base_level = 1,
        pipe_connections = {{type="output",  position = {0, 2} }}
      },
      {
        production_type = "output",
        pipe_covers = pipecoverspictures(),
        pipe_picture = assembler2pipepictures(),
        base_level = 1,
        pipe_connections = {{ type="output", position = {2, 0} }}
      }
    }
  }
}
)






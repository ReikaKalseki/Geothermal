data:extend(
{
   {
    type = "item",
    name = "geothermal-well",
    icon = "__Geothermal__/graphics/icons/geothermal-well.png",
	icon_size = 32,
    flags = {},
    subgroup = "extraction-machine",
    order = "b[steam-power]-b[geothermal-well]",
    place_result = "geothermal-well",
    stack_size = 10,
  }
}
)

data:extend(
{
   {
    type = "recipe",
    name = "geothermal-well",
    enabled = "false",
    energy_required = 120,
    ingredients =
    {
		{"stone-brick", 40},
		{"concrete", 240},
		{"electric-engine-unit", 20},
		{"advanced-circuit", 10},
		{"copper-plate", 120},
		{"steel-plate", 80}
    },
    result = "geothermal-well",
  }
}
)

data:extend(
{
  {
    type = "mining-drill",
    name = "geothermal-well",
    icon = "__Geothermal__/graphics/icons/geothermal-well.png",
	icon_size = 32,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 1, result = "geothermal-well"},
    resource_categories = {"geothermal"},
    max_health = 800,
    corpse = "big-remnants",
    dying_explosion = "massive-explosion",
    collision_box = {{ -1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{ -1.5, -1.5}, {1.5, 1.5}},
    drawing_box = {{-1.6, -2.5}, {1.5, 1.6}},
    energy_source =
    {
      type = "electric",
      -- will produce this much * energy pollution units per tick
      emissions_per_minute = 16*Config.wellgen,
      usage_priority = "secondary-input",
	  drain = 40*Config.wellgen .. "kW",
    },
    input_fluid_box = Config.geothermalNeedsWater and
    {
      production_type = "input",
	  filter = "water",
      pipe_picture = assembler2pipepictures(),
      pipe_covers = pipecoverspictures(),
      base_area = 1,
      height = 2,
      base_level = -1,
      pipe_connections =
      {
        { position = {-2, 0} },
        { position = {2, 0} },
        { position = {0, 2} },
        { position = {0, -2} },
      }
    } or nil,
    output_fluid_box =
    {
      production_type = "output",
      base_area = 1,
      base_level = 1,
      pipe_covers = pipecoverspictures(),
      pipe_connections =
      {
        {
          positions = { {1, -2}, {2, -1}, {-1, 2}, {-2, 1} }
        }
      },
    },
	energy_usage = 240*Config.wellgen .. "kW",
    mining_speed = 80*Config.wellgen, --was 30, then 50, but 30 can only support 4 steam engines with 4 wells running and max non-inf mining productivity research; 50 cannot even run 2 engines on 1 well without research
    mining_power = 2,
    resource_searching_radius = 0.49,
    vector_to_place_result = {0, 0},
    --[[module_specification =
    {
      module_slots = 2
    },--]]
	allowed_effects = {},
    radius_visualisation_picture =
    {
      filename = "__Geothermal__/graphics/entity/geothermal/geothermal-well-radius-visualization.png",
      width = 12,
      height = 12
    },
    base_picture =
    {
      sheet =
      {
        filename = "__Geothermal__/graphics/entity/geothermal/geothermal-well-base.png",
        priority = "extra-high",
        width = 114,
        height = 113,
        shift = {0.1875, -0.03125}
      }
    },
    animations =
    {
      north =
      {
        priority = "extra-high",
        width = 116,
        height = 110,
        line_length = 10,
        shift = {0.125, -0.71875},
        filename = "__Geothermal__/graphics/entity/geothermal/geothermal-well-animation.png",
        frame_count = 40,
        animation_speed = 0.5
      }
    },
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound = { filename = "__Geothermal__/sound/geothermal-well.ogg" },
      apparent_volume = 1.5,
    },
    fast_replaceable_group = "geothermal-well",
	allowed_effects = nil,
  }
}
)







data:extend(
{
  {
    type = "fluid",
    name = "geothermal-water",
    default_temperature = 350,
    max_temperature = 350,
    heat_capacity = "1KJ",
    base_color = {r=0.6, g=0.34, b=0.4},
    flow_color = {r=0.8, g=0.7, b=0.7},
    icon = "__Geothermal__/graphics/icons/water.png",
    order = "a[fluid]-a[water]",
    pressure_to_speed_ratio = 0.4,
    flow_to_energy_ratio = 0.59,
  }
})

data:extend(
{
  {
    type = "resource-category",
    name = "geothermal"
  }
})

data:extend(
{
  {
    type = "recipe-category",
    name = "geothermal"
  }
})

data:extend(
{
	{
		type = "recipe",
		name = "geothermal-exchange",
		category = "geothermal",
		enabled = false,
		energy = 1,
		ingredients =
		{
		  {type="fluid", name="water", amount=1},
		  {type="fluid", name="geothermal-water", amount=1}
		},
		results=
		{
		  {type="fluid", name="steam", amount=10, temperature = 180} --used to produce 5 @ 240C
		},
		main_product= "",
		icon = "__Geothermal__/graphics/icons/geothermal-exchange.png",
		subgroup = "fluid-recipes",
		order = "b[fluid-chemistry]-i[geothermal]"
	  },
	  	{
		type = "recipe",
		name = "geothermal-exchange-flipped",
		category = "geothermal",
		enabled = false,
		energy = 1,
		ingredients =
		{
		  {type="fluid", name="geothermal-water", amount=1},
		  {type="fluid", name="water", amount=1},
		},
		results=
		{
		  {type="fluid", name="steam", amount=10, temperature = 180} --used to produce 5 @ 240C
		},
		main_product= "",
		icon = "__Geothermal__/graphics/icons/geothermal-exchange.png",
		subgroup = "fluid-recipes",
		order = "b[fluid-chemistry]-i[geothermal]"
	  },
	  
	  	{
		type = "recipe",
		name = "geothermal-exchange-2",
		category = "geothermal",
		enabled = false,
		energy = 1,
		ingredients =
		{
		  {type="fluid", name="water", amount=5},
		  {type="fluid", name="geothermal-water", amount=2}
		},
		results=
		{
		  {type="fluid", name="steam", amount=30, temperature = 500} --used to produce 25
		},
		main_product= "",
		icon = "__Geothermal__/graphics/icons/geothermal-exchange.png",
		subgroup = "fluid-recipes",
		order = "b[fluid-chemistry]-i[geothermal]"
	  },
	  	{
		type = "recipe",
		name = "geothermal-exchange-2-flipped",
		category = "geothermal",
		enabled = false,
		energy = 1,
		ingredients =
		{
		  {type="fluid", name="geothermal-water", amount=2},
		  {type="fluid", name="water", amount=5},
		},
		results=
		{
		  {type="fluid", name="steam", amount=30, temperature = 500} --used to produce 25
		},
		main_product= "",
		icon = "__Geothermal__/graphics/icons/geothermal-exchange.png",
		subgroup = "fluid-recipes",
		order = "b[fluid-chemistry]-i[geothermal]"
	  }
})
--[[
data:extend(
{
  {
    type = "autoplace-control",
    name = "geothermal",
    richness = false,
    order = "b-a"
  }
}
)
--]]

data:extend(
{
  {
    type = "resource",
    name = "geothermal",
    icon = "__Geothermal__/graphics/icons/geothermal-patch.png",
    flags = {"placeable-neutral"},
    category = "geothermal",
    order="a-b-a",
    infinite = true,
    minimum = 10000,
    normal = 10000,
    minable =
    {
		hardness = 1,
		mining_time = 1,
		required_fluid = Config.geothermalNeedsWater and "water" or nil,
		fluid_amount = Config.geothermalNeedsWater and 10 or nil,
      results =
      {
        {
          type = "fluid",
          name = "geothermal-water",
          amount_min = 1,
          amount_max = 1,
          probability = 1
        }
      }
    },
    collision_box = {{ -1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{ -0.75, -0.75}, {0.75, 0.75}},--[[
    autoplace =
    {
      control = "geothermal",
      sharpness = 0.99,
      max_probability = 0.035,
      richness_base = 6000,
      richness_multiplier = 30000,
      richness_multiplier_distance_bonus = 10,
      coverage = 0.02, -- Cover on average 2% of surface area.
      peaks =
      {
        {
          noise_layer = "geothermal",
          noise_octaves_difference = -1,
          noise_persistence = 0.44,
        }
      }
    },--]]
    stage_counts = {0},
    stages =
    {
      sheet =
      {
        filename = "__Geothermal__/graphics/entity/geothermal/geothermal-patch.png",
        priority = "extra-high",
        width = 75,
        height = 61,
        frame_count = 4,
        variation_count = 1
      }
    },
    map_color = {r=0.8, g=0.6, b=0.2},
    map_grid = false
  },
{
    type = "rail-chain-signal",
    name = "geothermal-light",
    --icon = "__base__/graphics/icons/rail-signal.png",
    flags = {"placeable-off-grid", "not-on-map"},
    --fast_replaceable_group = "rail-signal",
    --minable = {mining_time = 0.5, result = "rail-signal"},
    max_health = 100,
	destructible = false,
    corpse = "small-remnants",
    --collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
    --selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	selectable_in_game = false,
	collision_mask = {},
    animation =
    {
      filename = "__Geothermal__/graphics/entity/glow/rail-signal.png",
      priority = "high",
      width = 96,
      height = 96,
      frame_count = 3,
      direction_count = 8,
      hr_version = {
        filename = "__Geothermal__/graphics/entity/glow/hr-rail-signal.png",
        priority = "high",
        width = 192,
        height = 192,
        frame_count = 3,
        direction_count = 8,
        scale = 0.5
      }
    },
    selection_box_offsets =
    {
      {0, 0},
      {0, 0},
      {0, 0},
      {0, 0},
      {0, 0},
      {0, 0},
      {0, 0},
      {0, 0}
    },
    rail_piece =
    {
      filename = "__Geothermal__/graphics/entity/glow/rail-signal-metal.png",
      line_length = 10,
      width = 96,
      height = 96,
      frame_count = 10,
      axially_symmetrical = false,
      hr_version = {
        filename = "__Geothermal__/graphics/entity/glow/hr-rail-signal-metal.png",
        line_length = 10,
        width = 192,
        height = 192,
        frame_count = 10,
        axially_symmetrical = false,
        scale = 0.5
      }
    },
    green_light = {intensity = 0.75, size = 8, color={r=1, g=0.7, b=0.2}},
    orange_light = {intensity = 0.75, size = 8, color={r=1, g=0.7, b=0.2}},
    red_light = {intensity = 0.75, size = 8, color={r=1, g=0.7, b=0.2}},
    blue_light = {intensity = 0.75, size = 8, color={r=1, g=0.7, b=0.2}},
   }
})
--[[
data:extend(
{
  {
    type = "noise-layer",
    name = "geothermal"
  },
})
--]]
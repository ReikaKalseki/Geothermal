--colors: green -> copper; blue -> sulfur; purple -> uranium (the first two are realistic, at least...)

require "config"

local colors = {
	[""] = {base = {r=0.6, g=0.34, b=0.4}, light = {r=1, g=0.7, b=0.2}}
}

if Config.geothermalColor and data.raw.tile["volcanic-orange-heat-1"] then
	colors["-green"] = {byproduct = "copper-ore", base = {r=0, g=1, b=0}, light = {r=0.2, g=1, b=0.25}}
	colors["-blue"] = {byproduct = "sulfur", base = {r=0.2, g=0.75, b=1}, light = {r=0.125, g=0.75, b=1}}
	colors["-purple"] = {byproduct = "uranium-ore", base = {r=1, g=0, b=1}, light = {r=1, g=0.5, b=1}}
end

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

for color,params in pairs(colors) do

local display = color == "" and "" or " (" .. string.upper(string.sub(color, 2, 2)) .. string.sub(color, 3) .. ")"
local productdisplay = color == "" and "" or " (with "
local productdisplay2 = color == "" and "" or " byproduct)"
local productname = color ~= "" and {"item-name." .. params.byproduct} or ""

data:extend(
{
  {
    type = "fluid",
    name = "geothermal-water" .. color,
    default_temperature = 350,
    max_temperature = 350,
    heat_capacity = "1KJ",
    base_color = params.base,
    flow_color = {r=math.sqrt(params.base.r), g = math.sqrt(params.base.g), b=math.sqrt(params.base.b)},--{r=0.8, g=0.7, b=0.7},
	icon = "__Geothermal__/graphics/icons/water.png",
	icon_size = 32,
    order = "a[fluid]-a[water]",
    pressure_to_speed_ratio = 0.4,
    flow_to_energy_ratio = 0.59,
	localised_name = {"fluid-name.geothermal-water", productdisplay, productname, productdisplay2},
  }
})

if color ~= "" then
	local fluid = data.raw.fluid["geothermal-water" .. color]
	fluid.icon = nil
    fluid.icons = {{icon = "__Geothermal__/graphics/icons/water.png"}, {icon = "__Geothermal__/graphics/icons/overlay" .. color .. ".png"}}
end

local prod1 = {
	{type="fluid", name="steam", amount=math.floor(Config.powerFactor*12), temperature = 180}
}

local prod2 = {
	{type="fluid", name="steam", amount=math.floor(Config.powerFactor*30), temperature = 500}
}

if params.byproduct then
	table.insert(prod1, {type = "item", name = params.byproduct, probability = 0.0005, amount = 1})
	table.insert(prod2, {type = "item", name = params.byproduct, probability = 0.0003, amount = 1})
end

data:extend(
{
	{
		type = "recipe",
		name = "geothermal-exchange" .. color,
		category = "geothermal",
		enabled = false,
		energy = 1,
		ingredients =
		{
		  {type="fluid", name="water", amount=1},
		  {type="fluid", name="geothermal-water" .. color, amount=1}
		},
		results = prod1,
		main_product= "",
		icon = "__Geothermal__/graphics/icons/geothermal-exchange.png",
		icon_size = 32,
		subgroup = "fluid-recipes",
		order = "b[fluid-chemistry]-i[geothermal]",
		localised_name = {"recipe-name.geothermal-exchange"},
	  },
	  	{
		type = "recipe",
		name = "geothermal-exchange-flipped" .. color,
		category = "geothermal",
		enabled = false,
		energy = 1,
		ingredients =
		{
		  {type="fluid", name="geothermal-water" .. color, amount=1},
		  {type="fluid", name="water", amount=1},
		},
		results = prod1,
		main_product= "",
		icon = "__Geothermal__/graphics/icons/geothermal-exchange.png",
		icon_size = 32,
		subgroup = "fluid-recipes",
		order = "b[fluid-chemistry]-i[geothermal]",
		localised_name = {"recipe-name.geothermal-exchange-flipped"},
	  },
	  
	  	{
		type = "recipe",
		name = "geothermal-exchange-2" .. color,
		category = "geothermal",
		enabled = false,
		energy = 1,
		ingredients =
		{
		  {type="fluid", name="water", amount=5},
		  {type="fluid", name="geothermal-water" .. color, amount=2}
		},
		results = prod2,
		main_product= "",
		icon = "__Geothermal__/graphics/icons/geothermal-exchange.png",
		icon_size = 32,
		subgroup = "fluid-recipes",
		order = "b[fluid-chemistry]-i[geothermal]",
		localised_name = {"recipe-name.geothermal-exchange-2"},
	  },
	  	{
		type = "recipe",
		name = "geothermal-exchange-2-flipped" .. color,
		category = "geothermal",
		enabled = false,
		energy = 1,
		ingredients =
		{
		  {type="fluid", name="geothermal-water" .. color, amount=2},
		  {type="fluid", name="water", amount=5},
		},
		results = prod2,
		main_product= "",
		icon = "__Geothermal__/graphics/icons/geothermal-exchange.png",
		icon_size = 32,
		subgroup = "fluid-recipes",
		order = "b[fluid-chemistry]-i[geothermal]",
		localised_name = {"recipe-name.geothermal-exchange-2-flipped"},
	  }
})

table.insert(data.raw.technology["geothermal"].effects, {type = "unlock-recipe", recipe = "geothermal-exchange" .. color})
table.insert(data.raw.technology["geothermal"].effects, {type = "unlock-recipe", recipe = "geothermal-exchange-flipped" .. color})
table.insert(data.raw.technology["geothermal-2"].effects, {type = "unlock-recipe", recipe = "geothermal-exchange-2" .. color})
table.insert(data.raw.technology["geothermal-2"].effects, {type = "unlock-recipe", recipe = "geothermal-exchange-2-flipped" .. color})

data:extend(
{
  {
    type = "resource",
    name = "geothermal" .. color,
    icon = "__Geothermal__/graphics/icons/geothermal-patch.png",
	icon_size = 32,
    flags = {"placeable-neutral"},
    category = "geothermal",
	localised_name = {"entity-name.geothermal", display},
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
          name = "geothermal-water" .. color,
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
        filename = "__Geothermal__/graphics/entity/geothermal/geothermal-patch" .. color .. ".png",
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
    name = "geothermal-light" .. color,
    --icon = "__base__/graphics/icons/rail-signal.png",
	icon_size = 32,
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
      filename = "__core__/graphics/empty.png",
      priority = "high",
      width = 1,
      height = 1,
      frame_count = 1,
      direction_count = 1,
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
      filename = "__core__/graphics/empty.png",
      line_length = 1,
      width = 1,
      height = 1,
      frame_count = 1,
      axially_symmetrical = false,
    },
    green_light = {intensity = 0.75, size = 8, color=params.light},
    orange_light = {intensity = 0.75, size = 8, color=params.light},
    red_light = {intensity = 0.75, size = 8, color=params.light},
    blue_light = {intensity = 0.75, size = 8, color=params.light},
   }
})

end
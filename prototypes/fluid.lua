--colors: green -> copper; blue -> sulfur; purple -> uranium (the first two are realistic, at least...)

require "config"

require "__DragonIndustries__/utility-entities"

local highConsumeMultiply = 4
local exchangersPerWell = 1.2--1.6--0.8--2

local fluids = {}

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

data:extend({
  {
    type = "fluid",
    name = "cooling-geothermal-water",
    default_temperature = 80,
    max_temperature = 350,
    heat_capacity = "0J",
    base_color = colors[""].base,
    flow_color = {r=math.sqrt(colors[""].base.r), g = math.sqrt(colors[""].base.g), b=math.sqrt(colors[""].base.b)},--{r=0.8, g=0.7, b=0.7},
	icon = "__Geothermal__/graphics/icons/water.png",
	icon_size = 32,
    order = "a[fluid]-a[water]",
    pressure_to_speed_ratio = 0.3,
    flow_to_energy_ratio = 0,
	localised_name = {"fluid-name.geothermal-water", "", "", ""},
	hidden = true,
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

local fluid = data.raw.fluid["geothermal-water" .. color]
table.insert(fluids, fluid)

if color ~= "" then
	fluid.icon = nil
    fluid.icons = {{icon = "__Geothermal__/graphics/icons/water.png", icon_size = 32}, {icon = "__Geothermal__/graphics/icons/overlay" .. color .. ".png", icon_size = 32}}
end

local prod1 = {
	{type="fluid", name="steam", amount=math.floor(Config.powerFactor*12), temperature = 315} --315 so can run Bob Mk2 steam engine
}

local prod2 = {
	{type="fluid", name="steam", amount=math.floor(Config.powerFactor*30*highConsumeMultiply), temperature = 615} --615 so can run Bob Mk2 steam turbine
}

if params.byproduct then
	table.insert(prod1, {type = "item", name = params.byproduct, probability = 0.002*Config.byproductRate, amount = 1})
	table.insert(prod2, {type = "item", name = params.byproduct, probability = 0.0012*highConsumeMultiply*Config.byproductRate, amount = 1})
end

data:extend(
{
	{
		type = "recipe",
		name = "geothermal-exchange" .. color,
		category = "geothermal",
		enabled = false,
		energy_required = exchangersPerWell/2,
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
		energy_required = exchangersPerWell/2,
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
		energy_required = exchangersPerWell/2*highConsumeMultiply,
		ingredients =
		{
		  {type="fluid", name="water", amount=5*highConsumeMultiply},
		  {type="fluid", name="geothermal-water" .. color, amount=2*highConsumeMultiply}
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
		energy_required = exchangersPerWell/2*highConsumeMultiply,
		ingredients =
		{
		  {type="fluid", name="geothermal-water" .. color, amount=2*highConsumeMultiply},
		  {type="fluid", name="water", amount=5*highConsumeMultiply},
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
    highlight = true,
    minimum = 10000,
    normal = 10000,
    minable =
    {
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
    selection_box = {{ -0.75, -0.75}, {0.75, 0.75}},
    stage_counts = {0},
    stages =
    {
      sheet =
      {
        filename = "__Geothermal__/graphics/entity/geothermal/patch-sheet" .. color .. ".png",
        priority = "extra-high",
        width = 256,
        height = 192,
		scale = 0.5,
        frame_count = 6,
        variation_count = 1,
		--draw_as_glow = true
      }
    },
    stages_effect =
    {
      sheet =
      {
        filename = "__Geothermal__/graphics/entity/geothermal/glow/patch-sheet" .. color .. ".png",
        priority = "extra-high",
        width = 256,
        height = 192,
		scale = 0.5,
        frame_count = 6,
        variation_count = 1,
          blend_mode = "additive",
          flags = {"light"}
      }
    },
    effect_animation_period = 8,
    effect_animation_period_deviation = 2,
    effect_darkness_multiplier = 3.0,
    min_effect_alpha = 0.2,
    max_effect_alpha = 0.3,
    map_color = {r=0.8, g=0.6, b=0.2},
    map_grid = false
  },
  createBasicLight("geothermal-light" .. color, {brightness = 0.25, size = 18, color = params.light})
})

end

return fluids
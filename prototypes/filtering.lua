require "config"

local amount = 120--250

local function createGeothermalFiltering(input)
	local fluid = data.raw.fluid[input]
	if not fluid then return end
	local item = data.raw.item["sodium-hydroxide"] and "sodium-hydroxide" or "stone"
	local rec = {
		type = "recipe",
		name = fluid.name .. "-filtering",
		category = "geothermal-filter",
		enabled = false,
		energy_required = 4,
		ingredients =
		{
		  {type="fluid", name=fluid.name, amount=amount},
		  {type="fluid", name="water", amount=20},
		  {type="item", name=item, amount=1}
		},
		results = {
			{type="fluid", name="geothermal-water", amount=amount}
		},
		main_product= "",
		icon = "__Geothermal__/graphics/icons/geothermal-filtering.png",
		icon_size = 32,
		subgroup = "fluid-recipes",
		order = "b[fluid-chemistry]-i[geothermal]",
		localised_name = {"recipe-name.geothermal-filter"},
	  }
	  if data.raw.fluid["waste"] then table.insert(rec.results, {type="fluid", name="waste", amount=5}) end
	 data:extend({rec})
	table.insert(data.raw.technology["geothermal-filtering"].effects, {type = "unlock-recipe", recipe = rec.name})
end

createGeothermalFiltering("geothermal-water-blue")
createGeothermalFiltering("geothermal-water-green")  
createGeothermalFiltering("geothermal-water-purple")

data:extend(
{
  {
    type = "recipe-category",
    name = "geothermal-filter"
  },
  {
    type = "item",
    name = "geothermal-filter",
    icon = "__Geothermal__/graphics/icons/geothermal-filter.png",
	icon_size = 32,
    flags = {},
    subgroup = "energy",
    order = "b[steam-power]-b[geothermal-filter]",
    place_result = "geothermal-filter",
    stack_size = 10,
  },
  {
    type = "recipe",
    name = "geothermal-filter",
    enabled = "false",
    energy_required = 90,
    ingredients =
    {
		{"pipe", 200},
		{"stone-brick", 60},
		{"advanced-circuit", 10},
		{"iron-stick", 40},
		{"steel-plate", 50}
    },
    result = "geothermal-filter",
  },
    {
    type = "assembling-machine",
    name = "geothermal-filter",
    icon = "__Geothermal__/graphics/icons/geothermal-filter.png",
	icon_size = 32,
    flags = {"placeable-neutral","placeable-player", "player-creation"},
    minable = {mining_time = 1, result = "geothermal-filter"},
    max_health = 400,
    corpse = "big-remnants",
    dying_explosion = "massive-explosion",
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},

    animation = make_4way_animation_from_spritesheet({ layers =
    {
      {
        filename = "__Geothermal__/graphics/entity/geothermal-filter/chemical-plant.png",
        width = 122,
        height = 134,
        frame_count = 1,
        shift = util.by_pixel(-5, -4.5),
        hr_version = {
          filename = "__Geothermal__/graphics/entity/geothermal-filter/hr-chemical-plant.png",
          width = 244,
          height = 268,
          frame_count = 1,
          shift = util.by_pixel(-5, -4.5),
          scale = 0.5
          }
      },
      {
        filename = "__Geothermal__/graphics/entity/geothermal-filter/chemical-plant-shadow.png",
        width = 175,
        height = 110,
        frame_count = 1,
        shift = util.by_pixel(31.5, 11),
        draw_as_shadow = true,
        hr_version = {
          filename = "__Geothermal__/graphics/entity/geothermal-filter/hr-chemical-plant-shadow.png",
          width = 350,
          height = 219,
          frame_count = 1,
          shift = util.by_pixel(31.5, 10.75),
          draw_as_shadow = true,
          scale = 0.5
          }
      },
    }}),
	
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
    crafting_speed = 1,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions_per_minute = 0,
	  drain = "10kW",
    },
    energy_usage = "120kW",
    ingredient_count = 3,
    crafting_categories = {"geothermal-filter"},
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
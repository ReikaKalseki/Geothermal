require "config"

require "__DragonIndustries__.cloning"

if not Config.thermalWagon then return end

local wagon = copyObject("fluid-wagon", "fluid-wagon", "insulated-wagon")
local item = copyObject("item-with-entity-data", "fluid-wagon", "insulated-wagon")
--adds 22MB to mod - reparentSprites("base", "Geothermal", wagon)
reparentSprites("base", "Geothermal", item)

local recipe = {
    type = "recipe",
    name = "insulated-wagon",
    enabled = false,
    energy_required = 30,
    ingredients =
    {
      {"low-density-structure", 25},
      {"fluid-wagon", 1}
    },
    result = "insulated-wagon"
  }

local tech = {
    type = "technology",
    name = "insulated-wagon",
    prerequisites =
    {
		"fluid-wagon",
		"geothermal",
		"low-density-structure"
    },
    icon = "__Geothermal__/graphics/technology/wagon.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "insulated-wagon"
      }
    },
    unit =
    {
      count = 150,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
      },
      time = 40
    },
    order = "[steam]-2",
	icon_size = 128,
  }

data:extend({wagon, item, recipe, tech})
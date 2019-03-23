data:extend(
{
  {
    type = "technology",
    name = "geothermal",
    prerequisites =
    {
		"fluid-handling",
		"flammables",
		"electric-engine",
		"concrete"
    },
    icon = "__Geothermal__/graphics/technology/geothermal.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "geothermal-well"
      },
      {
        type = "unlock-recipe",
        recipe = "geothermal-heat-exchanger"
      },--[[
      {
        type = "unlock-recipe",
        recipe = "geothermal-exchange"
      },
      {
        type = "unlock-recipe",
        recipe = "geothermal-exchange-flipped"
      },--]]
    },
    unit =
    {
      count = 250,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1}
      },
      time = 30
    },
    order = "[steam]-2",
	icon_size = 128,
  },
   {
    type = "technology",
    name = "geothermal-2",
    prerequisites =
    {
		"advanced-oil-processing",
		"geothermal",
		"advanced-electronics-2"
    },
    icon = "__Geothermal__/graphics/technology/geothermal.png",
    effects =
    {--[[
      {
        type = "unlock-recipe",
        recipe = "geothermal-exchange-2"
      },
      {
        type = "unlock-recipe",
        recipe = "geothermal-exchange-2-flipped"
      },--]]
      {
        type = "unlock-recipe",
        recipe = "steam-turbine"
      }
    },
    unit =
    {
      count = 400,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1},
      },
      time = 40
    },
    order = "[steam]-2",
	icon_size = 128,
  },
}
)
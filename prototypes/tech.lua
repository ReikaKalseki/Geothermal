data:extend(
{
  {
    type = "technology",
    name = "geothermal",
    prerequisites =
    {
		"advanced-circuit",
		"concrete",
		"production-science-pack",
    },
    icon = "__Geothermal__/graphics/technology/geothermal.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "geothermal-exchanger"
      },
    },
    unit =
    {
      count = 1000,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1},
      },
      time = 60
    },
    order = "[steam]-2",
	icon_size = 128,
  },
  {
    type = "technology",
    name = "geothermal-2",
    prerequisites =
    {
		"geothermal",
		"electric-engine",
		"automation-3",
		"advanced-material-processing-2",
		"processing-unit",
		"metallurgic-science-pack",
    },
    icon = "__Geothermal__/graphics/technology/geothermal.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "geothermal-heat-well"
      }
    },
    unit =
    {
      count = 3000,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1},
        {"space-science-pack", 1},
        {"metallurgic-science-pack", 1},
      },
      time = 60
    },
    order = "[steam]-2",
	icon_size = 128,
  }
})

if settings.startup["geothermal-uses-tungsten"].value then
	table.insert(data.raw.technology["geothermal"].unit.ingredients, {"space-science-pack", 1})
	table.insert(data.raw.technology["geothermal"].unit.ingredients, {"metallurgic-science-pack", 1})
end
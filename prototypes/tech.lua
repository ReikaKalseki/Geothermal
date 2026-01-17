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
		"electric-engine",
		"automation-3",
    },
    icon = "__Geothermal__/graphics/technology/geothermal.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "geothermal-exchanger-basic"
      },
      {
        type = "unlock-recipe",
        recipe = "geothermal-well"
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
    order = "[geothermal]",
	icon_size = 128,
  },
  {
    type = "technology",
    name = "geothermal-filtering",
    prerequisites =
    {
		"geothermal",
		--"chemical-science-pack",
    },
    icon = "__Geothermal__/graphics/technology/geothermal.png",
    effects =
    { --added by the filtering prototype loop
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
    order = "[geothermal]",
	icon_size = 128,
  },
  {
    type = "technology",
    name = "geothermal-hot-exchanger",
    prerequisites =
    {
		"geothermal",
		"processing-unit",
    },
    icon = "__Geothermal__/graphics/technology/geothermal.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "geothermal-exchanger-hot"
      }
    },
    unit =
    {
      count = 2000,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1},
      },
      time = 60
    },
    order = "[geothermal]",
	icon_size = 128,
  },
  {
    type = "technology",
    name = "geothermal-heat-well",
    prerequisites =
    {
		"geothermal",
		"advanced-material-processing-2",
		"processing-unit",
		"cryogenic-science-pack",
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
        {"cryogenic-science-pack", 1},
      },
      time = 60
    },
    order = "[geothermal]",
	icon_size = 128,
  },
  {
    type = "technology",
    name = "geothermal-heat-well-efficiency",
    prerequisites =
    {
		"geothermal-heat-well",
		"cryogenic-science-pack",
    },
    icon = "__Geothermal__/graphics/technology/geothermal.png",
    effects =
    {
      {
        type = "nothing",
        effect_description = {"custom-tooltips.geothermal-heat-well-efficiency-effect", tostring(HEAT_WELL_EFFICIENCY_TECH_AMOUNT*100)}
      }
    },
    unit =
    {
      count = 5000,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1},
        {"space-science-pack", 1},
        {"metallurgic-science-pack", 1},
        {"cryogenic-science-pack", 1},
      },
      time = 60
    },
    order = "[geothermal]",
	icon_size = 128,
  }
})

if settings.startup["geothermal-uses-tungsten"].value then
	table.insert(data.raw.technology["geothermal"].unit.ingredients, {"space-science-pack", 1})
	table.insert(data.raw.technology["geothermal"].unit.ingredients, {"metallurgic-science-pack", 1})
	table.insert(data.raw.technology["geothermal-hot-exchanger"].unit.ingredients, {"space-science-pack", 1})
	table.insert(data.raw.technology["geothermal-hot-exchanger"].unit.ingredients, {"metallurgic-science-pack", 1})
	table.insert(data.raw.technology["geothermal-filtering"].unit.ingredients, {"space-science-pack", 1})
	table.insert(data.raw.technology["geothermal-filtering"].unit.ingredients, {"metallurgic-science-pack", 1})
end
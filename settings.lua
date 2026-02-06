data:extend({
        {
            type = "bool-setting",
            name = "geothermal-uses-tungsten",
            setting_type = "startup",
            default_value = false,
            order = "aa",
		},
        {
            type = "bool-setting",
            name = "geothermal-t2-uses-tungsten",
            setting_type = "startup",
            default_value = false,
            order = "ab",
		},
        {
            type = "double-setting",
            name = "geothermal-power-factor",
            setting_type = "startup",
            default_value = 1,
            order = "c",
			minimum_value = 0.5,
			maximum_value = 10,
		},
        {
            type = "double-setting",
            name = "geothermal-byproduct-rate",
            setting_type = "startup",
            default_value = 1,
            order = "e",
			minimum_value = 0.1,
			maximum_value = 10,
		}
})
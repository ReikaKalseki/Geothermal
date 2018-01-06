data:extend({
        {
            type = "bool-setting",
            name = "geothermal-needs-water",
            setting_type = "startup",
            default_value = false,
            order = "r",
			--localised_name = "Geothermal wells need water input",
			--localised_description = "Should the geothermal wells require water input, or should the water be 'provided' by the well? Requiring input makes logistics much more complicated. Note that changing this means you will have to replace any existing wells.",
        },
        {
            type = "double-setting",
            name = "geothermal-power-factor",
            setting_type = "startup",
            default_value = 1,
            order = "r",
			minimum_value = 0.5,
			maximum_value = 10,
		},
})

---@param planet string
---@param spawnRuleSet [string]
---@param default? string
---@param defaultRate? number
---@param defaultSize? number
---@param defaultDist? number
---@param defaultMinDist? number
local function generatePlanetSettings(planet, spawnRuleSet, default, defaultRate, defaultSize, defaultDist, defaultMinDist)
    table.insert(spawnRuleSet, 1, "nowhere")
    table.insert(spawnRuleSet, "everywhere")
    if not default then default = "everywhere" end
    if not defaultSize then defaultSize = 1 end
    if not defaultRate then defaultRate = 1 end
    if not defaultDist then defaultDist = 1 end
    if not defaultMinDist then defaultMinDist = 400 end
    local po = planet == "nauvis" and "-" or planet
    data:extend({
            {
                type = "double-setting",
                name = "geothermal-spawn-frequency-" .. planet,
                localised_name = {"mod-setting-name.geothermal-spawn-frequency", {"space-location-name." .. planet}},
                setting_type = "startup",
                default_value = defaultRate,
                order = "r-" .. po .. "-r1",
                minimum_value = 0.125,
                maximum_value = 10,
            },
            {
                type = "double-setting",
                name = "geothermal-size-" .. planet,
                localised_name = {"mod-setting-name.geothermal-size", {"space-location-name." .. planet}},
                setting_type = "startup",
                default_value = defaultSize,
                order = "r-" .. po .. "-r2",
                minimum_value = 0.33,
                maximum_value = 6,
            },
            {
                type = "string-setting",
                name = "geothermal-spawn-rules-" .. planet,
                localised_name = {"mod-setting-name.geothermal-spawn-rules", {"space-location-name." .. planet}},
                setting_type = "startup",
                order = "r-" .. po .. "-r3",
                default_value = default,
                allowed_values = spawnRuleSet,
            },
            {
                type = "double-setting",
                name = "geothermal-distance-scalar-" .. planet,
                localised_name = {"mod-setting-name.geothermal-distance-scalar", {"space-location-name." .. planet}},
                setting_type = "startup",
                default_value = defaultDist,
                order = "r-" .. po .. "-r4",
                minimum_value = 0.1,
                maximum_value = 10,
            },
            {
                type = "double-setting",
                name = "geothermal-min-distance-" .. planet,
                localised_name = {"mod-setting-name.geothermal-min-distance", {"space-location-name." .. planet}},
                setting_type = "startup",
                default_value = defaultMinDist,
                order = "r-" .. po .. "-r5",
                minimum_value = 0,
                maximum_value = 6000,
            },
            {
                type = "double-setting",
                name = "geothermal-rate-clamp-" .. planet,
                localised_name = {"mod-setting-name.geothermal-rate-clamp", {"space-location-name." .. planet}},
                setting_type = "startup",
                default_value = 10,
                order = "r-" .. po .. "-r6",
                minimum_value = 1,
                maximum_value = 20,
            },
    })
end

generatePlanetSettings("nauvis", {"volcanic", "volcanic-and-snow", "volcanic-snow-and-red-desert"}, nil, 1)
generatePlanetSettings("gleba", {"highlands", "highlands-and-midlands"}, "highlands-and-midlands", 0.4)
generatePlanetSettings("maraxsis", {"trench-rim", "deep-only"}, nil, 4, nil, nil, 0)
generatePlanetSettings("tenebris", {}, nil, 10, nil, nil, 0)

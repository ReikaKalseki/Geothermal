Config = {}

Config.geothermalNeedsWater = settings.startup["geothermal-needs-water"].value--[[@as boolean]]

Config.powerFactor = settings.startup["geothermal-power-factor"].value--[[@as number]]

Config.wellgen = settings.startup["geothermal-fluid-production"].value--[[@as number]]

Config.frequency = settings.startup["geothermal-frequency"].value--[[@as number]]

Config.size = settings.startup["geothermal-size"].value--[[@as number]]

Config.geothermalColor = settings.startup["geothermal-color"].value--[[@as boolean]]

Config.geothermalSpawnRules = settings.startup["geothermal-spawn-rules"].value

Config.thermalWagon = settings.startup["thermal-wagon"].value--[[@as boolean]]

Config.byproductRate = settings.startup["geothermal-byproduct-rate"].value--[[@as number]]

Config.distanceScalar = settings.startup["geothermal-distance-scalar"].value--[[@as number]]

Config.rateClamp = settings.startup["geothermal-rate-clamp"].value--[[@as number]]

Config.minDistance = settings.startup["geothermal-min-distance"].value--[[@as number]]

Config.retrogenDistance = -1

Config.seedMixin = 7865
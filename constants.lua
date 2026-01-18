CHUNK_SIZE = 32

PATCH_RATE_FACTOR = 0.25
NONVOLCANIC_FACTOR = 1/96

HEAT_WELL_EFFICIENCY_TECH_AMOUNT = 0.5
HEAT_WELL_QUALITY_FACTOR = 0.2 --1x at base quality, 2x at masterwork

PATCH_TEMPERATURES = {
	["cold"] = {temperature = 110, rate = 1, weight = 15},
	["cool"] = {temperature = 180, rate = 2, weight = 40},
	["warm"] = {temperature = 300, rate = 5, weight = 50},
	["hot"] = {temperature = 625, rate = 10, weight = 25} --for bob mk2 turbine @ 615C
}

WELL_PATCHES = {
	["wnw"] = {x = -2, y = -1},
	["wsw"] = {x = -2, y = 1},
	["ene"] = {x = 2, y = -1},
	["ese"] = {x = 2, y = -1},
	["ssw"] = {x = -1, y = 2},
	["sse"] = {x = 1, y = 2},
	["nnw"] = {x = -1, y = -2},
	["nne"] = {x = 1, y = -2},
}

TEMPERATURE_INDICES = {}

local WEIGHT_TABLE = {}

for temp,params in pairs(PATCH_TEMPERATURES) do
	WEIGHT_TABLE[temp] = {params.weight, temp}
	table.insert(TEMPERATURE_INDICES, temp)
end

function getRandomTemperature(randFunc)
	return getWeightedRandom(WEIGHT_TABLE, randFunc)
end

COLORS = {
	[""] = {base = {product = "stone", productAmount=0, overlay = nil, r=0.6, g=0.34, b=0.4}, light = {r=1, g=0.7, b=0.2}, weight = 80}
}

--if settings.startup["geothermal-color"].value then
	COLORS["-green"] = {product = "copper-ore", productAmount=0.7, overlay = "green", base = {r=0, g=1, b=0}, light = {r=0.2, g=1, b=0.25}, weight = 40}
	COLORS["-blue"] = {product = "sulfur", productAmount=0.3, overlay = "blue", base = {r=0.2, g=0.75, b=1}, light = {r=0.125, g=0.75, b=1}, weight = 50}
	COLORS["-purple"] = {product = "uranium-ore", productAmount=0.06, overlay = "purple", base = {r=1, g=0, b=1}, light = {r=1, g=0.5, b=1}, weight = 20}
--end

local COLOR_WEIGHT_TABLE = {}

for clr,params in pairs(COLORS) do
	COLOR_WEIGHT_TABLE[clr] = {params.weight, clr}
end

function getRandomColor(randFunc)
	return getWeightedRandom(COLOR_WEIGHT_TABLE, randFunc)
end

function getHeatWellEfficiency(quality)
	return (1+HEAT_WELL_QUALITY_FACTOR*quality.level)
end

function initModifiers(isInit)

end
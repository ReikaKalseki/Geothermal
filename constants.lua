CHUNK_SIZE = 32

PATCH_RATE_FACTOR = 0.25
NONVOLCANIC_FACTOR = 1/96

PATCH_TEMPERATURES = {
	["cold"] = {temperature = 110, rate = 1},
	["cool"] = {temperature = 180, rate = 2},
	["warm"] = {temperature = 300, rate = 5},
	["hot"] = {temperature = 625, rate = 10}
}

COLORS = {
	[""] = {base = {product = "stone", overlay = nil, r=0.6, g=0.34, b=0.4}, light = {r=1, g=0.7, b=0.2}}
}

if settings.startup["geothermal-color"].value then
	COLORS["-green"] = {product = "copper-ore", overlay = "green", base = {r=0, g=1, b=0}, light = {r=0.2, g=1, b=0.25}}
	COLORS["-blue"] = {product = "sulfur", overlay = "blue", base = {r=0.2, g=0.75, b=1}, light = {r=0.125, g=0.75, b=1}}
	COLORS["-purple"] = {product = "uranium-ore", overlay = "purple", base = {r=1, g=0, b=1}, light = {r=1, g=0.5, b=1}}
end

function initModifiers(isInit)

end
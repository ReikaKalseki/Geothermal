require "config"

require "__DragonIndustries__.recipe"

if Config.thermalWagon and data.raw.item.rubber then
	addItemToRecipe("insulated-wagon", "rubber", 30, 50, false)
end
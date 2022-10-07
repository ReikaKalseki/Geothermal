require "config"

require "__DragonIndustries__.recipe"

if Config.thermalWagon and data.raw.item.rubber then
	addItemToRecipe("insulated-wagon", "rubber", 30, 50, false)
end

if data.raw.item["invar-alloy"] then--[[
	removeItemFromRecipe("geothermal-well", "steel-plate")
	
	addItemToRecipe("geothermal-well", "invar-alloy", 40, 120, false)
	addItemToRecipe("geothermal-well", "invar-alloy", 40, 120, false)
	addItemToRecipe("geothermal-well", "invar-alloy", 40, 120, false)
	--]]
	replaceItemInRecipe("geothermal-well", "steel-plate", "invar-alloy", 1, false)
	addItemToRecipe("geothermal-well", "steel-gear-wheel", 10, 20, false)
	addItemToRecipe("geothermal-well", "steel-bearing", 10, 20, false)
	addItemToRecipe("geothermal-well", "silver-plate", 20, 50, false)
	
	replaceItemInRecipe("geothermal-heat-exchanger", "steel-plate", "brass-alloy", 1, false)
	replaceItemInRecipe("geothermal-heat-exchanger", "copper-plate", "copper-pipe", 1, false)
	addItemToRecipe("geothermal-heat-exchanger", "cobalt-steel-bearing", 10, 20, false)
	addItemToRecipe("geothermal-heat-exchanger", "cobalt-steel-gear-wheel", 10, 20, false)
	
	addItemToRecipe("geothermal-filter", "brass-gear-wheel", 10, 20, false)
end
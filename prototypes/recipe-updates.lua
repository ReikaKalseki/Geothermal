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
	replaceItemInRecipe("geothermal-well", "steel-plate", "invar-alloy", 2, false)
	addItemToRecipe("geothermal-well", "steel-gear-wheel", 25, 80, false)
	addItemToRecipe("geothermal-well", "steel-bearing", 10, 40, false)
	replaceItemInRecipe("geothermal-well", "copper-plate", "copper-pipe", 1, false)
	
	replaceItemInRecipe("geothermal-heat-exchanger", "steel-plate", "cobalt-steel-alloy", 1, false)
	if data.raw.item["steel-pipe"] then
		replaceItemInRecipe("geothermal-heat-exchanger", "pipe", "steel-pipe", 1, false)
	end
	addItemToRecipe("geothermal-heat-exchanger", "silver-plate", 50, 200, false)
	addItemToRecipe("geothermal-heat-exchanger", "cobalt-steel-bearing", 25, 100, false)
	--addItemToRecipe("geothermal-heat-exchanger", "brass-gear-wheel", 25, 100, false)
	replaceItemInRecipe("geothermal-heat-exchanger", "iron-gear-wheel", "brass-gear-wheel", 1, false)
	
	addItemToRecipe("geothermal-filter", "brass-gear-wheel", 10, 25, false)
end
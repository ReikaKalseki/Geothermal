require "__DragonIndustries__.recipe"
--[[
if Config.thermalWagon then
	addItemToRecipeIfExists("insulated-wagon", "rubber", 200, false)
end
--]]
replaceItemInRecipeIfExists("geothermal-well", "steel-plate", "invar-alloy", 1, false)
addItemToRecipeIfExists("geothermal-well", "steel-gear-wheel", 100, false)
addItemToRecipeIfExists("geothermal-well", "steel-bearing", 50, false)

replaceItemInRecipeIfExists("heat-exchanger", "copper-plate", "copper-pipe", 1, false)
addItemToRecipeIfExists("geothermal-exchanger-basic", "cobalt-steel-alloy", 50, false)
addItemToRecipeIfExists("geothermal-exchanger-hot", "nitinol-plate", 25, false)
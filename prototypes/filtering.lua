require "constants"

local amount = 240--120--250

local function createGeothermalFiltering(color, params)
	local fluid = data.raw.fluid["geothermal-water" .. color]
	if not fluid then return end
	local rec = createDerivative(data.raw.recipe["plastic-bar"], {
		name = "geothermal-filtering" .. color,
	  	localised_name = {"recipe-name.geothermal-filter", color ~= "" and {"", " (", {"geothermal-name." .. string.sub(color, 2)}, " ", {"geothermal-name.variant"}, ")"} or ""},
		order = "b[fluid-chemistry]-i[geothermal]",
    category = "geothermal-filter",
		icons = {{icon = "__Geothermal__/graphics/icons/geothermal-filtering.png", icon_size = 32}, {icon = "__Geothermal__/graphics/icons/water-overlay.png", icon_size = 32, tint = params.base, scale = 0.75, shift = {8, 8}}},
		enabled = false,
		energy_required = 10,
		ingredients =
		{
		  {type="fluid", name=fluid.name, amount=amount},
		  {type="item", name="carbon", amount=1}
		},
		results = {
			{type="fluid", name="geothermal-water", amount=amount},
			{type="item", name=params.product, amount = 1, probability=params.productAmount*settings.startup["geothermal-byproduct-rate"].value}
		},
    	main_product = "geothermal-water",
		crafting_machine_tint = {
			primary = COLORS[color].base,
			secondary = COLORS[color].light,
			tertiary = COLORS[color].base,
			quaternary = COLORS[color].light,
		}
	  })
    --log(serpent.block(rec))
	  --if data.raw.fluid["waste"] then table.insert(rec.results, {type="fluid", name="waste", amount=1}) end
	 data:extend({rec})
   table.insert(data.raw.technology["geothermal-filtering"].effects, {type = "unlock-recipe", recipe = rec.name})
end

data:extend(
{
  {
    type = "recipe-category",
    name = "geothermal-filter"
  },
})
table.insert(data.raw["assembling-machine"]["chemical-plant"].crafting_categories, "geothermal-filter")

for name,params in pairs(COLORS) do
  if name ~= "" then
    createGeothermalFiltering(name, params)
  end
end

local item = data.raw.item["sand"] and "sand" or "stone"
local carb = addDerivative("recipe", "sulfur", {
  name = "carbon-from-oil",
  enabled = false,
	energy_required = 2,
		ingredients =
		{
		  {type="fluid", name="crude-oil", amount=40},
		  {type="fluid", name="sulfuric-acid", amount=10},
		  {type="item", name=item, amount=1}
		},
		results = {
			{type="item", name="carbon", amount=5},
		},
})
if item == "sand" then table.insert(carb.results, {type="item", name="sand", amount=1, probability = 0.04}) end

table.insert(data.raw.technology["oil-processing"].effects, {type = "unlock-recipe", recipe = "carbon-from-oil"})
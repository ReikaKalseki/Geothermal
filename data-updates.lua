require("prototypes.recipe-updates")

if data.raw["assembling-machine"]["maraxsis-hydro-plant"] then
    table.insert(data.raw["assembling-machine"]["maraxsis-hydro-plant"].crafting_categories, "geothermal-filter")
end
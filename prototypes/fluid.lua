require "__DragonIndustries__/utility-entities"
require "__DragonIndustries__/registration"
require "__DragonIndustries__/color"
require "constants"

local fluids = {}

data:extend(
{
  {
    type = "resource-category",
    name = "geothermal"
  }
})

local function addFluid(color)
    local water = addDerivative("fluid", "lava", {
        name = "geothermal-water" ..  color,
	      localised_name = {"fluid-name.geothermal-water", color ~= "" and {"", " (", {"geothermal-name." .. string.sub(color, 2)}, " ", {"geothermal-name.variant"}, ")"} or ""},
        icons = {{icon = "__Geothermal__/graphics/icons/water.png", icon_size = 32}},
        order = "b[new-fluid]-b[nauvis]-a[geothermal]",
        default_temperature = PATCH_TEMPERATURES["cold"].temperature,
        max_temperature = PATCH_TEMPERATURES["hot"].temperature,
        heat_capacity = data.raw.fluid.water.heat_capacity,
        base_color = COLORS[color].base,
        flow_color = permuteColorScale(COLORS[color].base, 0.33, 0.33, 0.33),
    })
    if color ~= "" then
      table.insert(water.icons, {icon = "__Geothermal__/graphics/icons/water-overlay.png", icon_size = 32, tint = COLORS[color].base, scale = 0.75, shift = {8, 8}})
    end
    table.insert(fluids, water)
end

for color,params in pairs(COLORS) do
    addFluid(color)
    local index = -1
    for label,temp in pairs(PATCH_TEMPERATURES) do
      index = index+1
      local sc = 0.375 --0.5-0.125*index
        data:extend({
  {
    type = "resource",
    name = "geothermal-patch-" .. label .. color,
    icon = "__Geothermal__/graphics/icons/geothermal-patch.png",
	  icon_size = 64,
    flags = {"placeable-neutral"},
    category = "geothermal",
	  localised_name = {"geothermal-name.base", tostring(temp.temperature), color ~= "" and {"", " (", {"geothermal-name." .. string.sub(color, 2)}, " ", {"geothermal-name.variant"}, ")"} or ""},
    order="a-b-a",
    infinite = true,
    highlight = true,
    minimum = 10000,
    normal = 10000,
    minable =
    {
		mining_time = 1,
      results =
      {
        {
          type = "fluid",
          name = "geothermal-water" .. color,
          amount_min = temp.rate*10,
          amount_max = temp.rate*10,
          probability = 1,
          temperature = temp.temperature,
        }
      }
    },
    collision_box = {{ -1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{ -1.5, -1.5}, {1.5, 1.5}},
    stage_counts = {0},
    stages =
    {
      sheet =
      {
        filename = "__Geothermal__/graphics/entity/geothermal/stages" .. color .. ".png",
        priority = "extra-high",
        width = 926,
        height = 718,
		    scale = sc,
        frame_count = 1,
        x = 926*index,
        variation_count = 1,
        layer = "ground-patch-higher2"
      }
    },
    stages_effect =
    {
      sheet =
      {
        filename = "__Geothermal__/graphics/entity/geothermal/glow" .. color .. ".png",
        priority = "extra-high",
        width = 926,
        height = 718,
		    scale = sc,
        frame_count = 1,
        x = 926*index,
        variation_count = 1,
          blend_mode = "additive",
          draw_as_light = true,
      }
    },
    effect_animation_period = 8,
    effect_animation_period_deviation = 2,
    effect_darkness_multiplier = 0,--3.0,
    min_effect_alpha = 0.75,
    max_effect_alpha = 1.0,
    map_color = {r=0.8, g=0.6, b=0.2},
    map_grid = false
  },
    createBasicLight("geothermal-light-" .. label .. color, {brightness = 0.1+0.1*index, size = 6+3*index, color = params.light})
        })
    end
end
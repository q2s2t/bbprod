-- Build repeatable productivity technologies from the recipes registered during
-- Factorio's data stage. Eligible recipes are grouped by their main product,
-- configured groups are merged, and each remaining group becomes one technology
-- whose icon, cost, prerequisites, and effects come from the product and mod
-- configuration. Finally, optionally hide Space Age's overlapping technologies.

local api = require("api")
local valid = require("lualib.valid")
local config = api.config


-- Creates the base groups. 1 group == 1 productivity technology
local groups = {}
for _, recipe in pairs(data.raw["recipe"]) do repeat

  -- skip recipe has results?
  if not recipe.results then break end
  if #recipe.results == 0 then break end
  -- skip hidden recipes
  if recipe.hidden then break end
  -- skip ignored recipes
  if config.ignore_recipe[recipe.name] then break end
  -- main result of the recipe
  local result = util.get_recipe_main_product(recipe) or recipe.results[1]
  -- skip ignored result
  if config.ignore_group[result.name] then break end
  -- skip not intermediate product or added group
  if not recipe.allow_productivity and not config.add_group[result.name] then break end
  -- skip recycling
  if recipe.categories and util.contains_value(recipe.categories, "recycling") then break end
  -- get the group entry or create a new one if it doesn't exist
  groups[result.name] = groups[result.name] or { recipes = {} }
  table.insert(groups[result.name].recipes, recipe.name)

until true end


-- Merge group
for merged_name, merged_results in pairs(api.config.merge_group) do
  local merged_recipes = {}
  for _, group in pairs(merged_results) do repeat
    if not groups[group] then break end
    for _, recipe in ipairs(groups[group].recipes) do table.insert(merged_recipes, recipe) end
    groups[group] = nil
  until true end
  groups[merged_name] = { recipes = merged_recipes }
end


-- Create the actual technology for each product. 
for k, group in pairs(groups) do repeat

  -- the main result of the group, used to determine the icon and tech cost.
  -- first because it has more chance to be base or space-age and not any other recipe.
  local result = util.get_recipe_main_product(data.raw["recipe"][group.recipes[1]]) -- best but can fail
  if not result then result = data.raw["recipe"][group.recipes[1]].results[1] end -- failover
  local alt_main_result = config.alt_main_result[k]
  if alt_main_result then
    result = valid.result[alt_main_result]
    result.name = alt_main_result
  end
  local result_type = result.type == "fluid" and "fluid" or "item"
  local main_categories = data.raw["recipe"][group.recipes[1]].categories

  -- Costs and prequisites follow this priority: category < special < group
  local unit_name = config.unit_from_special["any"]

  if main_categories then for category, unit in pairs(config.unit_from_category) do
    if util.contains_value(main_categories, category) then
      unit_name = unit
    end
  end end

  if config.unit_from_special["fluid"]
    and result.type == "fluid"
    then unit_name = config.unit_from_special["fluid"] end

  if config.unit_from_special["fuel"]
    and valid.result[result.name].fuel_value
    then unit_name = config.unit_from_special["fuel"] end

  if config.unit_from_special["science-pack"] 
    and util.contains_value(valid.science_pack, k)
    then unit_name = config.unit_from_special["science-pack"] end

  if config.unit_from_group[k]
    then unit_name = config.unit_from_group[k] end

  if unit_name == "ignore" then break end

  -- FIXME shortchut that works if the prerequisites and science pack have the same name
  local prerequisites = {}
  for _, i in pairs(config.unit[unit_name].ingredients) do
    table.insert(prerequisites, i[1])
  end

  local icons = {
    { icon = "__bbprod__/graphics/technology/bb-productivity.png",
      icon_size = 256, },
    { icon = valid.result[result.name].icon,
      icon_size = 64,
      scale = 1,
      shift = { 0, -35 },
      floating = true,
      draw_background = true },
    { icon = "__core__/graphics/icons/technology/constants/constant-recipe-productivity.png",
      icon_size = 128,
      scale = 0.5,
      shift = { 50, 50 },
      floating = true }
  }

  local effects = {}
  for _, recipe in pairs(group.recipes) do
    table.insert(effects, {
      type = "change-recipe-productivity",
      recipe = recipe,
      change = 0.1
    })
  end

  local localised_key = api.config.merge_group[k]
    and { "bbprod-group." .. k }
    or { result_type .. "-name." .. result.name }

  local technology = {
    type = "technology",
    name = "bbprod-"..k.."-productivity",
    localised_name = { "technology-name.bbprod-productivity", localised_key },
    localised_description = { "technology-description.bbprod-productivity", localised_key },
    order = valid.result[result.name].order,
    icons = icons,
    effects = effects,
    prerequisites = prerequisites,
    unit = config.unit[unit_name],
    max_level = 30,
    upgrade = true
  }

  data:extend({ technology })

until true end


-- Space Age technology to remove
if api.config.remove_space_age_tech then
  local technologies = {
    "steel-plate-productivity",
    "low-density-structure-productivity",
    "processing-unit-productivity",
    "plastic-bar-productivity",
    "rocket-fuel-productivity",
    "rocket-part-productivity",
  }
  for _, technology_name in pairs(technologies) do
    local technology = data.raw.technology[technology_name]
    if technology then
      technology.hidden = true
      technology.enabled = false
    end
  end
end

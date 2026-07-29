-- get mod settings
local S = data.raw["mod-data"]["bbprod-settings"].data

-- get list of all icons and order strings for all prototypes that have a stack_size (item, capsule, ammo, ...)
-- or are fluids. do this because it's a pain to look for info like icon or order sting with only the recipe
-- results.
local icons = {}
local orders = {}
for proto_key, proto in pairs(data.raw) do
  for _, obj in pairs(proto) do
    if
      proto_key == "fluid"
      or obj.stack_size
      and obj.icon
      and obj.order
    then
      icons[obj.name] = obj.icon
      orders[obj.name] = obj.order
    end
  end
end

-- get all available science packs
local science_packs = {}
for _, lab in pairs(data.raw["lab"]) do
  for _, item in pairs(lab.inputs) do
    if not util.contains_value(science_packs, item) then table.insert(science_packs, item) end
  end
end

-- 
-- Create a list of all recipes that allow productivity and group them by their main result
-- Example: ```lua
-- groups = {
--   ["iron-plate"] = {
--     recipes = {"iron-plate", "casting-iron"},
--   },
--  ["copper-plate"] = { ... }
-- ```

local groups = {}
for _, recipe in pairs(data.raw["recipe"]) do repeat

  if not recipe.results then break end
  if #recipe.results == 0 then break end -- recipe has results?
  if recipe.allow_productivity ~= true then break end -- is an intermediate product?
  if recipe.hidden then break end -- recipe is not hidden?
  if util.contains_value(S.ignore_recipe, recipe.name) then break end
  if recipe.categories ~= nil and util.contains_value(recipe.categories, "recycling") then break end -- skip recycling

  local result = util.get_recipe_main_product(recipe) or recipe.results[1] -- main result of the recipe
 
  if util.contains_value(S.ignore_group, result.name) then break end -- skip ignoreed result

  -- get the group entry or create a new one if it doesn't exist
  groups[result.name] = groups[result.name] or { recipes = {} }
  table.insert(groups[result.name].recipes, recipe.name)

until true end

--
-- Merge groups
--
for merged_name, merged_results in pairs(S.merge_group) do
  local merged_recipes = {}
  for _, result in pairs(merged_results) do
      for _, recipe in ipairs(groups[result].recipes) do table.insert(merged_recipes, recipe) end
      groups[result] = nil
  end
  groups[merged_name] = { recipes = merged_recipes, is_merge_group = true }
end

--
-- Create the actual technology for each product. 
--

for group_name, group in pairs(groups) do

  -- the main result of the group, used to determine the icon and tech cost.
  -- first because it has more chance to be base or space-age and not any other recipe.
  local main_result = util.get_recipe_main_product(data.raw["recipe"][group.recipes[1]]) -- best but can fail
  if not main_result then main_result = data.raw["recipe"][group.recipes[1]].results[1] end -- failover
  if S.alt_main_result[group_name] then main_result = S.alt_main_result[group_name] end -- overwrite
  local main_categories = data.raw["recipe"][group.recipes[1]].categories

  -- Costs and prequisites follow this priority: category < special < group
  local unit_name = S.unit_from_special["any"]

  if main_categories then for category, unit in pairs(S.unit_from_category) do
    if util.contains_value(main_categories, category) then
      unit_name = unit
    end
  end end

  if S.unit_from_special["fluid"]
    and main_result.type == "fluid"
    then unit_name = S.unit_from_special["fluid"] end

  if S.unit_from_special["fuel"]
    and main_result.type == "item"
    and data.raw.item[main_result.name]
    and data.raw.item[main_result.name].fuel_value
    then unit_name = S.unit_from_special["fuel"] end

  if S.unit_from_special["science-pack"] 
    and util.contains_value(science_packs, group_name)
    then unit_name = S.unit_from_special["science-pack"] end

  if S.unit_from_group[group_name]
    then unit_name = S.unit_from_group[group_name] end

  if unit_name == "ignore" then goto next_group end

  local prerequisites = {} -- FIXME shortchut that works if the technology and science pack have the same name
  for _, i in pairs(S.unit[unit_name].ingredients) do
    table.insert(prerequisites, i[1])
  end

  -- an icon by defaults if no icon is found
  local group_icon_data = {
    icon = "__base__/graphics/item-group/intermediate-products.png",
    icon_size = 128, scale = 0.5,
    shift = {0, -35}, floating = true, draw_background = true }
  if icons[main_result.name] ~= nil then
    group_icon_data.icon = icons[main_result.name]
    group_icon_data.icon_size = 64
    group_icon_data.scale = 1
  end
  local icons = {
    { icon = "__bbprod__/graphics/technology/bb-productivity.png",
      icon_size = 256, },
    group_icon_data,
    { icon = "__core__/graphics/icons/technology/constants/constant-recipe-productivity.png",
      icon_size = 128,
      scale = 0.5,
      shift = {50, 50},
      floating = true }
  }

  -- apply the productivity bonus to each recipe
  local effects = {}
  for _, recipe in pairs(group.recipes) do
    table.insert(effects, {
      type = "change-recipe-productivity",
      recipe = recipe,
      change = 0.1
    })
  end

  local localised_key = {(main_result.type or "item").."-name."..main_result.name}
  if group.is_merge_group then localised_key = {"bbprod-group."..group_name}  end

  local technology = {
    type = "technology",
    name = "bbprod-"..group_name.."-productivity",
    localised_name = { "technology-name.bbprod-productivity", localised_key },
    localised_description = { "technology-description.bbprod-productivity", localised_key },
    order = orders[main_result.name],
    icons = icons,
    effects = effects,
    prerequisites = prerequisites,
    unit = S.unit[unit_name],
    max_level = 30,
    upgrade = true
  }

  data:extend({ technology })
  ::next_group::

end

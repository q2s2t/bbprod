require("prototypes.mod-data.settings")

local api = require("api")
local config = api.config
local validate = api.validate

-- Get list of all names icons and order strings for all prototypes that have a
-- stack_size (item, capsule, ammo, ...) or are fluids. do this because it's a
-- pain to look for info like icon or order sting with only the recipe results.
api.storage.valid_result = {}
for type, content in pairs(data.raw) do for _, obj in pairs(content) do
  if (type == "fluid" or obj.stack_size)
  and obj.name
  and obj.icon
  and obj.order
  and obj.subgroup
  and data.raw["item-subgroup"][obj.subgroup]
  then
    api.storage.valid_result[obj.name] = {
      type = type,
      icon = obj.icon,
      order = data.raw["item-subgroup"][obj.subgroup].group.."/"..obj.subgroup.."/"..obj.order,
    }
    if obj.fuel_value then api.storage.valid_result[obj.name].fuel_value = obj.fuel_value end
  end
end end

api.storage.valid_special = { "any", "fluid", "fuel", "science-pack" }

-- table to be built mod by mod
api.storage.valid_unit = {}

-- get all available science packs
api.storage.valid_science_pack = {}
for _, lab in pairs(data.raw["lab"]) do
  for _, item in pairs(lab.inputs) do
    if not util.contains_value(api.storage.valid_science_pack, item) then
      table.insert(api.storage.valid_science_pack, item) end end
end

api.apply_data_config(function (mod_data)

  -- user setting = validation required

  if not config.ignore_recipe then config.ignore_recipe = {} end
  if mod_data.ignore_recipe then
  for k, _ in pairs(mod_data.ignore_recipe) do repeat
    if k:sub(1,2) == "--" then config.ignore_recipe[k:sub(3)] = nil break end
    if not validate('Invalid recipe: "'..k..'" does not exist, ignored',
      data.raw["recipe"][k]) then break end
    -- guards are ok
    config.ignore_recipe[k] = true
  until true end end

  if not config.ignore_group then config.ignore_group = {} end
  if mod_data.ignore_group then
  for k, _ in pairs(mod_data.ignore_group) do repeat
    if k:sub(1,2) == "--" then config.ignore_group[k:sub(3)] = nil break end
    if not validate('Invalid ignored group: "'..k..'" does not exist, ignored',
      api.storage.valid_result[k]) then break end
    -- guards are ok
    config.ignore_group[k] = true
  until true end end

  if not config.add_group then config.add_group = {} end
  if mod_data.add_group then
  for k, _ in pairs(mod_data.add_group) do repeat
    if k:sub(1,2) == "--" then config.add_group[k:sub(3)] = nil break end
    if not validate('Invalid added group: "'..k..'" does not exist, ignored',
      api.storage.valid_result[k]) then break end
    -- guards are ok
    config.add_group[k] = true
  until true end end

  if not config.merge_group then config.merge_group = {} end
  if mod_data.merge_group then
  for k, groups in pairs(mod_data.merge_group) do repeat
    if groups[1] == "--" then config.merge_group[k] = nil break end
    if not config.merge_group[k] then config.merge_group[k] = {} end
    for _, group in pairs(groups) do
      if not validate('Invalid merge group: "'..group..'" does not exist, ignored',
        api.storage.valid_result[group]) then break end
      -- guards are ok
      table.insert(config.merge_group[k], group) end
  until true end end

  if not config.alt_main_result then config.alt_main_result = {} end
  if mod_data.alt_main_result then
  for k, alt in pairs(mod_data.alt_main_result) do repeat
    if alt == "--" then config.alt_main_result[k] = nil break end
    if not validate('Invalid alternative results key: "'..k..'" does not exist, ignored',
      api.storage.valid_result[k])
    or not validate('Invalid alternative result: "'..alt..'" does not exist, ignored',
      api.storage.valid_result[alt]) then break end
    -- guards are ok
    config.alt_main_result[k] = alt
  until true end end

  if not config.unit then config.unit = {} end
  if mod_data.unit then
  for k, unit in pairs(mod_data.unit) do repeat
    local is_valid = true
    for _, i in pairs(unit.ingredients) do
      if is_valid then
        if not util.contains_value(api.storage.valid_science_pack, i[1]) then
          is_valid = false end end end
    if not validate('Invalid unit "'..k..'", the unit is ignored', is_valid) then break end
    -- guards are ok
    config.unit[k] = unit
    table.insert(api.storage.valid_unit, k)
  until true end end

  if not config.unit_from_special then config.unit_from_special = {} end
  if mod_data.unit_from_special then
  for k, unit in pairs(mod_data.unit_from_special) do repeat
    if unit == "--" then config.unit_from_special[k] = nil break end
    if not validate('Invalid special: "'..k..'" must be one of '..serpent.line(api.storage.valid_special),
      util.contains_value(api.storage.valid_special, k))
    or not validate("Invalid unit (unit_from_special): "..unit,
      util.contains_value(api.storage.valid_unit, unit)
      or unit == "ignore") then break end
    -- guards are ok
    config.unit_from_special[k] = unit
  until true end end

  if not config.unit_from_category then config.unit_from_category = {} end
  if mod_data.unit_from_category then
  for k, unit in pairs(mod_data.unit_from_category) do repeat
    if unit == "--" then config.unit_from_category[k] = nil break end
    if not validate('Invalid category (unit_from_category) : "'..k..'" does not exist, ignored',
      data.raw["recipe-category"][k])
    or not validate("Invalid unit (unit_from_category): "..unit,
      util.contains_value(api.storage.valid_unit, unit)
      or unit == "ignore") then break end
    -- guards are ok
    config.unit_from_category[k] = unit
  until true end end

  if not config.unit_from_group then config.unit_from_group = {} end
  if mod_data.unit_from_group then
  for k, unit in pairs(mod_data.unit_from_group) do repeat
    if unit == "--" then config.unit_from_group[k] = nil break end
    if not validate('Invalid group (unit_from_group): "'..k..'" does not exist, ignored',
      api.storage.valid_result[k] or config.merge_group[k])
    or not validate("Invalid unit (unit_from_group): "..unit,
      util.contains_value(api.storage.valid_unit, unit)
      or unit == "ignore")
    then break end
    -- guards are ok
    config.unit_from_group[k] = unit
  until true end end

  -- no validation
  config.remove_space_age_tech = mod_data.remove_space_age_tech


end)

require("prototypes.technology")

require("prototypes.mod-data.settings")

local api = require("api")
local valid = require("lualib.valid")
local contains = require("util").contains_value
local config = api.config


valid.result = require("lualib.valid_result")
valid.science_pack = require("lualib.valid_science_pack")
valid.unit = { "ignore" } -- will be populated
valid.special = { "any", "fluid", "fuel", "ammo", "module", "science-pack" }


api.apply_data_config(function (mod_data)

  config.ignore_recipe = config.ignore_recipe or {}
  if mod_data.ignore_recipe then for k in pairs(mod_data.ignore_recipe) do repeat
    if k:sub(1, 2) == "--" then config.ignore_recipe[k:sub(3)] = nil break end
    if not valid.is("recipe", k, data.raw["recipe"][k]) then break end
    config.ignore_recipe[k] = true
  until true end end

  config.ignore_group = config.ignore_group or {}
  if mod_data.ignore_group then for k in pairs(mod_data.ignore_group) do repeat
    if k:sub(1, 2) == "--" then config.ignore_group[k:sub(3)] = nil break end
    if not valid.is("ignored group", k, valid.result[k]) then break end
    config.ignore_group[k] = true
  until true end end

  config.add_group = config.add_group or {}
  if mod_data.add_group then for k in pairs(mod_data.add_group) do repeat
    if k:sub(1, 2) == "--" then config.add_group[k:sub(3)] = nil break end
    if not valid.is("added group", k, valid.result[k]) then break end
    config.add_group[k] = true
  until true end end

  config.merge_group = config.merge_group or {}
  if mod_data.merge_group then for k, groups in pairs(mod_data.merge_group) do repeat
    if groups[1] == "--" then config.merge_group[k] = nil break end
    config.merge_group[k] = config.merge_group[k] or {}
    for _, group in pairs(groups) do repeat
      if not valid.is("merge group: ", group, valid.result[group]) then break end
      table.insert(config.merge_group[k], group)
    until true end
  until true end end

  config.alt_main_result = config.alt_main_result or {}
  if mod_data.alt_main_result then for k, alt in pairs(mod_data.alt_main_result) do repeat
    if alt == "--" then config.alt_main_result[k] = nil break end
    if not valid.is("alternative result", k,  valid.result[k]) then break end
    if not valid.is("alternative result", alt,  valid.result[alt]) then break end
    config.alt_main_result[k] = alt
  until true end end

  config.unit = config.unit or {}
  if mod_data.unit then for k, unit in pairs(mod_data.unit) do repeat
    local test = true
    for _, ingredient in pairs(unit.ingredients) do
      if not contains(valid.science_pack, ingredient[1]) then test = false end end
    if not valid.is("unit", k, test) then break end
    config.unit[k] = unit
    table.insert(valid.unit, k)
  until true end end

  config.unit_from_special = config.unit_from_special or {}
  if mod_data.unit_from_special then for k, unit in pairs(mod_data.unit_from_special) do repeat
    if unit == "--" then config.unit_from_special[k] = nil break end
    if not valid.is("special", k, contains(valid.special, k)) then break end
    if not valid.is("unit_from_special", unit, contains(valid.unit, unit)) then break end
    config.unit_from_special[k] = unit
  until true end end

  config.unit_from_category = config.unit_from_category or {}
  if mod_data.unit_from_category then for k, unit in pairs(mod_data.unit_from_category) do repeat
    if unit == "--" then config.unit_from_category[k] = nil break end
    if not valid.is("unit_from_category", k, data.raw["recipe-category"][k]) then break end
    if not valid.is("unit_from_category", unit, contains(valid.unit, unit)) then break end
    config.unit_from_category[k] = unit
  until true end end

  config.unit_from_group = config.unit_from_group or {}
  if mod_data.unit_from_group then for k, unit in pairs(mod_data.unit_from_group) do repeat
    if unit == "--" then config.unit_from_group[k] = nil break end
    if not valid.is("unit_from_group", k, valid.result[k] or config.merge_group[k]) then break end
    if not valid.is("unit_from_group", unit, contains(valid.unit, unit)) then break end
    config.unit_from_group[k] = unit
  until true end end

  config.remove_space_age_tech = mod_data.remove_space_age_tech

  config.add_ammo = mod_data.add_ammo

  config.add_module = mod_data.add_module

  config.add_science_pack = mod_data.add_science_pack
  if config.add_science_pack == false then config.unit_from_special["science-pack"] = "ignore" end

  config.alt_icon = config.alt_icon or {}
  if mod_data.alt_icon then for k, alt in pairs(mod_data.alt_icon) do repeat
    if alt == "--" then config.alt_icon[k] = nil break end
    -- no validation
    config.alt_icon[k] = alt
  until true end end

end)


require("prototypes.technology")

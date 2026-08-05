local api = require("api")
local contains = require("util").contains_value
local f = string.format
local valid = { warnings = api.warnings }

---@param what string Invalid what?
---@param value any Value to be displayed in the warning
---@param test boolean|nil Validation test
---@return boolean valid Side effect: logs and add to the warning table.
valid.is = function (what, value, test)
  if test then return true end
  local w = f("Invalid %s: %s", what, value)
  log(w)
  table.insert(valid.warnings, w)
  return false
end

-- Populates valid.science_pack with all science packs
valid.get_science_pack = function ()
  valid.science_pack = {}
  for _, lab in pairs(data.raw["lab"]) do
    for _, item in pairs(lab.inputs) do repeat
      if contains(valid.science_pack, item) then break end
      table.insert(valid.science_pack, item)
    until true end
  end
end

-- Populates valid.result
-- Get list of all names icons and order strings for all prototypes that have a
-- stack_size (item, capsule, ammo, ...) or are fluids. do this because it's a
-- pain to look for info like icon or order sting with only the recipe results.
valid.get_result = function ()
  valid.result = {}
  for type, prototypes in pairs(data.raw) do for _, obj in pairs(prototypes) do repeat
    if not (type == "fluid" or obj.stack_size) then break end
    if not (obj.name and obj.icon and obj.order and obj.subgroup) then break end
    if not (data.raw["item-subgroup"][obj.subgroup]) then break end
    local group = data.raw["item-subgroup"][obj.subgroup].group
    local subgroup = obj.subgroup
    local order = obj.order
    valid.result[obj.name] = {
      type = type,
      icon = obj.icon,
      order = f("%s/%s/%s", group, subgroup, order)
    }
    if not obj.fuel_value then break end
    valid.result[obj.name].fuel_value = obj.fuel_value
  until true end end
end

return valid

-- Populates result
-- Get list of all names icons and order strings for all prototypes that have a
-- stack_size (item, capsule, ammo, ...) or are fluids. do this because it's a
-- pain to look for info like icon or order sting with only the recipe results.
local get_result = function ()
  local result = {}
  for type, prototypes in pairs(data.raw) do for _, obj in pairs(prototypes) do repeat
    if not (type == "fluid" or obj.stack_size) then break end
    if not (obj.name and obj.icon) then break end
    local order = obj.order or ""
    local subgroup = obj.subgroup or ""
    local group = ""
    if obj.subgroup then group = data.raw["item-subgroup"][subgroup].group end
    result[obj.name] = {
      type = type,
      icon = obj.icon,
      order = string.format("%s/%s/%s", group, subgroup, order)
    }

    -- Optional ammo_category
    local attack = type == "capsule"
      and obj.capsule_action
      and obj.capsule_action.attack_parameters
    local is_land_mine = obj.place_result
      and data.raw["land-mine"]
      and data.raw["land-mine"][obj.place_result]
    local ammo_category = obj.ammo_category
      or (attack and attack.ammo_category)
    if type == "ammo" or attack or is_land_mine then
      result[obj.name].ammo_category = ammo_category
    end

    -- Optional fuel_value
    if not obj.fuel_value then
      result[obj.name].fuel_value = obj.fuel_value
    end

    -- Optional module value
    if data.raw["module"][obj.name] then
      result[obj.name].is_module = true
    end

  until true end end
  return result
end

return get_result()

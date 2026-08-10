local contains = require("util").contains_value

-- Populates valid.science_pack with all science packs
local get_science_pack = function ()
  local science_pack = {}
  for _, lab in pairs(data.raw["lab"]) do
    for _, item in pairs(lab.inputs) do repeat
      if contains(science_pack, item) then break end
      table.insert(science_pack, item)
    until true end
  end
  return science_pack
end

return get_science_pack()
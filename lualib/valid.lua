local api = require("api")
local valid = { warnings = api.warnings }

---@param what string Invalid what?
---@param value any Value to be displayed in the warning
---@param test boolean|nil Validation test
---@return boolean valid Side effect: logs and add to the warning table.
valid.is = function (what, value, test)
  if test then return true end
  local w = string.format("Invalid %s: %s", what, value)
  log(w)
  table.insert(valid.warnings, w)
  return false
end

return valid

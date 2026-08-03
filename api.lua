local api = {
  name = "bbprod",
  version = "v0",
  warnings = {}, -- stores warnings for the current stage
  config = {}, -- stores config for the current stage
  storage = {}, -- general storage
}

-- -----------------------------------------------------------------------------
-- Prototype stage
-- -----------------------------------------------------------------------------

api.init_data = function ()
  data:extend({{
    type = "mod-data",
    name = api.name,
    data_type = api.name.."."..api.version,
    data = { 
      warnings = api.warnings,
      config = api.config,
      storage = api.storage,
    } } })
    api.config.data_type = api.name..".config."..api.version
end

-- config load order is:
-- 1. this mod configuration, declared in `data.lua`
-- 2. other mod configuration, declared in their `data-updates.lua`.
-- 3. user settings, inserted at the end of the list through mod-data
api.apply_data_config = function (cb)
  for _, mod_data in pairs(data.raw["mod-data"]) do
    if mod_data.data_type == api.config.data_type then
      cb(mod_data.data)
    end
  end
  return api.config
end

-- -----------------------------------------------------------------------------
-- Runtime stage
-- -----------------------------------------------------------------------------

api.init_control = function (cb)
  api.config = prototypes.mod_data[api.name].data.config
  script.on_configuration_changed(function (config_changed_data)
    for _, player in pairs(game.players) do
      api.show_runtime_warnings(player)
      if cb then cb(config_changed_data) end
    end
  end)
end

api.show_runtime_warnings = function (player)
  local proto_warnings = prototypes.mod_data[api.name].data.warnings
  if #proto_warnings > 0 then
    player.print("[color=yellow]["..api.name.."] has warnings. Check factorio-current.log[/color]")
    for _, w in pairs(proto_warnings) do
      player.print("[color=yellow]["..api.name.."] "..w.."[/color]")
    end
  end
  local runtime_warnings = api.warnings
  if #runtime_warnings > 0 then
    player.print("[color=yellow]["..api.name.."] has runtime warnings:[/color]")
    for _, w in pairs(runtime_warnings) do
      player.print("[color=yellow]["..api.name.."] "..w.."[/color]")
    end
  end
end

-- -----------------------------------------------------------------------------
-- Utils
-- -----------------------------------------------------------------------------

---Validate and optionally runs recovery logic.
---@param msg string message to print and add to warnings list
---@param v boolean validation test
---@param recovery function? callback when validation fails.
api.validate = function (msg, v, recovery)
  if not v then
    log(msg)
    table.insert(api.warnings, msg)
    if recovery then recovery() end
    return false
  end
  return true
end

return api

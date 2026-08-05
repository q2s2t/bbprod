local api = {}
api.warnings = {} -- stores warnings for the current stage
api.config = {} -- stores config for the current stage
api.storage = {} -- general storage

-- Populate this mod's prototype-stage state so later prototype stages and the
-- runtime stage can share configuration, warnings, and storage.
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

-- Config load order is:
-- 1. This mod configuration, declared in `data.lua`
-- 2. Other mod configuration, declared in their `data-updates.lua`.
-- 3. Sser settings, inserted at the end of the list through mod-data
api.apply_data_config = function (cb)
  for _, mod_data in pairs(data.raw["mod-data"]) do repeat
    if mod_data.data_type ~= api.config.data_type then break end
    cb(mod_data.data)
  until true end
end

-- Initialize runtime-stage. Show warnings to the player when config change.
-- The optional callback is useful to inject code in `on_configuration_changed`
-- since it can only have one handler per mod.
---@param cb fun(config_changed_data: ConfigurationChangedData)|nil
api.init_control = function (cb)
  api.config = prototypes.mod_data[api.name].data.config
  script.on_configuration_changed(function (config_changed_data)
    for _, player in pairs(game.players) do
      api.show_runtime_warnings(player)
      if cb then cb(config_changed_data) end
    end
  end)
end

-- Show warnings to the player
---@param player LuaPlayer player to notify
api.show_runtime_warnings = function (player)
  local proto_warnings = prototypes.mod_data[api.name].data.warnings
  if #proto_warnings > 0 then
    player.print("[color=yellow]["..api.name.."] has warnings. Check factorio-current.log[/color]")
    for _, w in ipairs(proto_warnings) do
      player.print("[color=yellow]["..api.name.."] "..w.."[/color]")
    end
  end
  local runtime_warnings = api.warnings
  if #runtime_warnings > 0 then
    player.print("[color=yellow]["..api.name.."] has runtime warnings:[/color]")
    for _, w in ipairs(runtime_warnings) do
      player.print("[color=yellow]["..api.name.."] "..w.."[/color]")
    end
  end
end

return api

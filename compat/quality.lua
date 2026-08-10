local api = require("api")
local compat = "quality"
if not mods[compat] then return end

data:extend({{
  type = "mod-data",
  name = "bbprod-config-"..compat,
  data_type = api.config.data_type,
  data = {

    source = compat,

    merge_group = {
      ["module"] = { "quality-module", "quality-module-2", "quality-module-3", },
    },

    alt_icon = {
      ["module"] = {
        icon = "__quality__/graphics/technology/module.png",
        icon_size = 256,
        scale = 0.25,
      },
    },

}}})

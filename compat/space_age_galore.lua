
local api = require("api")
local compat = "space_age_galore"
if not mods[compat] then return end

data:extend({{
  type = "mod-data",
  name = "bbprod-config-compat-"..compat,
  data_type = api.config.data_type,
  data = {

    source = compat,

    ignore_group = {
      ["lava"] = true,
      ["holmium-ore"] = true,
    },

    merge_group = {
      ["uranium-chain"] = { "uranium-ore", "nuclear-fuel" },
      ["lithium-chain"] = { "fusion-power-cell" },
      ["concrete"] = { "concrete", "refined-concrete" }
    },

}}})

local api = require("api")
local compat = "maraxsis"
if not mods[compat] then return end

data:extend({{
  type = "mod-data",
  name = "bbprod-config-compat-"..compat,
  data_type = api.config.data_type,
  data = {

    source = compat,

}}})

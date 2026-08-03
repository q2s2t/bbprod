local api = require("api")
local parse = require("lualib.parse")
local source = "settings"
local s = settings.startup

data:extend({{
  type = "mod-data",
  name = "bbprod-config-"..source,
  data_type = api.config.data_type,
  data = {

    source = source,

    ignore_recipe = parse.sc_string(s["bbprod-ignore-recipe"].value),
    ignore_group = parse.sc_string(s["bbprod-ignore-group"].value),
    add_group = parse.sc_string(s["bbprod-add-group"].value),
    merge_group = parse.sc_key_strings(s["bbprod-merge-group"].value),
    alt_main_result = parse.sc_key_string(s["bbprod-alt-main-result"].value),
    unit = parse.sc_unit(s["bbprod-unit"].value),
    unit_from_special = parse.sc_key_string(s["bbprod-unit-from-special"].value),
    unit_from_category = parse.sc_key_string(s["bbprod-unit-from-category"].value),
    unit_from_group = parse.sc_key_string(s["bbprod-unit-from-group"].value),
    remove_space_age_tech = s["bbprod-remove-space-age-tech"].value

  }
}})

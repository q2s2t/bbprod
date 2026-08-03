local api = require("api")
local source = "base"

data:extend({{
  type = "mod-data",
  name = "bbprod-config-"..source,
  data_type = api.config.data_type,
  data = {

    source = source,

    ignore_recipe = {
      -- ["basic-oil-processing"] = true,
    },

    ignore_group = {
      ["barrel"] = true,
    },

    add_group = {
      -- ["firearm-magazine"] = true,
    },

    merge_group = {
      ["uranium-chain"] = { "uranium-235", "uranium-238", "uranium-fuel-cell" },
    },

    alt_main_result = {
      -- ["explosives"] = "cliff-explosives",
    },

    unit_from_special = {
      ["any"] = "production",
      ["fluid"] = "chemical",
      ["fuel"] = "space",
      ["science-pack"] = "science-pack",
    },

    unit_from_category = {
      -- ["smelting"] = "military",
    },

    unit_from_group = {
      ["rocket-part"] = "space",
    },

    unit = {
      ["military"] = { count_formula = "1.5^L*1000", time = 60, ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "military-science-pack", 1 },
      }},
      ["chemical"] = { count_formula = "1.5^L*1000", time = 60, ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
      }},
      ["production"] = { count_formula = "1.5^L*1000", time = 60, ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
      }},
      ["utility"] = { count_formula = "1.5^L*1000", time = 60, ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "utility-science-pack", 1 },
      }},
      ["space"] = { count_formula = "1.5^L*1000", time = 60, ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "space-science-pack", 1 },
      }},
        ["science-pack"] = { count_formula = "1.5^L*1000", time = 60, ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "military-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
      }},
    },

}}})

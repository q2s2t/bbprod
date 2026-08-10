local api = require("api")
local compat = "space-age"
if not mods[compat] then return end

data:extend({{
  type = "mod-data",
  name = "bbprod-config-compat-"..compat,
  data_type = api.config.data_type,
  data = {

    source = compat,

    ignore_group = {
      ["iron-ore"] = true,
      ["artificial-jellynut-soil"] = true,
      ["artificial-yumako-soil"] = true,
      ["overgrowth-jellynut-soil"] = true,
      ["overgrowth-yumako-soil"] = true,
      ["ice"] = true,
    },

    merge_group = {
      ["thruster-fluid"] = { "thruster-fuel", "thruster-oxidizer" },
      ["tungsten-chain"] = { "tungsten-plate", "tungsten-carbide" },
      ["holmium-chain"] = { "holmium-plate", "holmium-solution" },
      ["lithium-chain"] = { "lithium-plate", "lithium" },
      ["nauvis-biota"] = { "raw-fish", "tree-seed" },
      ["gleba-biota"] = {},
      ["capsule-ammo"] = { "capture-robot-rocket" }
    },

    alt_main_result = {
      ["jellynut-seed"] = "jelly",
      ["yumako-seed"] = "yumako-mash",
    },

    unit = {
      ["vulcanus"] = { count_formula = "1.5^L*1000", time = 60, ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "metallurgic-science-pack", 1 },
      }},
      ["fulgora"] = { count_formula = "1.5^L*1000", time = 60, ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "electromagnetic-science-pack", 1 },
      }},
      ["gleba"] = { count_formula = "1.5^L*1000", time = 60, ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "agricultural-science-pack", 1 },
      }},
      ["aquilo"] = { count_formula = "1.5^L*1000", time = 60, ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "cryogenic-science-pack", 1 },
      }},
      ["planetary"] = { count_formula = "1.5^L*1000", time = 60, ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "space-science-pack", 1 },
        { "metallurgic-science-pack", 1 },
        { "electromagnetic-science-pack", 1 },
        { "agricultural-science-pack", 1 },
        { "cryogenic-science-pack", 1 },
      }},
      ["science-pack"] = { count_formula = "1.2^L*1000", time = 60, ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "military-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "production-science-pack", 1 },
        { "utility-science-pack", 1 },
        { "space-science-pack", 1 },
        { "metallurgic-science-pack", 1 },
        { "electromagnetic-science-pack", 1 },
        { "agricultural-science-pack", 1 },
        { "cryogenic-science-pack", 1 },
        { "promethium-science-pack", 1 },
      }},
    },

    unit_from_special = {
      ["any"] = "production",
      ["fluid"] = "--",
      ["fuel"] = "--",
      ["module"] = "planetary",
      ["science-pack"] = "science-pack",
    },

    unit_from_category = {
      -- overwrites base
      ["centrifuging"] = "space",
      ["smelting"] = "vulcanus",
      ["oil-processing"] = "fulgora",
      ["crafting-with-fluid"] = "fulgora",
      ["chemistry"] = "gleba",
      -- space-age
      ["crushing"] = "space",
      ["metallurgy"] = "vulcanus",
      ["electromagnetics"] = "fulgora",
      ["organic"] = "gleba",
      ["captive-spawner-process"] = "gleba",
      ["cryogenics"] = "aquilo",
    },

    unit_from_group = {
      ["rocket-part"] = "aquilo",
      ["low-density-structure"] = "vulcanus",
      ["flying-robot-frame"] = "aquilo",
      ["thruster-fluid"] = "space",
      ["quantum-processor"] = "aquilo",
      ["water"] = "space",
      ["coal"] = "space",
      ["stone"] = "space",
      ["petroleum-gas"] = "gleba",
      ["heavy-oil"] = "gleba",
    },

    removed_tech = {
    "steel-plate-productivity",
    "low-density-structure-productivity",
    "processing-unit-productivity",
    "plastic-bar-productivity",
    "rocket-fuel-productivity",
    "rocket-part-productivity",
  }

}}})

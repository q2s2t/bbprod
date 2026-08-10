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

    add_ammo = false,

    add_module = false,

    merge_group = {
      ["uranium-chain"] = { "uranium-235", "uranium-238", "uranium-fuel-cell" },
      ["physical-projectile"] = {
        "firearm-magazine", "piercing-rounds-magazine", "uranium-rounds-magazine",
        "shotgun-shell", "piercing-shotgun-shell",
        "cannon-shell", "explosive-cannon-shell", "uranium-cannon-shell", "explosive-uranium-cannon-shell",
      },
      ["explosive-ammo"] = {
        "rocket", "explosive-rocket", "atomic-bomb",
        "grenade", "cluster-grenade",
        "land-mine", "cliff-explosives",
      },
      ["capsule-ammo"] = {
        "poison-capsule", "slowdown-capsule",
        "defender-capsule", "distractor-capsule", "destroyer-capsule"
      },
      ["module"] = {
        "speed-module", "speed-module-2", "speed-module-3",
        "efficiency-module", "efficiency-module-2", "efficiency-module-3",
        "productivity-module", "productivity-module-2", "productivity-module-3",
      },
    },

    alt_main_result = {
      -- ["explosives"] = "cliff-explosives",
    },

    alt_icon = {
      ["module"] = {
        icon = "__base__/graphics/technology/module.png",
        icon_size = 256,
        scale = 0.25,
        -- shift = { 0, -20 },
      },
      ["rocket-part"] = {
        icon = "__space-age__/graphics/technology/rocket-part-productivity.png",
        icon_size = 256,
        scale = 0.25,
        -- shift = { 0, -20 },
      }
    },

    unit_from_special = {
      ["any"] = "production",
      ["fluid"] = "chemical",
      ["fuel"] = "space",
      ["ammo"] = "military-2",
      ["module"] = "science-pack",
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
      ["military-2"] = { count_formula = "1.5^L*1000", time = 60, ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
        { "military-science-pack", 1 },
        { "chemical-science-pack", 1 },
        { "utility-science-pack", 1 },
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

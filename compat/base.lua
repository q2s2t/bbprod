if not mods["base"] then return end

local S = data.raw["mod-data"]["bbprod-settings"].data

S.ignore_recipe = {
  -- 
}

S.ignore_group = {
  "barrel",
}

S.merge_group = {
  ["uranium-chain"] = { "uranium-235", "uranium-238", "uranium-fuel-cell" },
}

S.alt_main_result = {
  --
}

S.unit_from_special = {
  ["any"] = "production",
  ["fluid"] = "chemical",
  ["fuel"] = "space",
  ["science-pack"] = "science-pack",
}

S.unit_from_category = {
  -- ["smelting"] = "military",
}

S.unit_from_group = {
  ["rocket-part"] = "space",
  -- ["flying-robot-frame"] = "utility",
}
-- rocket-part=space

S.unit = {
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
}

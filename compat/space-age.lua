if not mods["space-age"] then return end

local S = data.raw["mod-data"]["bbprod-settings"].data

S.remove_space_age_tech = settings.startup["bbprod-remove-space-age-tech"].value
if S.remove_space_age_tech then
  local technologies = {
    "steel-plate-productivity",
    "low-density-structure-productivity",
    "processing-unit-productivity",
    "plastic-bar-productivity",
    "rocket-fuel-productivity",
  }
  for _, technology_name in pairs(technologies) do
    local technology = data.raw.technology[technology_name]
    if technology then
      technology.hidden = true
      technology.enabled = false
    end
  end
end

table.insert(S.ignore_group, "iron-ore")
table.insert(S.ignore_group, "rocket-part")
table.insert(S.ignore_group, "artificial-jellynut-soil")
table.insert(S.ignore_group, "artificial-yumako-soil")
table.insert(S.ignore_group, "overgrowth-jellynut-soil")
table.insert(S.ignore_group, "overgrowth-yumako-soil")

S.merge_group["thruster-fluid"] = { "thruster-fuel", "thruster-oxidizer" }
S.merge_group["tungsten-chain"] = { "tungsten-plate", "tungsten-carbide" }
S.merge_group["holmium-chain"] = { "holmium-plate", "holmium-solution" }
S.merge_group["seed-processing"] = { "tree-seed", "yumako-seed", "jellynut-seed" }
S.merge_group["lithium-chain"] = { "lithium-plate", "lithium" }

S.alt_main_result = {
  ["jellynut-seed"] = { type = "capsule", name = "jelly", amount = 1 },
  ["yumako-seed"] = { type = "capsule", name = "yumako-mash", amount = 1 },
}

S.unit_from_special = {
  ["any"] = "production",
  ["science-pack"] = "science-pack",
}

S.unit_from_category = {
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
}

S.unit_from_group = {
  -- ["rocket-part"] = "aquilo",
  ["low-density-structure"] = "vulcanus",
  ["flying-robot-frame"] = "aquilo",
}

S.unit["vulcanus"] = { count_formula = "1.5^L*1000", time = 60, ingredients = {
  { "automation-science-pack", 1 },
  { "logistic-science-pack", 1 },
  { "chemical-science-pack", 1 },
  { "production-science-pack", 1 },
  { "metallurgic-science-pack", 1 }}}

S.unit["fulgora"] = { count_formula = "1.5^L*1000", time = 60, ingredients = {
  { "automation-science-pack", 1 },
  { "logistic-science-pack", 1 },
  { "chemical-science-pack", 1 },
  { "production-science-pack", 1 },
  { "electromagnetic-science-pack", 1 }}}

S.unit["gleba"] = { count_formula = "1.5^L*1000", time = 60, ingredients = {
  { "automation-science-pack", 1 },
  { "logistic-science-pack", 1 },
  { "chemical-science-pack", 1 },
  { "production-science-pack", 1 },
  { "agricultural-science-pack", 1 }}}

S.unit["aquilo"] = { count_formula = "1.5^L*1000", time = 60, ingredients = {
  { "automation-science-pack", 1 },
  { "logistic-science-pack", 1 },
  { "chemical-science-pack", 1 },
  { "production-science-pack", 1 },
  { "cryogenic-science-pack", 1 }}}

S.unit["science-pack"] = { count_formula = "1.2^L*1000", time = 60, ingredients = {
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
}}

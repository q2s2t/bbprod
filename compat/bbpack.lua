if not mods["bbpack"] then return end

local S = data.raw["mod-data"]["bbprod-settings"].data

table.insert(S.ignore_group, "lava")
table.insert(S.ignore_group, "holmium-ore")

S.merge_group["seed-processing"] = nil
table.insert(S.merge_group["uranium-chain"], "uranium-ore")
table.insert(S.merge_group["uranium-chain"], "nuclear-fuel")
table.insert(S.merge_group["lithium-chain"], "fusion-power-cell")

S.merge_group["concrete"] = { "concrete", "refined-concrete" }

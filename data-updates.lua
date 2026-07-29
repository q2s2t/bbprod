-- run this after other mods had a chance to modify the mod-data 

-- get mod settings
local S = data.raw["mod-data"]["bbprod-settings"].data

-- merge user settings
local parser = require("lualib.parser")
parser.scsv(settings.startup["bbprod-ignore-recipes"].value, S.ignore_recipe)
parser.scsv(settings.startup["bbprod-ignore-group"].value, S.ignore_group)
parser.key_csv(settings.startup["bbprod-merge-group"].value, S.merge_group)
parser.alt_main_result(settings.startup["bbprod-alt-main-result"].value, S.alt_main_result)
parser.key_string(settings.startup["bbprod-unit-from-special"].value, S.unit_from_special)
parser.key_string(settings.startup["bbprod-unit-from-category"].value, S.unit_from_category)
parser.key_string(settings.startup["bbprod-unit-from-group"].value, S.unit_from_group)
parser.unit(settings.startup["bbprod-unit"].value, S.unit)

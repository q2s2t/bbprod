# Mod integration

Other mods can extend or override Blueberry Productivity's configuration with a `mod-data` prototype. Declare `bbprod` as a dependency and register the prototype from your mod's `data.lua`. Configuration is collected during `data-updates.lua`, after every mod has completed its data stage.

Every configuration field is optional. The following example shows all available fields:

```lua
local api = require("__bbprod__/api")

data:extend({{
  type = "mod-data",
  name = "my-mod-bbprod-config",
  data_type = api.config.data_type,
  data = {
    -- Identifies the configuration provider in diagnostics.
    source = "my-mod",

    -- Excludes individual recipes from generated technologies.
    ignore_recipe = {
      ["basic-oil-processing"] = true,
    },

    -- Excludes every recipe whose main product belongs to one of these groups.
    ignore_group = {
      ["barrel"] = true,
    },

    -- Includes products even when their recipes do not allow productivity.
    add_group = {
      ["firearm-magazine"] = true,
    },

    -- Includes products classified as ammo, modules, or science packs.
    add_ammo = true,
    add_module = true,
    add_science_pack = true,

    -- Combines product groups into one technology under the specified name.
    merge_group = {
      ["uranium-chain"] = { "uranium-235", "uranium-238", "uranium-fuel-cell", },
    },

    -- Uses another product for a group's technology name and icon.
    alt_main_result = {
      ["explosives"] = "cliff-explosives",
    },

    -- Overrides the icon layers used by a group's generated technology.
    alt_icon = {
      ["module"] = {
        icon = "__base__/graphics/technology/module.png",
        icon_size = 256,
        scale = 0.25,
        -- shift = { 0, -20 },
      },
    },

    -- Defines research-cost presets using TechnologyUnit fields (https://lua-api.factorio.com/latest/types/TechnologyUnit.html)
    unit = {
      ["my-unit"] = {
        count_formula = "1.5^L*1000",
        time = 60,
        ingredients = {
          { "automation-science-pack", 1 },
          { "logistic-science-pack", 1 },
        },
      },
    },

    -- Assigns presets by special product property: any, fluid, fuel, or science-pack.
    -- can also be "ignore" to generate no tech
    unit_from_special = {
      ["any"] = "my-unit",
      ["fluid"] = "chemical",
    },

    -- Assigns presets by recipe category.
    -- can also be "ignore" to generate no tech
    unit_from_category = {
      ["smelting"] = "my-unit",
    },

    -- Assigns presets by product group or merged-group name.
    -- can also be "ignore" to generate no tech
    unit_from_group = {
      ["uranium-chain"] = "my-unit",
    },

    -- Hides Space Age's overlapping productivity technologies when true.
    remove_space_age_tech = true,
  },
}})
```

## Overrides and removal

Configuration is loaded in this order:

1. Base configuration
2. Built-in compatibility
3. Compatibility supplied by other mods
4. User settings.

Because later values override earlier assignments, startup settings have the highest precedence.

Existing entries can be removed with the same markers accepted by the startup settings. This lets a compatibility layer undo an earlier assignment instead of replacing it.

For example, if built-in compatibility ignores the `barrel` group but another mod makes that group relevant to production calculations, that mod can remove the inherited entry so the group is processed normally.

```lua
data = {
  -- Remove key:string.
  ignore_group = {
    ["barrel"] = "--",
  },

  -- Remove key:multiple strings.
  merge_group = {
    ["uranium-chain"] = { "--" },
  },
}
```

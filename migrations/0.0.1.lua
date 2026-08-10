if settings.startup["bbprod-remove-tech"].value then
  local technology_migrations = {
    ["steel-plate-productivity"] = "bbprod-steel-plate-productivity",
    ["low-density-structure-productivity"] = "bbprod-low-density-structure-productivity",
    ["processing-unit-productivity"] = "bbprod-processing-unit-productivity",
    ["plastic-bar-productivity"] = "bbprod-plastic-bar-productivity",
    ["rocket-fuel-productivity"] = "bbprod-rocket-fuel-productivity",
    ["rocket-part-productivity"] = "bbprod-rocket-part-productivity",
  }

  for _, force in pairs(game.forces) do
    for old_name, new_name in pairs(technology_migrations) do
      local old_technology = force.technologies[old_name]
      local new_technology = force.technologies[new_name]

      if old_technology and new_technology then
        local old_level = old_technology.level
        local old_researched = old_technology.researched
        local old_progress = old_technology.saved_progress

        old_technology.saved_progress = 0
        old_technology.researched = false
        old_technology.level = 1
        old_technology.enabled = false

        local migrated_level = math.min(old_level, 30)
        if migrated_level > new_technology.level then
          new_technology.level = migrated_level
        end

        if old_researched or old_level > 30 then
          new_technology.researched = true
        elseif old_progress > new_technology.saved_progress then
          new_technology.saved_progress = old_progress
        end
      end
    end

    force.reset_technology_effects()
  end
end

if script.active_mods["ExpandedProductivityResearch"] then
  local merged_products = {
    ["uranium-235"] = "uranium-chain",
    ["uranium-238"] = "uranium-chain",
    ["uranium-fuel-cell"] = "uranium-chain",
    ["thruster-fuel"] = "thruster-fluid",
    ["thruster-oxidizer"] = "thruster-fluid",
    ["tungsten-plate"] = "tungsten-chain",
    ["tungsten-carbide"] = "tungsten-chain",
    ["holmium-plate"] = "holmium-chain",
    ["holmium-solution"] = "holmium-chain",
    ["tree-seed"] = "seed-processing",
    ["yumako-seed"] = "seed-processing",
    ["jellynut-seed"] = "seed-processing",
    ["lithium-plate"] = "lithium-chain",
    ["lithium"] = "lithium-chain",
  }

  for _, force in pairs(game.forces) do
    local migrated = {}

    for technology_name, technology in pairs(force.technologies) do
      local product_name, initial_level =
        technology_name:match("^epr_(.+)%-productivity%-(%d+)$")

      if product_name then
        local group_name = merged_products[product_name] or product_name
        local target_name = "bbprod-"..group_name.."-productivity"
        local target = force.technologies[target_name]

        if target then
          local next_level = technology.level
          if technology.researched then
            next_level = next_level + 1
          end

          local state = migrated[target_name]
          if not state then
            state = {
              level = target.level,
              progress = target.saved_progress,
            }
            migrated[target_name] = state
          end

          if next_level > state.level then
            state.level = next_level
            state.progress = technology.researched and 0 or technology.saved_progress
          elseif next_level == state.level and technology.saved_progress > state.progress then
            state.progress = technology.saved_progress
          end

          technology.saved_progress = 0
          technology.researched = false
          technology.level = tonumber(initial_level)
          technology.enabled = false
        end
      end
    end

    for target_name, state in pairs(migrated) do
      local target = force.technologies[target_name]
      local target_level = math.min(state.level, 30)

      if target_level > target.level then
        target.level = target_level
      end

      if state.level > 30 then
        target.researched = true
      elseif state.progress > target.saved_progress then
        target.saved_progress = state.progress
      end
    end

    force.reset_technology_effects()
  end
end

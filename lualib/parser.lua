local parser = {}

function parser.scsv(str, setting)
    str = str:gsub("%s+", "")
    local values = {}
    for v in str:gmatch("[^;]+") do
        assert(v ~= "", "bbprod: Invalid definition: "..str)
        values[#values + 1] = v
        table.insert(setting, v)
    end
    return values
end

function parser.key_csv(str, setting)
    str = str:gsub("%s+", "")
    local r = {}
    for def in str:gmatch("[^;]+") do
        local k, csv = def:match("^([%w_-]+)=(.+)$")
        assert(k ~= "", "bbprod: Invalid definition: "..def)
        assert(k, "bbprod: Invalid definition: "..def)
        local values = {}
        for v in csv:gmatch("[^,]+") do
            values[#values + 1] = v
        end
        r[k] = values
        setting[k] = values
    end
    return r
end

function parser.key_string(str, setting)
  str = str:gsub("%s+", "")
  local r = {}
  for def in str:gmatch("[^;]+") do
      local k, v = def:match("^([%w_-]+)=([%w_-]+)$")
      assert(k and v, "bbprod: Invalid definition: "..def)
      r[k] = v
      setting[k] = v
  end
  return r
end

function parser.alt_main_result(str, setting)
  str = str:gsub("%s+", "")
  local r = {}
  for def in str:gmatch("[^;]+") do
      local group_name, body = def:match("^([%w_-]+)=(.+)$")
      assert(group_name, "bbprod: Invalid definition: "..def)
      local result_type, result_name = body:match("^([^,]+),([^,]+)$")
      assert(result_type and result_name,
          "bbprod: Invalid alternative main result for group '"..group_name.."'")
      local result = {
          type = result_type,
          name = result_name,
          amount = 1,
      }
      r[group_name] = result
      setting[group_name] = result
  end
  return r
end

function parser.unit(str, setting)
  str = str:gsub("%s+", "")
  local r = {}
  for def in str:gmatch("[^;]+") do
      local unit_name, body = def:match("^([%w_-]+)=(.+)$")
      assert(unit_name, "bbprod: Invalid definition: "..def)
      local formula, time, ingredients = body:match("^([^,]+),([^,]+),(.+)$")
      assert(formula and time and ingredients,
          "bbprod: Invalid definition for unit '"..unit_name.."'")
      local unit = {
          count_formula = formula,
          time = assert(tonumber(time), "bbprod: Invalid time for unit '"..unit_name.."'"),
          ingredients = {},
      }
      for ingredient in ingredients:gmatch("[^+]+") do
          unit.ingredients[#unit.ingredients + 1] = { ingredient, 1 }
      end
      r[unit_name] = unit
      setting[unit_name] = unit
    end
  return r
end

return parser

local api = require("api")
local parse = {}

--- Usage:
--- ```lua
--- parse("value1;value2")
--- > { "value1" = true, "value2" = true }
--- ```
function parse.sc_string(str)
  str = str:gsub("%s+", "")
  local r = {}
  for inner_sc in str:gmatch("[^;]+") do
    local v = inner_sc:match("^([%w_-]+)$")
    if api.validate("Invalid definition: "..inner_sc, v)
    then r[v] = true end
  end
  return r
end

--- Usage:
--- ```lua
--- parse("key1=value1;key2=value2")
--- > { ["key1"] = "value1", ["key2"] = "value2" }
--- ```
parse.sc_key_string = function (str)
  str = str:gsub("%s+", "")
  local r = {}
  for inner_sc in str:gmatch("[^;]+") do
    local k, v = inner_sc:match("^([%w_-]+)=([%w_-]+)$")
    if api.validate("Invalid definition: "..inner_sc, k and v)
    then r[k] = v end
  end
  return r
end


--- Usage:
--- ```lua
--- parse("key1=a,b,c;key2=d")
--- > { ["key1"] = { "a", "b", "c" }, ["key2"] = { "d" } }
--- ```
parse.sc_key_strings = function (str)
  str = str:gsub("%s+", "")
  local r = {}
  for inner_sc in str:gmatch("[^;]+") do
    local k, csv = inner_sc:match("^([%w_-]+)=([%w_,-]+)$")
    if api.validate("Invalid definition: "..inner_sc,
      k and csv:sub(1, 1) ~= "," and csv:sub(-1) ~= "," and not csv:find(",,", 1, true))
    then
      local values = {}
      for v in csv:gmatch("[^,]+") do values[#values + 1] = v end
      r[k] = values
    end
  end
  return r
end

--- Usage:
--- ```lua
--- parse("unit1=1.5^L*1000,60,ingredient1+ingredient2")
--- > { ["unit1"] = { count_formula = "1.5^L*1000", time = 60,
--- >   ingredients = { { "ingredient1", 1 }, { "ingredient2", 1 } } } }
--- ```
function parse.sc_unit(str)
  str = str:gsub("%s+", "")
  local r = {}
  for def in str:gmatch("[^;]+") do
    local k, formula, time, ingredients =
      def:match("^([%w_-]+)=([^,]+),([^,]+),([%w_+-]+)$")
    time = tonumber(time)
    if api.validate("Invalid technology unit: "..def,
      not not (k
      and time
      and ingredients:sub(1, 1) ~= "+" 
      and ingredients:sub(-1) ~= "+" 
      and not ingredients:find("++", 1, true)))
    then
      local ingredient_list = {}
      local unit = {
        count_formula = formula,
        time = time,
        ingredients = ingredient_list,
      }
      for ingredient in ingredients:gmatch("[^+]+") do
        ingredient_list[#ingredient_list + 1] = { ingredient, 1 }
      end
      r[k] = unit
    end
  end
  return r
end

return parse

PkmnDip.utils = {}

function PkmnDip.utils.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function PkmnDip.utils.filter(list, func)
  local new_list = {}
  for _, v in pairs(list) do
    if func(v) then
      new_list[#new_list + 1] = v
    end
  end
  return new_list
end

function PkmnDip.utils.for_each(list, func)
  for _, v in pairs(list) do
    func(v)
  end
end

function PkmnDip.utils.copy_list(list)
  return PkmnDip.utils.map_list(list, PkmnDip.utils.id)
end

function PkmnDip.utils.map_list(list, func)
  local new_list = {}
  for _, v in pairs(list) do
    new_list[#new_list + 1] = func(v)
  end
  return new_list
end

function PkmnDip.utils.id(a)
  return a
end

function PkmnDip.utils.append(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end

-- Talisman shorthand
to_number = to_number or function(x) return x end

-- (Thank you TMJ, I also wonder why these functions dont exist.)
function math.clamp(num, min, max)
    max = max or math.huge
    min = min or -math.huge
    assert(min <= max)
    return math.min(math.max(num, min), max)
end
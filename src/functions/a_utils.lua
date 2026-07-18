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

function PkmnDip.utils.any(list, func)
  -- if we didn't care about performance, we'd do it like this:
  -- return #PkmnDip.utils.filter(list, func) > 0
  for _, v in pairs(list) do
    if func(v) then
      return true
    end
  end
  return false
end

function PkmnDip.utils.all(list, func)
  -- if we didn't care about performance, we'd do it like this:
  -- return #PkmnDip.utils.filter(list, func) == #list
  for _, v in pairs(list) do
    if not func(v) then
      return false
    end
  end
  return true
end

function PkmnDip.utils.count_unique(list, optional_map)
  local seen, count = {}, 0
  for _, v in pairs(list) do
    if optional_map then v = optional_map(v) end
    if v and not seen[v] then
      seen[v] = true
      count = count + 1
    end
  end
  return count
end

function PkmnDip.utils.append(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end

function PkmnDip.utils.compare(t1, t2)
  if #t1 ~= #t2 then return false end
  for i = 1, #t1 do
    if t1[i] ~= t2[i] then return false end
  end
  return true
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
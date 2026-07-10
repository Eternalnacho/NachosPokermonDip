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

-- Stealing this one from Emma holy moly that's useful
function PkmnDip.defer(func, delay)
  G.E_MANAGER:add_event(Event({
    trigger = delay and 'after',
    delay = delay,
    func = function()
      func()
      return true
    end
  }))
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

-- metafunctions
function PkmnDip.utils.hook_before_function(table, funcname, hook)
  if not table[funcname] then
    table[funcname] = hook
  else
    local orig = table[funcname]
    table[funcname] = function(...)
      return hook(...)
          or orig(...)
    end
  end
end

function PkmnDip.utils.hook_after_function(table, funcname, hook, always_run)
  if not table[funcname] then
    table[funcname] = hook
  else
    local orig = table[funcname]
    if always_run then
      table[funcname] = function(...)
        local ret = orig(...)
        local hook_ret = hook(...)
        return ret or hook_ret
      end
    else
      table[funcname] = function(...)
        return orig(...)
            or hook(...)
      end
    end
  end
end

function PkmnDip.utils.hook_around_function(table, funcname, hook)
  if not table[funcname] then
    table[funcname] = function(...)
      return hook(function() end, ...)
    end
  else
    local orig = table[funcname]
    table[funcname] = function(...) return hook(orig, ...) end
  end
end
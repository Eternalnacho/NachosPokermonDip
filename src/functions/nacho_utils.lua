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
  new_list = {}
  for _, v in pairs(list) do
    if func(v) then
      new_list[#new_list + 1] = v
    end
  end
  return new_list
end

function PkmnDip.utils.copy_list(list)
  return PkmnDip.utils.map_list(list, PkmnDip.utils.id)
end

function PkmnDip.utils.map_list(list, func)
  new_list = {}
  for _, v in pairs(list) do
    new_list[#new_list + 1] = func(v)
  end
  return new_list
end

function PkmnDip.utils.id(a)
  return a
end
-- Defining Table.contains
function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

-- Stealing this from Sonfive
function get_base_evo_name(card)
  -- Get the name of the base form if you can
  local fam = poke_get_family_list(card.name)
  -- Default is your own name, you may have no family T.T
  local base_evo_name = card.name
  if #fam > 0 then
      -- Found a base evo, use it's name
      base_evo_name = fam[1]
  end
  return base_evo_name
end

-- modifying this function for *two* different config settings
SMODS.collection_pool = function(_base_pool)
  local pool = {}
  local inserts = {}
  if type(_base_pool) ~= 'table' then return pool end
  local is_array = _base_pool[1]
  local ipairs = is_array and ipairs or pairs
  for _, v in ipairs(_base_pool) do
    local moved = false
    if (not G.ACTIVE_MOD_UI or v.mod == G.ACTIVE_MOD_UI) and not v.no_collection then
      if nacho_config.orderJokers then
        for x, y in pairs(PkmnDip.dex_order_groups) do
          if table.contains(y, v.name) then
            inserts[#inserts+1] = v
            moved = true
          end
        end
      end
      local empty_vanilla = v.set == 'Joker' and not v.stage and nacho_config.pokemon_only
      if not moved and not empty_vanilla then pool[#pool+1] = v end
    end
  end

  if nacho_config.orderJokers then
    table.sort(inserts, function(a, b) return PkmnDip.get_dex_number(a.name) < PkmnDip.get_dex_number(b.name) end)
    for k, v in pairs(inserts) do
      for x, y in pairs(PkmnDip.dex_order_groups) do
        if table.contains(y, v.name) then
          local next_index = PkmnDip.dex_order[PkmnDip.find_next_dex_number(v.name)]
          if type(next_index) == "table" then next_index = next_index[1] end
          if not table.contains(pool, v) then
            table.insert(pool, next_index and PkmnDip.find_pool_index(pool, 'j_poke_'..next_index) or #pool + 1, v)
          end
        end
      end
    end
  end

  if not is_array then table.sort(pool, function(a,b) return a.order < b.order end) end
  return pool
end

PkmnDip.find_pool_index = function(pool, key)
    for k, v in pairs(pool) do
      if v.key == key then return k end
    end
end

PkmnDip.get_dex_number = function(name)
  for i, pokemon in ipairs(PkmnDip.dex_order) do
    if type(pokemon) == 'table' then
      for x, y in ipairs(pokemon) do
        if name == y then return i + (x - 1)/10 end
      end
    elseif type(pokemon) == "string" and name == pokemon then return i end
  end
  return #PkmnDip.dex_order + 1
end

PkmnDip.find_next_dex_number = function(name)
  local dexNo = PkmnDip.get_dex_number(name)
  local group_list
  for k, v in pairs(PkmnDip.dex_order_groups) do
    if table.contains(v, name) then group_list = v break end
  end
  for i, pokemon in ipairs(PkmnDip.dex_order) do
    if type(pokemon) == 'table' then
      for _, mon in ipairs(pokemon) do
        if i > dexNo and not table.contains(group_list, mon) and G.P_CENTERS['j_poke_'..mon] then
          --for k, v in pairs(poke_get_family_list(mon)) do if string.find(name, v) then goto continue end end
          return i
        end
      end
    elseif i > dexNo and not table.contains(group_list, pokemon) and G.P_CENTERS['j_poke_'..pokemon] then
      --for k, v in pairs(poke_get_family_list(mon)) do if string.find(name, v) then goto continue end end
      return i
    elseif pokemon == "missingno" then return i end
    --::continue::
  end
end


-- Wide Gallery Settings
local joker_collection_box = create_UIBox_your_collection_jokers
if nacho_config.gallery_width then
  create_UIBox_your_collection_jokers = function()
    local w = nacho_config.gallery_width * 10 % 10 < 5 and math.floor(nacho_config.gallery_width) or math.ceil(nacho_config.gallery_width)
    return SMODS.card_collection_UIBox(G.P_CENTER_POOLS.Joker, {w,w,w}, {
        no_materialize = true, 
        modify_card = function(card, center) card.sticker = get_joker_win_sticker(center) end,
        h_mod = 0.95,
    })
  end
else
  create_UIBox_your_collection_jokers = joker_collection_box
end

-- Adding an "in collection" state
local old_FUNCS_your_collection = G.FUNCS.your_collection
function G.FUNCS.your_collection(...)
    G.STATES.in_collection = true
    return old_FUNCS_your_collection(...)
end

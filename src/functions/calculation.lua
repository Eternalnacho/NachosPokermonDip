PkmnDip.calc = {}

--#region [[ get_rank ]]

---@alias rank_type
---| 'id' # use rank id
---| 'nominal' # use rank nominal value
---@param cards Card[]
---@param get_ranks_by rank_type?
-- Get the two parts of a Full House, return two lists of cards or their ranks
PkmnDip.calc.get_full_house = function(cards, get_ranks_by)
  local part_major = get_X_same(3, cards, true)[1]
  local not_in_major = function(card) return card:get_id() ~= part_major[1]:get_id() end
  local part_minor = get_X_same(2, PkmnDip.utils.filter(cards, not_in_major), true)[1]

  if get_ranks_by == 'id' then return part_major[1]:get_id(), part_minor[1]:get_id() end
  if get_ranks_by == 'nominal' then return part_major[1].base.nominal, part_minor[1].base.nominal end
  return part_major, part_minor
end

-- Get most common rank(s) in a list of cards
PkmnDip.calc.get_common_ranks = function(cards)
  local is_rank = function(card, id) return card:get_id() == id end
  local get_count = function(rank) return #PkmnDip.utils.filter(cards, function(c) return is_rank(c, rank.id) end) end
  local ranks = PkmnDip.utils.map_list(SMODS.Ranks, function(rank) return { rank = rank, count = get_count(rank) } end)
  table.sort(ranks, function(a, b) return a.count > b.count end)
  local ret, tally = {}, ranks[1].count
  for _, v in ipairs(ranks) do
    if v.count == tally then table.insert(ret, v.rank)
    else break end
  end
  return ret
end

-- Create tooltip for common ranks (Oranguru)
PkmnDip.calc.common_ranks_tooltip = function()
  if not (G.playing_cards and G.STAGE == G.STAGES.RUN) then return end
  local rank_keys = {}
  local ranks = PkmnDip.calc.get_common_ranks(G.playing_cards)
  -- sort in descending order if multiple
  if #ranks > 1 then table.sort(ranks, function(a, b) return a.id > b.id end) end
  -- get card key for each rank because it's a single character
  for i = 1, #ranks do
    rank_keys[i] = #ranks > 3 and ranks[i].card_key or ranks[i].key
    if rank_keys[i] == 'T' then rank_keys[i] = '10' end
  end
  -- Organize into even lists (max 3)
  local rank_lists = {}
  local rows = math.min(3, math.ceil(#rank_keys / 4))
  if rows == 1 then
    rank_lists[1] = table.concat(rank_keys, ", ")
  else
    local mod = math.ceil(#rank_keys / rows)
    local st_i = function(x) return 1 + (x - 1) * mod end
    local ed_i = function(x) return x * mod end
    for i = 1, rows do
      rank_lists[i] = table.concat(rank_keys, ", ", st_i(i), math.min(#rank_keys, ed_i(i)))
    end
  end
  local text = PkmnDip.utils.map_list(rank_lists, function(l) return '{C:attention}'..l..'{}' end)
  local text_parsed = PkmnDip.utils.map_list(text, loc_parse_string)
  G.localization.descriptions.Other['pkmndip_rank_lists'].text = text
  G.localization.descriptions.Other['pkmndip_rank_lists'].text_parsed = text_parsed
  return {
    set = 'Other',
    key = 'pkmndip_rank_lists'
  }
end

--#endregion [[ get_rank ]]


--#region [[ get_suit ]]

PkmnDip.calc.get_suit = function(card)
  if SMODS.has_any_suit(card) then return
  else return card.base.suit end
end

PkmnDip.calc.get_flush_suit = function(cards)
  local flush = get_flush(cards)[1]
  if not flush then return end
  if PkmnDip.utils.all(flush, PkmnDip.con.is_wild) then return 'Any' end

  local suit
  PkmnDip.utils.for_each(flush, function(c)
    if PkmnDip.calc.get_suit(c) and not suit then
      suit = PkmnDip.calc.get_suit(c)
    end
  end)
  return suit
end

--#endregion [[ get_suit ]]


--#region [[ get_mult ]]

-- Get the amount of mult a card *has given*
PkmnDip.calc.total_mult = function(card)
  local total_mult = (card.ability.perma_mult or 0)
  if card.config.center ~= G.P_CENTERS.m_lucky or card.lucky_mult_trigger then
    total_mult = total_mult + card.ability.mult
  end
  total_mult = total_mult + (card.edition and card.edition.mult or 0)
  return total_mult
end

-- Get the amount of mult a card *would give*
PkmnDip.calc.get_mult = function(card)
  local total_mult = 0
  total_mult = total_mult + card:get_chip_mult()
  total_mult = total_mult + card:get_chip_h_mult()
  return total_mult
end

--#endregion [[ get_mult ]]


--#region [[ get_key ]]

function Card:poke_get_prefix()
  return self.config.center.poke_custom_prefix or 'poke'
end

PkmnDip.calc.get_key = function(card, name)
  return 'j_'..card:poke_get_prefix().."_"..(name or card.config.center.name)
end

--#endregion [[ get_key ]]


--#region [[ daycare_compatible ]]

PkmnDip.calc.daycare_compatible = function(card)
  local lowest_key = PkmnDip.calc.get_key(card, pokermon.get_lowest_evo(card))
  local incompatible = { "Other", "Baby", "Legendary" }
  return card.config.center.stage
      and not PkmnDip.utils.contains(incompatible, card.config.center.stage)
      and G.P_CENTERS[lowest_key].stage ~= "Legendary"
end

--#endregion [[ daycare_compatible ]]
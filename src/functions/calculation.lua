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

  if get_ranks_by == 'nominal' then return part_major[1]:get_id(), part_minor[1]:get_id() end
  if get_ranks_by == 'nominal' then return part_major[1].base.nominal, part_minor[1].base.nominal end
  return part_major, part_minor
end

PkmnDip.calc.get_depleted = function()
  local depleted = {}
  for _, rank in pairs(SMODS.Ranks) do
    if rank.in_pool and not rank:in_pool({}) then goto continue end
    local is_rank = function(card)
      return card:get_id() == rank.id
    end
    if pokermon.get_depleted(is_rank) then
      depleted[#depleted+1] = rank.key
    end
    ::continue::
  end
  print(depleted)
  return depleted
end

PkmnDip.calc.count_ranks = function(cards)
  if not cards then cards = G.playing_cards end
  -- Count suits
  local ranks = {}
  for _, pcard in ipairs(G.playing_cards) do
    if not SMODS.has_no_rank(pcard) then ranks[pcard.base.value] = (ranks[pcard.base.value] or 0) + 1 end
  end
  local ranks_by_count = {}
  for rank, count in pairs(ranks) do
    table.insert(ranks_by_count, {rank = rank, count = count})
  end
  table.sort(ranks_by_count, function(a, b) return a.count > b.count end)
  return ranks_by_count
end

-- Get most common rank(s) in a list of cards
PkmnDip.calc.get_common_ranks = function(cards)
  local ranks_by_count = PkmnDip.calc.count_ranks(cards)
  local common_ranks = { SMODS.Ranks[ranks_by_count[1].rank] }
  for i = 2, #ranks_by_count do
    if ranks_by_count[i].count == ranks_by_count[1].count then
      table.insert(common_ranks, SMODS.Ranks[ranks_by_count[i].rank])
    end
  end
  return common_ranks
end

-- Create tooltip for common ranks (Oranguru)
PkmnDip.calc.common_ranks_tooltip = function()
  if not (G.playing_cards and G.STAGE == G.STAGES.RUN) then return end
  local ranks = PkmnDip.calc.get_common_ranks()
  if #ranks > 1 then
    table.sort(ranks, function(a, b) return a.id > b.id end)
  end
  ranks = PkmnDip.utils.map_list(ranks, function(r)
    return #ranks > 3 and r.shorthand or r.key
  end)
  -- Organize into even lists (max 3)
  local rows = math.min(3, math.ceil(#ranks / 4))
  local rank_lists = {}
  local start_index = function(x) return 1 + (x - 1) * math.ceil(#ranks / rows) end
  local end_index = function(x) return x * math.ceil(#ranks / rows) end
  for i = 1, rows do
    rank_lists[i] = table.concat(ranks, ", ", 
      rows > 1 and start_index(i) or nil,
      rows > 1 and math.min(#ranks, end_index(i)) or nil
    )
  end
  local text = PkmnDip.utils.map_list(rank_lists, function(l) return '{C:attention}'..l..'{}' end)
  local text_parsed = PkmnDip.utils.map_list(text, loc_parse_string)
  G.localization.descriptions.Other['pkmndip_rank_lists'].text = text
  G.localization.descriptions.Other['pkmndip_rank_lists'].text_parsed = text_parsed
  return { set = 'Other', key = 'pkmndip_rank_lists' }
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
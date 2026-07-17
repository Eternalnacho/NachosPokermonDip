PkmnDip.calc = {}

--#region [[ get_common_ranks ]]

-- Get most common rank(s) in a list of cards
PkmnDip.calc.get_common_ranks = function(cards)
  local is_rank = function(card, id) return card:get_id() == id and not SMODS.has_no_rank(card) end
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
  if not G.playing_cards and G.STAGE == G.STAGES.RUN then return end
  local ranks = {}
  local r = PkmnDip.calc.get_common_ranks(G.playing_cards)
  -- sort in descending order if multiple
  if #r > 1 then table.sort(r, function(a, b) return a.id > b.id end) end
  -- get card key for each rank because it's a single character
  for i = 1, #r do
    ranks[i] = #r > 3 and r[i].card_key or r[i].key
    if ranks[i] == 'T' then ranks[i] = '10' end
  end
  -- Organize into even lists (max 3)
  local rank_lists = {}
  local rows = math.min(3, math.ceil(#ranks / 4))
  if rows == 1 then
    rank_lists[1] = table.concat(ranks, ", ")
  else
    local mod = math.ceil(#ranks / rows)
    for i = 1, rows do
      rank_lists[i] = table.concat(ranks, ", ", 1 + (i - 1) * mod, math.min(#ranks, i * mod))
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

--#endregion [[ get_common_ranks ]]


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
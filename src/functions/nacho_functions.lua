-- Describe all the logic for debuffing or undebuffing
-- return values: true, false, or 'prevent_debuff'
SMODS.current_mod.set_debuff = function(card)
  -- prevent debuffs
  if card.ability.name == "mega_gallade" then return 'prevent_debuff' end
  if card:get_id() == 9 and next(find_joker("mega_altaria")) then return 'prevent_debuff' end

  return false
end

-- Deck Rank Evo conditions
pokermon.deck_rank_evo = function(self, card, context, forced_key, rank, percentage, flat)
  if pokermon.can_evolve(self, card, context, forced_key) then
    local count = 0
    for k, v in pairs(G.playing_cards) do
      if v.base.nominal >= rank then count = count + 1 end
    end
    if percentage and (count/#G.playing_cards >= percentage) then
      return {
        message = pokermon.evolve(card, forced_key)
      }
    elseif flat and (count >= flat) then
      return {
        message = pokermon.evolve(card, forced_key)
      }
    end
  end
end

-- Edition Evo conditions
pokermon.edition_evo = function(self, card, context, forced_key, edition, percentage, flat)
  if pokermon.can_evolve(self, card, context, forced_key) then
    local count = 0
    for k, v in pairs(G.playing_cards) do
      if v.edition and v.edition[edition] then count = count + 1 end
    end
    if percentage and (count/#G.playing_cards >= percentage) then
      return {
        message = pokermon.evolve(card, forced_key)
      }
    elseif flat and (count >= flat) then
      return {
        message = pokermon.evolve(card, forced_key)
      }
    end
  end
end

-- Get card's total mult (parallels pokermon.total_chips)
pokermon.total_mult = pokermon.total_mult or function(card)
  local total_mult = (card.ability.perma_mult or 0)
  if card.config.center ~= G.P_CENTERS.m_lucky then
    total_mult = total_mult + card.ability.mult
  end
  if card.edition then
    total_mult = total_mult + (card.edition.mult or 0)
  end
  return total_mult
end

PkmnDip.copy_playing_card = function(card, modify, to_hand)
  PkmnDip.defer(function()
    local copy = copy_card(card, nil, nil, G.playing_card)
    table.insert(G.playing_cards, copy)
    copy:add_to_deck()
    G.deck:emplace(copy)
    
    if modify then
      pokermon.convert_cards(copy, modify, true, true)
    end
    if to_hand then
      draw_card(G.deck, G.hand, nil, nil, nil, copy)
    end
    playing_card_joker_effects({copy})
  end)
end

-- calculate most played hand
PkmnDip.calc_most_played_hand = function()
  local hands, _tally = {}, 0
  for _, v in ipairs(G.handlist) do
    if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
      hands = {v}
      _tally = G.GAME.hands[v].played
    elseif G.GAME.hands[v].visible and G.GAME.hands[v].played == _tally then
      table.insert(hands, v)
    end
  end
  return #hands == 1 and hands[1] or pseudorandom_element(hands, 'handcalc')
end

-- Get most common rank(s) in a list of cards
PkmnDip.get_common_ranks = function(cards)
  if not cards then cards = G.playing_cards end
  local _ranks, _tally = {}, 0
  for _, r in pairs(SMODS.Ranks) do
    local count = #PkmnDip.utils.filter(cards, function(card) return card:get_id() == r.id and not SMODS.has_no_rank(card) end)
    if count > _tally then
      _ranks = {r}
      _tally = count
    elseif count == _tally then
      table.insert(_ranks, r)
    end
  end
  return _ranks
end

-- Create tooltip for common ranks (Oranguru)
PkmnDip.common_ranks_tooltip = function(self, info_queue)
  local ranks = {}
  if G.playing_cards and G.STAGE == G.STAGES.RUN then
    local r = PkmnDip.get_common_ranks(G.playing_cards)
    -- sort in descending order if multiple
    if #r > 1 then
      table.sort(r, function(a, b) return a.id > b.id end)
    end
    -- get card key for each rank because it's a single character
    for i = 1, #r do
      ranks[i] = #r > 3 and r[i].card_key or r[i].key
      if ranks[i] == 'T' then ranks[i] = '10' end
    end
  -- return early if there's no cards to get common ranks from
  else return end
  -- Organize into even lists (max 3)
  local rank_lists = {}
  local rows = math.min(3, math.ceil(#ranks / 4))
  if rows == 1 then
    rank_lists[1] = table.concat(ranks, ", ")
  else
    for i = 1, rows do
      rank_lists[i] = table.concat(ranks, ", ", 1 + (i - 1) * math.ceil(#ranks / rows), math.min(#ranks, i * math.ceil(#ranks / rows)))
    end
  end
  local key = "rank_lists_" .. #rank_lists     -- dynamic key
  info_queue[#info_queue + 1] = { set = 'Other', key = key, vars = rank_lists }
end

PkmnDip.keep_values = function(card)
  local names_to_keep = {"targets", "rank", "id", "cards_scored", "cards_drawn", "energy_count", "c_energy_count", "e_limit_up", "form"}
  if pokermon.type_sticker_applied(card) then
    table.insert(names_to_keep, "ptype")
  end
  local values_to_keep = pokermon.copy_scaled_values(card)
  if type(card.ability.extra) == "table" then
    for _, k in pairs(names_to_keep) do
      values_to_keep[k] = card.ability.extra[k]
    end
  end
  if card.config.center.poke_custom_values_to_keep then
    for _, v in pairs(card.config.center.poke_custom_values_to_keep) do
      values_to_keep[v] = card.ability.extra[v]
    end
  end
  return values_to_keep
end

PkmnDip.get_kept_values = function(card, kept_vals)
  for k, v in pairs(kept_vals) do
    card.ability[k] = type(v) == 'table' and copy_table(v) or v
    if type(card.ability.extra) == "table" and (card.ability.extra[k] or k == "energy_count" or k == "c_energy_count" or k == "e_limit_up")
        and (type(card.ability.extra[k]) ~= "number" or (type(v) == "number" and v > card.ability.extra[k])) then
      card.ability.extra[k] = v
    end
  end
end

PkmnDip.get_lowest_hand_level = function()
  local lowest_level
  for _, v in pairs(G.GAME.hands) do
    local hand_level = (SMODS.Mods["Talisman"] or {}).can_load and (to_number(v.level)) or (v.level)
    if lowest_level then
      lowest_level = hand_level < lowest_level and hand_level or lowest_level
    else
      lowest_level = hand_level
    end
  end
  return lowest_level
end

function Card:poke_get_prefix()
  return self.config.center.poke_custom_prefix or 'poke'
end

PkmnDip.create_full_poke_key = function(card, name)
  return 'j_'..card:poke_get_prefix().."_"..(name or card.config.center.name)
end
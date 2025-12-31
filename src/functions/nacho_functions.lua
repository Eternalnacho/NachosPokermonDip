-- Describe all the logic for debuffing or undebuffing
-- return values: true, false, or 'prevent_debuff'
SMODS.current_mod.set_debuff = function(card)
  -- prevent debuffs
  if card.ability.name == "mega_gallade" then return 'prevent_debuff' end
  if card:get_id() == 9 and next(find_joker("altaria")) then return 'prevent_debuff' end

  return false
end


-- Deck Rank Evo conditions
deck_rank_evo = function(self, card, context, forced_key, rank, percentage, flat)
  if can_evolve(self, card, context, forced_key) then
    local count = 0
    for k, v in pairs(G.playing_cards) do
      if v.base.nominal >= rank then count = count + 1 end
    end
    if percentage and (count/#G.playing_cards >= percentage) then
      return {
        message = poke_evolve(card, forced_key)
      }
    elseif flat and (count >= flat) then
      return {
        message = poke_evolve(card, forced_key)
      }
    end
  end
end

-- Edition Evo conditions
edition_evo = function(self, card, context, forced_key, edition, percentage, flat)
  if can_evolve(self, card, context, forced_key) then
    local count = 0
    for k, v in pairs(G.playing_cards) do
      if v.edition and v.edition[edition] then count = count + 1 end
    end
    if percentage and (count/#G.playing_cards >= percentage) then
      return {
        message = poke_evolve(card, forced_key)
      }
    elseif flat and (count >= flat) then
      return {
        message = poke_evolve(card, forced_key)
      }
    end
  end
end

-- Get card's total mult (parallels poke_total_chips)
poke_total_mult = poke_total_mult or function(card)
  local total_mult = (card.ability.perma_mult or 0)
  if card.config.center ~= G.P_CENTERS.m_lucky then
    total_mult = total_mult + card.ability.mult
  end
  if card.edition then
    total_mult = total_mult + (card.edition.mult or 0)
  end
  return total_mult
end

-- calculate most played hand
calc_most_played_hand = function()
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
get_common_ranks = function(cards)
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
common_ranks_tooltip = function(self, info_queue)
  local ranks = {}
  if G.playing_cards and G.STAGE == G.STAGES.RUN then
    local r = get_common_ranks(G.playing_cards)
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


-- Calculate Boss Triggers (for Turtonator mostly but who knows)
calc_boss_trigger = function(context)
  if context.blind and context.blind.boss and not G.GAME.blind.nametracker then
    G.GAME.blind.nametracker = context.blind.name
  end

  if context.setting_blind and context.blind and context.blind.boss and not G.GAME.blind.disabled then
    local boss_name = context.blind.name
    -- These boss blinds trigger only at the start
    -- The Wall, The Water, The Manacle, The Needle, Amber Acorn, Violet Vessel
    if context.blind.mult ~= 2 then return true end
    if (boss_name == "The Water" or boss_name == "The Manacle" or boss_name == "Amber Acorn"
      or boss_name == "The Mirror" or boss_name == "bl_poke_white_executive") then
      return true
    end
  end

  if G.GAME.blind.nametracker then
    local boss_name = G.GAME.blind.nametracker
    -- The Window, The Head, The Club, The Goad, The Plant, The Pillar, The Flint, The Eye, The Mouth, The Psychic, The Arm, The Ox, Verdant Leaf
    if context.debuffed_hand or context.joker_main then
      if G.GAME.blind.triggered then
        G.GAME.blind.nametracker = nil
        return true
      end

    -- The House
    elseif context.first_hand_drawn and boss_name == "The House" then
      G.GAME.blind.nametracker = nil
      return true

    -- The Serpent
    elseif (context.press_play or context.pre_discard) and boss_name == "The Serpent" and #G.hand.highlighted > 3 then
      G.GAME.blind.serpentcheck = true

    -- Gray Godfather
    elseif context.pre_discard and boss_name == "bl_poke_gray_godfather" then
      return true

    -- The Hook, The Tooth, The Star, Crimson Heart, Cerulean Bell, Gray Godfather, Iridescent Hacker
    elseif context.press_play then
      local jokdebuff = poke_find_card(function(v) return v.debuff end)
      local forcedselection = false
      for k, v in pairs(G.hand.highlighted) do
        if v.ability.forced_selection or v.ability.pokermon_forced_selection then
          v.ability.pokermon_forced_selection = nil
          forcedselection = true
        end
      end
      if (boss_name == "The Hook" and (#G.hand.cards - #G.hand.highlighted) > 0)
        or boss_name == "The Tooth" or boss_name == "bl_poke_gray_godfather"
        or ((boss_name == "Crimson Heart" or boss_name == "bl_poke_star" or boss_name == "bl_poke_iridescent_hacker") and jokdebuff)
        or (boss_name == "Cerulean Bell" and forcedselection) then
        G.GAME.blind.nametracker = nil
        return true
      end

    -- The Serpent (cont.), The Wheel, The Mark, The Fish
    elseif context.hand_drawn then
      local facedown = false
      for _, v in pairs(context.hand_drawn) do
        if v.facing == 'back' then
          facedown = true
        end
      end
      if (boss_name == "The Serpent" and G.GAME.blind.serpentcheck)
        or ((boss_name == "The Wheel" or boss_name == "The Mark" or boss_name == "The Fish") and facedown) then
        -- first set the flag when hand is played or discarded, then
        -- only apply boss_trigger when the hand is drawn
        if G.GAME.blind.serpentcheck then G.GAME.blind.serpentcheck = nil end
        G.GAME.blind.nametracker = nil
        return true
      end

    -- End of round, AKA cleaning up the mess
    elseif context.end_of_round then
      G.GAME.blind.nametracker = nil
    end
  end
end
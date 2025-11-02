-- Describe all the logic for debuffing or undebuffing
-- return values: true, false, or 'prevent_debuff'
SMODS.current_mod.set_debuff = function(card)
  -- prevent debuffs
  if card.ability.name == "mega_gallade" then return 'prevent_debuff' end
  if card:get_id() == 9 and next(find_joker("altaria")) then return 'prevent_debuff' end

  return false
end

-- Defining Table.contains
function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end


-- Ripped straight from Ortalab
function Count_ranks()
  -- Count ranks
  local ranks = {}
  for _, pcard in ipairs(G.playing_cards) do
    if not SMODS.has_no_rank(pcard) then ranks[pcard.base.value] = (ranks[pcard.base.value] or 0) + 1 end
  end
  local ranks_by_count = {}
  for rank, count in pairs(ranks) do
    table.insert(ranks_by_count, { rank = rank, count = count })
  end
  table.sort(ranks_by_count, function(a, b) return a.count > b.count end)
  return ranks_by_count
end

-- calculate most played hand
calc_most_played_hand = function()
  local _hand, _tally = nil, 0
  for k, v in ipairs(G.handlist) do
    if G.GAME.hands[v].visible and G.GAME.hands[v].played >= _tally then
      _hand = v
      _tally = G.GAME.hands[v].played
    end
  end
  return _hand
end

-- Calculate Boss Triggers (for Turtonator mostly but who knows)
calc_boss_trigger = function(context)
  if context.blind and context.blind.boss and not G.GAME.blind.nametracker then
    G.GAME.blind.nametracker = context.blind.name
  end

  if context.setting_blind and context.blind and context.blind.boss then
    local boss_name = context.blind.name
    -- These boss blinds trigger only at the start
    -- The Wall, The Water, The Manacle, The Needle, Amber Acorn, Violet Vessel
    if (boss_name == "The Wall" or boss_name == "The Water" or boss_name == "The Manacle"
          or boss_name == "The Needle" or boss_name == "Amber Acorn" or boss_name == "Violet Vessel")
        and not G.GAME.blind.disabled then
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

      -- The Hook, The Tooth, Crimson Heart, Cerulean Bell, Chartreuse Chamber (cgoose)
    elseif context.press_play then
      local jokdebuff = false
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i].debuff then
          jokdebuff = true
          break
        end
      end
      local forcedselection = false
      for k, v in pairs(G.hand.highlighted) do
        if v.ability.forced_selection or v.ability.pokermon_forced_selection then
          v.ability.pokermon_forced_selection = nil
          forcedselection = true
        end
      end
      if (boss_name == "The Hook" and (#G.hand.cards - #G.hand.highlighted) > 0) or
          boss_name == "The Tooth" or
          ((boss_name == "Crimson Heart" or boss_name == "bl_poke_cgoose") and jokdebuff) or
          (boss_name == "Cerulean Bell" and forcedselection) then
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
      if (boss_name == "The Serpent" and G.GAME.blind.serpentcheck) or
          ((boss_name == "The Wheel" or boss_name == "The Mark" or boss_name == "The Fish") and facedown) then
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

-- Create tooltip for common ranks (Oranguru)
common_ranks_tooltip = function(self, info_queue)
  local _ranks = {}
  local _tally = 0
  if G.playing_cards then
    for x, y in pairs(SMODS.Ranks) do
      local count = 0
      for k, v in pairs(G.playing_cards) do
        if v:get_id() == y.id and not SMODS.has_no_rank(v) then count = count + 1 end
      end
      if count > _tally then
        if #_ranks > 0 then for i = 1, #_ranks do table.remove(_ranks) end end
        table.insert(_ranks, y.key)
        _tally = count
      elseif count == _tally then
        table.insert(_ranks, y.key)
      end
    end
  end
  if #_ranks > 1 then
    local sort_rank = function(a, b)
      return SMODS.Ranks[a].id > SMODS.Ranks[b].id
    end
    table.sort(_ranks, sort_rank)
  end
  -- get card key for each rank because it's a single character
  if #_ranks > 3 then
    for i = 1, #_ranks do
      _ranks[i] = SMODS.Ranks[_ranks[i]].card_key
      if _ranks[i] == 'T' then _ranks[i] = '10' end
    end
  end

  -- Organize into even lists
  local rank_lists = {}
  if math.ceil(#_ranks / 4) == 1 then
    rank_lists[1] = table.concat(_ranks, ", ")
  elseif math.ceil(#_ranks / 4) == 2 then
    rank_lists[1] = table.concat(_ranks, ", ", 1, math.ceil(#_ranks / 2))
    rank_lists[2] = table.concat(_ranks, ", ", math.ceil(#_ranks / 2) + 1, #_ranks)
  elseif math.ceil(#_ranks / 4) >= 3 then
    rank_lists[1] = table.concat(_ranks, ", ", 1, math.ceil(#_ranks / 3))
    rank_lists[2] = table.concat(_ranks, ", ", math.ceil(#_ranks / 3) + 1, math.ceil(#_ranks * 2 / 3))
    rank_lists[3] = table.concat(_ranks, ", ", math.ceil(#_ranks * 2 / 3) + 1, #_ranks)
  end

  -- Only show tooltip if there is at least one rank
  if #rank_lists > 0 then
    local key = "rank_lists_" .. #rank_lists     -- dynamic key
    info_queue[#info_queue + 1] = { set = 'Other', key = key, vars = rank_lists }
  end
end
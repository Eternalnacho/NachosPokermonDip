local score_metal_jokers = function(card, context)
  -- Create a temporary steel card and set it's position to the relevant joker
  local temp_steel = SMODS.create_card({set = 'Enhanced', enhancement = 'm_steel'})
  temp_steel:hard_set_T(card.T.x, card.T.y, card.T.w, card.T.h)
  -- Sets the steel card's major to the joker for click + drag reasons
  G.E_MANAGER:add_event(Event({
    func = function()
      temp_steel:set_role({major = card, role_type = 'Glued'})
      return true
    end
  }))
  -- sets the scoring animation bit onto the target joker
  temp_steel.juice_up = function(self, ...) card:juice_up(...) end
  -- Temporarily make steel cards rankless + suitless so associated held triggers on jokers don't happen
  G.P_CENTERS['m_steel'].no_rank = true
  G.P_CENTERS['m_steel'].no_suit = true
  -- Create fake context to trick Balatro into thinking we're calculating held steel cards
  local temp_context = {
    cardarea = G.hand,
    individual = true,
    main_scoring = true,
    other_card = temp_steel,
    full_hand = context.full_hand,
    poker_hands = context.poker_hands,
    scoring_hand = context.scoring_hand,
    scoring_name = context.scoring_name,
    retrigger_joker = context.retrigger_joker,
    scoring_metal_for = card
  }
  -- The scoring code I had before wound up being a 1-for-1 of SMODS.score_card
  SMODS.score_card(temp_steel, temp_context)
  -- Reset the no_rank and no_suit properties so steel cards score as normal
  G.P_CENTERS['m_steel'].no_rank = nil
  G.P_CENTERS['m_steel'].no_suit = nil
  -- Remove the temporary steel card to save memory / screen real-estate
  temp_steel:remove()
end

-- Bronzor 436
local bronzor = {
  name = "bronzor",
  config = {extra = { triggered = 0 }, evo_rqmt = 20},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
		return {vars = {math.max(card.ability.evo_rqmt - card.ability.extra.triggered, 0)}}
  end,
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Metal",
  gen = 4,
  perishable_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.other_joker and context.other_joker == card then
      score_metal_jokers(context.other_joker, context)
    end
    if context.individual and context.cardarea == G.hand and context.scoring_metal_for == card then
      card.ability.extra.triggered = card.ability.extra.triggered + 1
    end
    return scaling_evo(self, card, context, "j_nacho_bronzong", card.ability.extra.triggered, self.config.evo_rqmt)
  end,
}

-- Bronzong 437
local bronzong = {
  name = "bronzong",
  config = { extra = {} },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
		return {vars = {}}
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "One",
  ptype = "Metal",
  gen = 4,
  perishable_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.other_joker then
      local adjacent = poke_get_adjacent_jokers(card)
      if context.other_joker == card or (PkmnDip.utils.contains(adjacent, context.other_joker) and is_type(context.other_joker, "Metal")) then
        score_metal_jokers(context.other_joker, context)
      end
    end
  end,
}

return {
  config_key = "bronzor",
  list = { bronzor, bronzong }
}
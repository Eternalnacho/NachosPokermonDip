local score_metal_jokers = function(card, context)
  local temp_steel = SMODS.create_card({set = 'Enhanced', enhancement = 'm_steel'})
  temp_steel:hard_set_T(card.T.x, card.T.y, card.T.w, card.T.h)
  G.E_MANAGER:add_event(Event({
    func = function()
      card:set_role({major = temp_steel, role_type = 'Minor', xy_bond = 'Strong', r_bond = 'Strong', scale_bond = 'Strong', wh_bond = 'Strong'})
      return true
    end
  }))
  temp_steel.juice_card = card
  G.P_CENTERS['m_steel'].no_rank = true
  G.P_CENTERS['m_steel'].no_suit = true
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
  local reps = { 1 }
  local j = 1
  while j <= #reps do
    if reps[j] ~= 1 then
      local _, eff = next(reps[j])
      while eff.retrigger_flag do
        SMODS.calculate_effect(eff, temp_steel); j = j+1; _, eff = next(reps[j])
      end
      SMODS.calculate_effect(eff, temp_steel)
    end

    temp_context.main_scoring = true
    local effects = { eval_card(temp_steel, temp_context) }
    SMODS.calculate_quantum_enhancements(temp_steel, effects, temp_context)
    temp_context.main_scoring = nil
    temp_context.individual = true

    if next(effects) then
      SMODS.calculate_card_areas('jokers', temp_context, effects, { main_scoring = true })
      SMODS.calculate_card_areas('individual', temp_context, effects, { main_scoring = true })
    end

    local flags = SMODS.trigger_effects(effects, temp_steel)

    temp_context.individual = nil
    if reps[j] == 1 and flags.calculated then
      temp_context.repetition = true
      temp_context.card_effects = effects
      SMODS.calculate_repetitions(temp_steel, temp_context, reps)
      temp_context.repetition = nil
      temp_context.card_effects = nil
    end
    j = j + (flags.calculated and 1 or #reps)
    temp_context.other_card = nil
    temp_steel.lucky_trigger = nil
  end

  G.P_CENTERS['m_steel'].no_rank = nil
  G.P_CENTERS['m_steel'].no_suit = nil
  G.E_MANAGER:add_event(Event({
    func = function()
      card:set_role({major = card, role_type = 'Major'})
      return true
    end
  }))
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
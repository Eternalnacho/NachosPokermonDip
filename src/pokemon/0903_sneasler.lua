-- Hisuian Sneasel 215-1
local hisuian_sneasel={
  name = "hisuian_sneasel",
  config = {extra = {Xmult_mod = 0.1}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stall_toxic
    return {vars = {}}
  end,
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Fighting",
  gen = 2,
  item_req = "dawnstone",
  toxic = true,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not card.ability.extra.triggered and #context.full_hand == 1 and
        context.full_hand[1].config.center ~= G.P_CENTERS.c_base then
      -- Ensure this doesn't happen on card retriggers
      card.ability.extra.triggered = true

      -- Change to toxic and do the fancy flippy thing
      poke_convert_cards_to(context.full_hand[1], {mod_conv = 'm_stall_toxic'}, true, true)
      context.full_hand[1]:juice_up()

      -- I dunno if I need to specify this or not but it seems to work so eh
      if G.GAME.toxic_triggered then
      else G.GAME.current_round.toxic = {toxicXMult = 1, toxicMult_mod = 0.05}; G.GAME.toxic_triggered = true end
      toxic_scaling()
      card_eval_status_text(context.full_hand[1], 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
      SMODS.calculate_effect({x_mult = G.GAME.current_round.toxic.toxicXMult}, context.full_hand[1])
			context.full_hand[1]:juice_up()
    end
    
    -- Undo the check for the conversion trigger
    if context.joker_main then card.ability.extra.triggered = nil end

    return item_evo(self, card, context, "j_nacho_sneasler")
  end,
}

-- Sneasler 903
local sneasler={
  name = "sneasler",
  config = {extra = {Xmult_mod = 0.1}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stall_toxic
    return {vars = {card.ability.extra.Xmult_mod}}
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "One",
  ptype = "Fighting",
  gen = 8,
  toxic = true,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not card.ability.extra.triggered and #context.full_hand == 1 and
        context.full_hand[1].config.center ~= G.P_CENTERS.c_base then
      -- Ensure this doesn't happen on card retriggers
      card.ability.extra.triggered = true

      -- Change to toxic and do the fancy flippy thing
      poke_convert_cards_to(context.full_hand[1], {mod_conv = 'm_stall_toxic'}, true, true)
      context.full_hand[1]:juice_up()

      -- I dunno if I need to specify this or not but it seems to work so eh
      if G.GAME.toxic_triggered then
      else G.GAME.current_round.toxic = {toxicXMult = 1, toxicMult_mod = 0.05}; G.GAME.toxic_triggered = true end
      foongus_xmult(card.ability.extra.Xmult_mod)
      toxic_scaling()
      SMODS.calculate_effect({x_mult = G.GAME.current_round.toxic.toxicXMult}, context.full_hand[1])
      context.full_hand[1]:juice_up()

      -- Now also do the change to toxic thing for two random enhanced cards in hand (thanks Black Sludge)
      local cards_held = PkmnDip.utils.filter(G.hand.cards, function(v) return v.config.center ~= G.P_CENTERS.c_base end)
      pseudoshuffle(cards_held, pseudoseed('blacksludge'))
      local limit = math.min(#cards_held, 2)
      for i = 1, limit do
        poke_convert_cards_to(cards_held[i], {mod_conv = 'm_stall_toxic'}, true, true)
        cards_held[i]:juice_up()
        toxic_scaling()
        SMODS.calculate_effect({x_mult = G.GAME.current_round.toxic.toxicXMult}, cards_held[i])
        cards_held[i]:juice_up()
      end
    end

    -- Undo the check for the conversion trigger
    if context.joker_main then card.ability.extra.triggered = false end
	end,
}

return {
  config_key = "hisuian_sneasel",
  list = {hisuian_sneasel, sneasler}
}

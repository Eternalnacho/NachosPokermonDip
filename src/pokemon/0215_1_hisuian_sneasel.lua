-- Hisuian Sneasel 215-1
local hisuian_sneasel={
  name = "hisuian_sneasel",
  config = {extra = {triggered = false}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stall_toxic
    return {vars = {}}
  end,
  designer = "Eternalnacho",
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
      juice_flip(context.full_hand[1])
      G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() context.full_hand[1]:set_ability(G.P_CENTERS.m_stall_toxic);return true end }))
      juice_flip(context.full_hand[1])

      -- I dunno if I need to specify this or not but it seems to work so eh
      if G.GAME.toxic_triggered then
      else G.GAME.current_round.toxic = {toxicXMult = 1, toxicMult_mod = 0.05}; G.GAME.toxic_triggered = true end
      toxic_scaling()
      card_eval_status_text(context.full_hand[1], 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
      SMODS.calculate_effect({x_mult = G.GAME.current_round.toxic.toxicXMult}, context.full_hand[1])
			context.full_hand[1]:juice_up()
    end
    
    -- Undo the check for the conversion trigger
    if context.joker_main then card.ability.extra.triggered = false end

    return item_evo(self, card, context, "j_nacho_sneasler")
  end,
}

-- Sneasler 903
local sneasler={
  name = "sneasler",
  config = {extra = {Xmult_mod = 0.1, triggered = false}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stall_toxic
    return {vars = {card.ability.extra.Xmult_mod}}
  end,
  designer = "Eternalnacho",
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
      juice_flip(context.full_hand[1])
      G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() context.full_hand[1]:set_ability(G.P_CENTERS.m_stall_toxic);return true end }))
      juice_flip(context.full_hand[1])
      card_eval_status_text(context.full_hand[1], 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})

      -- I dunno if I need to specify this or not but it seems to work so eh
      if G.GAME.toxic_triggered then
      else G.GAME.current_round.toxic = {toxicXMult = 1, toxicMult_mod = 0.05}; G.GAME.toxic_triggered = true end
      foongus_xmult(card.ability.extra.Xmult_mod)
      toxic_scaling()
      SMODS.calculate_effect({x_mult = G.GAME.current_round.toxic.toxicXMult}, context.full_hand[1])
			context.full_hand[1]:juice_up()

      -- Now also do the change to toxic thing for two random enhanced cards in hand (thanks Black Sludge)
      local cards_held = {}
      for k, v in ipairs(G.hand.cards) do
        if v.config.center ~= G.P_CENTERS.c_base then
          table.insert(cards_held, v)
        end
      end
      pseudoshuffle(cards_held, pseudoseed('blacksludge'))
      local limit = math.min(#cards_held, 2)
			juice_flip_table(card, cards_held, false, limit)
      for i = 1, limit do
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() cards_held[i]:set_ability(G.P_CENTERS.m_stall_toxic);return true end }))
        toxic_scaling()
        SMODS.calculate_effect({x_mult = G.GAME.current_round.toxic.toxicXMult}, cards_held[i])
      end
      juice_flip_table(card, cards_held, true, limit)
    end

    -- Undo the check for the conversion trigger
    if context.joker_main then card.ability.extra.triggered = false end
	end,
}

return {
  name = "Nacho's Hisuian Sneasel Evo Line",
  enabled = (SMODS.Mods["ToxicStall"] or {}).can_load and nacho_config.hisuian_sneasel or false,
  list = {hisuian_sneasel, sneasler}
}

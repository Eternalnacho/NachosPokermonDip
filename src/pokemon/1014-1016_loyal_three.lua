local function toxic_chain(card)
  local area = PkmnDip.utils.copy_list(#G.hand.cards > 0 and G.hand.cards or G.deck.cards)
  pseudoshuffle(area, pseudoseed('blacksludge'))
  local limit = math.min(#area, 4)
  for i = 1, limit do
    poke_convert_cards_to(area[i], {mod_conv = 'm_stall_toxic'}, true, true)
  end
  card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('poke_toxic_chain_ex'), colour = G.C.PURPLE})
  card.ability.extra.toxic_chain = nil
end

-- Okidogi 1014
local okidogi = {
  name = "okidogi",
  config = { extra = { threshold = 0.4 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stall_toxic
    info_queue[#info_queue+1] = {set = 'Other', key = 'toxic_chain'}
    return { vars = { card.ability.extra.threshold } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Dark",
  gen = 9,
  toxic = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Toxic Chain effect
    if context.first_hand_drawn and card.ability.extra.toxic_chain then
      toxic_chain(card)
    end
    -- Scale scoring toxic cards twice
    if context.individual and context.cardarea == G.play and not context.end_of_round and SMODS.has_enhancement(context.other_card, 'm_stall_toxic') then
      toxic_scaling()
    end
    -- Destroy unenhanced cards by threshold
    if context.end_of_round and not context.individual and not context.repetition and not context.game_over then
      local area = PkmnDip.utils.copy_list(PkmnDip.utils.filter(G.deck.cards, function(v) return v.config.center == G.P_CENTERS.c_base end))
      pseudoshuffle(area, pseudoseed('blacksludge'))
      local limit = math.min(#area, math.floor((G.GAME.current_round.toxic.toxicXMult - 1) / card.ability.extra.threshold))
      local targets = PkmnDip.utils.filter(area, function(v) return get_index(area, v) <= limit end)
      SMODS.destroy_cards(targets, nil, true)
      card:juice_up()
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
      card.ability.extra.toxic_chain = true
    end
  end,
}

-- Munkidori 1015
local munkidori = {
  name = "munkidori",
  config = { extra = { scry = 4, scry_plus = 1, scry_added = 0, threshold = 0.25 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stall_toxic
    info_queue[#info_queue + 1] = {set = 'Other', key = 'scry_cards'}
    info_queue[#info_queue+1] = {set = 'Other', key = 'toxic_chain'}
    return { vars = { card.ability.extra.scry, card.ability.extra.threshold } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Dark",
  gen = 9,
  toxic = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    -- Toxic Chain effect
    if context.first_hand_drawn and a.toxic_chain then
      toxic_chain(card)
    end
    -- Foreseen Toxic cards trigger
    if context.individual and not context.end_of_round and context.cardarea == G.scry_view and not context.other_card.debuff
        and SMODS.has_enhancement(context.other_card, 'm_stall_toxic') then
      toxic_scaling()
      SMODS.calculate_effect({x_mult = G.GAME.current_round.toxic.toxicXMult}, context.other_card)
    end
    -- Add to foresight based on Toxic Xmult
    if context.after then
      a.scry_plus = math.floor((G.GAME.current_round.toxic.toxicXMult - 1) / a.threshold) - a.scry_added
      G.GAME.scry_amount = (G.GAME.scry_amount or 0) + a.scry_plus
      a.scry_added = a.scry_added + a.scry_plus
    end
    -- Reset foresight
    if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
      G.GAME.scry_amount = math.max(a.scry, (G.GAME.scry_amount or 0) - a.scry_added)
      a.scry_added = 0
      return {
        message = localize('k_reset'),
        colour = G.C.PURPLE
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
      card.ability.extra.toxic_chain = true
    end
    G.GAME.scry_amount = (G.GAME.scry_amount or 0) + card.ability.extra.scry
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.scry_amount = math.max(0, (G.GAME.scry_amount or 0) - card.ability.extra.scry - card.ability.extra.scry_added)
  end,
}

-- Fezandipiti 1016
local fezandipiti = {
  name = "fezandipiti",
  config = { extra = {} },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stall_toxic
    info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
    info_queue[#info_queue+1] = {set = 'Other', key = 'toxic_chain'}
    return { vars = {} }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Dark",
  gen = 9,
  toxic = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Lucky + Toxic Quantum Enhancements
    if context.check_enhancement and not context.blueprint then
      if context.other_card.config.center.key == 'm_lucky' then
        return { m_stall_toxic = true }
      end
      if context.other_card.config.center.key == 'm_stall_toxic' then
        return { m_lucky = true }
      end
    end
    -- Lucky Triggers scale toxic cards
    if context.individual and context.other_card.lucky_trigger == true then
      if context.other_card.lucky_mult_trigger then
        toxic_scaling()
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.PURPLE})
      end
      if context.other_card.lucky_money_trigger then
        toxic_scaling()
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.PURPLE})
      end
    end
    -- Toxic Chain effect
    if context.first_hand_drawn and card.ability.extra.toxic_chain then
      toxic_chain(card)
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
      card.ability.extra.toxic_chain = true
    end
  end
}

return {
  config_key = "loyal_three",
  can_load = (SMODS.Mods["ToxicStall"] or {}).can_load or false,
  no_family = true,
  list = { okidogi, munkidori, fezandipiti }
}

-- Pecharunt 1025
local pecharunt = {
  name = "pecharunt",
  config = { extra = { Xmult_mod = 0.02 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stall_toxic
    info_queue[#info_queue+1] = {set = 'Other', key = 'malignant_chain'}
    return { vars = { card.ability.extra.Xmult_mod } }
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
    if context.first_hand_drawn and a.malignant then
      local area = PkmnDip.utils.copy_list(#G.hand.cards > 0 and G.hand.cards or G.deck.cards)
      pseudoshuffle(area, pseudoseed('blacksludge'))
      local limit = math.min(#area, 8)
      for i = 1, limit do
        poke_convert_cards_to(area[i], {mod_conv = 'm_stall_toxic'}, true, true)
        assert(SMODS.modify_rank(area[i], 8 - area[i]:get_id()))
      end
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('poke_malignant_chain_ex'), colour = G.C.PURPLE})
      a.malignant = nil
    end
    -- Scored 8s increase scaling
    if context.individual and context.cardarea == G.play then
      if context.other_card:get_id() == 8 then
        G.GAME.current_round.toxic.toxicMult_mod = (G.GAME.current_round.toxic.toxicMult_mod or 0) + a.Xmult_mod
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
      card.ability.extra.malignant = true
    end
  end
}

return {
  config_key = "pecharunt",
  can_load = (SMODS.Mods["ToxicStall"] or {}).can_load or false,
  list = {pecharunt}
}

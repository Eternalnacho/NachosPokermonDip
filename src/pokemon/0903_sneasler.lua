-- I dunno if I need to specify this or not but it seems to work so eh
local function check_toxic()
  if not G.GAME.toxic_triggered then 
    G.GAME.current_round.toxic = {toxicXMult = 1, toxicMult_mod = 0.05}
    G.GAME.toxic_triggered = true
  end
end

local function convert_and_score(card)
  pokermon.convert_cards(card, {mod_conv = 'm_stall_toxic'}, true, true)
  toxic_scaling()
  SMODS.calculate_effect({x_mult = G.GAME.current_round.toxic.toxicXMult}, card)
end

local function is_enhanced(card)
  return card.config.center ~= G.P_CENTERS.c_base
end

-- Hisuian Sneasel 215-1
local hisuian_sneasel={
  name = "hisuian_sneasel",
  config = {extra = {Xmult_mod = 0.1}},
  loc_vars = function(self, info_queue, card)
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
    -- Main effect
    if context.individual and context.cardarea == G.play
        and not card.ability.extra.triggered
        and #context.full_hand == 1
        and is_enhanced(context.full_hand[1]) then
      -- Ensure this doesn't happen on card retriggers
      card.ability.extra.triggered = true
      check_toxic()
      convert_and_score(context.full_hand[1])
    end
    -- Undo the check for the conversion trigger
    if context.joker_main then
      card.ability.extra.triggered = nil
    end
    return pokermon.item_evo(self, card, context, "j_nacho_sneasler")
  end,
  attributes = {"enhancements", "modify_card", "item_evo"}
}

-- Sneasler 903
local sneasler={
  name = "sneasler",
  config = {extra = {Xmult_mod = 0.1}},
  loc_vars = function(self, info_queue, card)
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
    if context.individual and context.cardarea == G.play
        and not card.ability.extra.triggered
        and #context.full_hand == 1
        and is_enhanced(context.full_hand[1]) then
      -- Ensure this doesn't happen on card retriggers
      card.ability.extra.triggered = true
      check_toxic()
      foongus_xmult(card.ability.extra.Xmult_mod)
      convert_and_score(context.full_hand[1])
      -- Now also do the change to toxic thing for two random enhanced cards in hand (thanks Black Sludge)
      local cards_held = PkmnDip.utils.filter(G.hand.cards, is_enhanced)
      pseudoshuffle(cards_held, pseudoseed('blacksludge'))
      for i = 1, math.min(#cards_held, 2) do convert_and_score(cards_held[i]) end
    end
    -- Undo the check for the conversion trigger
    if context.joker_main then card.ability.extra.triggered = false end
	end,
  attributes = {"enhancements", "modify_card"}
}

return {
  config_key = "hisuian_sneasel",
  misc_config = "ToxicStall",
  list = {hisuian_sneasel, sneasler}
}

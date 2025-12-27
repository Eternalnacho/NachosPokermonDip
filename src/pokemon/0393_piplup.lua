-- Piplup 393
local piplup={
  name = "piplup",
  config = {extra = {hands = 1, chips = 80, chip_loss = 20, rounds = 4}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.hands, card.ability.extra.chips, card.ability.extra.chip_loss, card.ability.extra.rounds}}
  end,
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Water",
  starter = true,
  nacho_starter = true,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        chips = math.max(card.ability.extra.chips - card.ability.extra.chip_loss * (#context.scoring_hand), 0)
      }
    end
    return level_evo(self, card, context, "j_nacho_prinplup")
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
    if not from_debuff then
      ease_hands_played(card.ability.extra.hands)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
    local to_decrease = math.min(G.GAME.current_round.hands_left - 1, card.ability.extra.hands)
    if to_decrease > 0 then
      ease_hands_played(-to_decrease)
    end
  end,
}

-- Prinplup 394
local prinplup={
  name = "prinplup",
  config = {extra = {hands = 1, chips = 30, chip_mod = 0, rounds = 4}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.hands, card.ability.extra.chips, card.ability.extra.chip_mod, card.ability.extra.rounds}}
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Water",
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.individual and not context.end_of_round and context.cardarea == G.hand then
      if not SMODS.has_no_rank(context.other_card) then
        card.ability.extra.chip_mod = context.other_card.base.nominal
      end
      return {
        h_chips = card.ability.extra.chip_mod,
        card = card,
      }
    end
    if context.joker_main then
      return {
        chips = card.ability.extra.chips,
      }
    end
    return level_evo(self, card, context, "j_nacho_empoleon")
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
    if not from_debuff then
      ease_hands_played(card.ability.extra.hands)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
    local to_decrease = math.min(G.GAME.current_round.hands_left - 1, card.ability.extra.hands)
    if to_decrease > 0 then
      ease_hands_played(-to_decrease)
    end
  end,
}

-- Empoleon 395
local empoleon={
  name = "empoleon",
  config = {extra = {hands = 1, chips = 50, chip_mod = 0}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.hands, card.ability.extra.chips, card.ability.extra.chip_mod, card.ability.extra.rounds}}
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Water",
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)    
    if context.individual and not context.end_of_round and context.cardarea == G.hand then
      if not SMODS.has_no_rank(context.other_card) then
        card.ability.extra.chip_mod = context.other_card.base.nominal * 2
      end
      return {
        h_chips = card.ability.extra.chip_mod,
        card = card,
      }
    end

    if context.joker_main then
      return {
        chips = card.ability.extra.chips,
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
    if not from_debuff then
      ease_hands_played(card.ability.extra.hands)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
    local to_decrease = math.min(G.GAME.current_round.hands_left - 1, card.ability.extra.hands)
    if to_decrease > 0 then
      ease_hands_played(-to_decrease)
    end
  end,
}

return {
  config_key = "piplup",
  list = { piplup, prinplup, empoleon }
}

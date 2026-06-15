-- Turtwig 387
local turtwig={
  name = "turtwig",
  config = {extra = {h_size = 1, interest = 0, rounds = 4}},
  loc_vars = function(self, info_queue, card)
    pokermon.type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.h_size, card.ability.extra.rounds, G.GAME.interest_cap / 5}}
  end,
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Grass",
  starter = true,
  nacho_starter = true,
  perishable_compat = false,
  blueprint_compat = false,
  eternal_compat = true,
  poke_custom_values_to_keep = { "interest" },
  calculate = function(self, card, context)
    if context.end_of_round and context.cardarea == G.jokers then
      card.ability.extra.interest = card.ability.extra.interest + 1
      G.GAME.interest_cap = G.GAME.interest_cap + 5
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('poke_leech_seed_ex')})
    end
    return pokermon.level_evo(self, card, context, "j_nacho_grotle")
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
    G.GAME.interest_cap = G.GAME.interest_cap - card.ability.extra.interest * 5
  end,
  attributes = {"starter", "hand_size", "passive", "economy", "round_evo"},
}

-- Grotle 388
local grotle={
  name = "grotle",
  config = {extra = {h_size = 1, interest = 0, rounds = 5}},
  loc_vars = function(self, info_queue, card)
    pokermon.type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.h_size, card.ability.extra.rounds, G.GAME.interest_cap / 5}}
  end,
  designer = "ESN64",
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Grass",
  perishable_compat = false,
  blueprint_compat = false,
  eternal_compat = true,
  poke_custom_values_to_keep = { "interest" },
  calculate = function(self, card, context)
    -- Check for hand-size changes
    if context.setting_blind or context.pre_discard or context.drawing_cards then
      local initial = card.ability.extra.h_size
      local dollars = to_number(G.GAME.dollars + (G.GAME.dollar_buffer or 0)) or 0
      card.ability.extra.h_size = math.clamp( math.floor(dollars / 15), 0, 2)
      G.hand:change_size(card.ability.extra.h_size - initial)
    end
    if context.end_of_round and context.cardarea == G.jokers then
      card.ability.extra.interest = card.ability.extra.interest + 2
      G.GAME.interest_cap = G.GAME.interest_cap + 10
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('poke_leech_seed_ex')})
    end
    return pokermon.level_evo(self, card, context, "j_nacho_torterra")
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
    PkmnDip.defer(function()
      G.GAME.interest_cap = G.GAME.interest_cap + card.ability.extra.interest * 5
    end)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
    G.GAME.interest_cap = G.GAME.interest_cap - card.ability.extra.interest * 5
  end,
  attributes = {"starter", "hand_size", "passive", "economy", "round_evo"},
}

-- Torterra 389
local torterra={
  name = "torterra",
  config = {extra = {h_size = 0, interest = 0, addition = 3}},
  loc_vars = function(self, info_queue, card)
    pokermon.type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.h_size, card.ability.extra.mult, G.GAME.interest_cap / 5}}
  end,
  designer = "ESN64",
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Grass",
  perishable_compat = false,
  blueprint_compat = false,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.setting_blind or context.pre_discard or context.drawing_cards then
      local initial = card.ability.extra.h_size
      local dollars = to_number(G.GAME.dollars + (G.GAME.dollar_buffer or 0)) or 0
      card.ability.extra.h_size = math.clamp( math.floor(dollars / 15), 0, 3)
      G.hand:change_size(card.ability.extra.h_size - initial)
    end
    if context.end_of_round and context.cardarea == G.jokers then
      card.ability.extra.interest = card.ability.extra.interest + 3
      G.GAME.interest_cap = G.GAME.interest_cap + 15
      return {
          message = localize("poke_leech_seed_ex"),
          card = card,
        }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
    PkmnDip.defer(function()
      G.GAME.interest_cap = G.GAME.interest_cap + card.ability.extra.interest * 5
    end)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
    G.GAME.interest_cap = G.GAME.interest_cap - card.ability.extra.interest * 5
  end,
  attributes = {"starter", "hand_size", "passive", "economy"},
}

local init = function()
  -- until I find a better way to do this I'm just gonna make the vouchers increase the interest cap instead of set it.
  SMODS.Voucher:take_ownership('seed_money', {
    redeem = function(self, card)
      PkmnDip.defer(function()
        G.GAME.interest_cap = G.GAME.interest_cap + 25
      end)
    end
  }, true)
  SMODS.Voucher:take_ownership('money_tree', {
    redeem = function(self, card)
      PkmnDip.defer(function()
        G.GAME.interest_cap = G.GAME.interest_cap + 50
      end)
    end
  }, true)
end

return {
  config_key = "turtwig",
  init = init,
  list = { turtwig, grotle, torterra }
}

-- Turtwig 387
local turtwig={
  name = "turtwig",
  config = {extra = {h_size = 1, interest = 5, counter = 0, money = 0, money_mod = 0, rounds = 4}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.h_size, card.ability.extra.rounds, G.GAME.interest_cap / 5}}
  end,
  designer = "Eternalnacho",
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Grass",
  starter = 'turtwig' and true or false,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.end_of_round and context.cardarea == G.jokers then
      local evolved = level_evo(self, card, context, "j_nacho_grotle")
      if evolved then
        card.ability.extra.money = card.ability.extra.counter
        return evolved
      end
      card.ability.extra.counter = card.ability.extra.counter + 1
      G.GAME.interest_cap = G.GAME.interest_cap + card.ability.extra.interest
      return {
          message = localize("poke_leech_seed_ex"),
          card = card,
        }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
    G.GAME.interest_cap = G.GAME.interest_cap - card.ability.extra.counter * card.ability.extra.interest
  end,
}

-- Grotle 388
local grotle={
  name = "grotle",
  config = {extra = {h_size = 1, interest = 5, counter = 0, money = 0, money_mod = 0, rounds = 5}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.h_size, card.ability.extra.rounds, G.GAME.interest_cap / 5}}
  end,
  designer = "Eternalnacho, ESN64",
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Grass",
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.setting_blind or context.pre_discard then
      local old_h_size = card.ability.extra.h_size
      if (SMODS.Mods["Talisman"] or {}).can_load then
        local dollars = to_number(G.GAME.dollars)
        if card.ability.extra.h_size ~= math.floor(((dollars or 0) + (G.GAME.dollar_buffer or 0)) / 15) then
          card.ability.extra.h_size = math.floor(((dollars or 0) + (G.GAME.dollar_buffer or 0)) / 15)
        end
      else
        if card.ability.extra.h_size ~= math.floor(((G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0)) / 15) then
          card.ability.extra.h_size = math.floor(((G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0)) / 15)
        end
      end
      if card.ability.extra.h_size > 2 then card.ability.extra.h_size = 2 end
      if card.ability.extra.h_size == old_h_size then return end
      G.hand:change_size(card.ability.extra.h_size - old_h_size)
    end
    if context.end_of_round and context.cardarea == G.jokers then
      local evolved = level_evo(self, card, context, "j_nacho_torterra")
      if evolved then
        card.ability.extra.money = card.ability.extra.counter
        return evolved
      end
      card.ability.extra.counter = card.ability.extra.counter + 2
      G.GAME.interest_cap = G.GAME.interest_cap + card.ability.extra.interest * 2
      return {
          message = localize("poke_leech_seed_ex"),
          card = card,
        }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.0, func = function()
              card.ability.extra.counter = card.ability.extra.money
              G.GAME.interest_cap = G.GAME.interest_cap + card.ability.extra.counter * card.ability.extra.interest
              return true end }))
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
    G.GAME.interest_cap = G.GAME.interest_cap - card.ability.extra.counter * card.ability.extra.interest
  end,
}

-- Torterra 389
local torterra={
  name = "torterra",
  config = {extra = {h_size = 0, interest = 5, counter = 0, money = 0, money_mod = 0}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.h_size, card.ability.extra.mult, G.GAME.interest_cap / 5}}
  end,
  designer = "Eternalnacho, ESN64",
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Grass",
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.setting_blind or context.pre_discard then
      local old_h_size = card.ability.extra.h_size
      if (SMODS.Mods["Talisman"] or {}).can_load then
        local dollars = to_number(G.GAME.dollars)
        if card.ability.extra.h_size ~= math.floor(((dollars or 0) + (G.GAME.dollar_buffer or 0)) / 15) then
          card.ability.extra.h_size = math.floor(((dollars or 0) + (G.GAME.dollar_buffer or 0)) / 15)
        end
      else
        if card.ability.extra.h_size ~= math.floor(((G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0)) / 15) then
          card.ability.extra.h_size = math.floor(((G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0)) / 15)
        end
      end
      if card.ability.extra.h_size > 4 then card.ability.extra.h_size = 4 end
      if card.ability.extra.h_size == old_h_size then return end
      G.hand:change_size(card.ability.extra.h_size - old_h_size)
    end
    if context.end_of_round and context.cardarea == G.jokers then
      card.ability.extra.counter = card.ability.extra.counter + 3
      G.GAME.interest_cap = G.GAME.interest_cap + card.ability.extra.interest * 3
      return {
          message = localize("poke_leech_seed_ex"),
          card = card,
        }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.0, func = function()
              card.ability.extra.counter = card.ability.extra.money
              G.GAME.interest_cap = G.GAME.interest_cap + card.ability.extra.counter * card.ability.extra.interest
              return true end }))
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
    G.GAME.interest_cap = G.GAME.interest_cap - card.ability.extra.counter * card.ability.extra.interest
  end,
}

return {
  name = "Nacho's Turtwig Evo Line",
  enabled = 'turtwig',
  list = { turtwig, grotle, torterra }
}

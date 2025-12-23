-- Turtwig 387
local turtwig={
  name = "turtwig",
  config = {extra = {h_size = 1, interest = 5, counter = 0, rounds = 4}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.h_size, card.ability.extra.rounds, G.GAME.interest_cap / 5}}
  end,
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Grass",
  starter = true,
  perishable_compat = false,
  blueprint_compat = true,
  eternal_compat = true,
  poke_custom_values_to_keep = { "counter" },
  calculate = function(self, card, context)
    if context.end_of_round and context.cardarea == G.jokers then
      card.ability.extra.counter = card.ability.extra.counter + 1
      G.GAME.interest_cap = G.GAME.interest_cap + card.ability.extra.interest
      local evolved = level_evo(self, card, context, "j_nacho_grotle")
      if evolved then
        return evolved
      end
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
  config = {extra = {h_size = 1, interest = 5, counter = 0, rounds = 5}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.h_size, card.ability.extra.rounds, G.GAME.interest_cap / 5}}
  end,
  designer = "ESN64",
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Grass",
  perishable_compat = false,
  blueprint_compat = true,
  eternal_compat = true,
  poke_custom_values_to_keep = { "counter" },
  calculate = function(self, card, context)
    if context.setting_blind or context.pre_discard or context.drawing_cards then
      local old_h_size = card.ability.extra.h_size
      local dollars = (SMODS.Mods["Talisman"] or {}).can_load and to_number(G.GAME.dollars) or G.GAME.dollars
      if card.ability.extra.h_size ~= math.floor(((dollars or 0) + (G.GAME.dollar_buffer or 0)) / 15) then
        card.ability.extra.h_size = math.max( math.min(math.floor(((dollars or 0) + (G.GAME.dollar_buffer or 0)) / 15), 2), 0 )
      end
      if card.ability.extra.h_size ~= old_h_size then G.hand:change_size(card.ability.extra.h_size - old_h_size) end
    end
    if context.end_of_round and context.cardarea == G.jokers then
      card.ability.extra.counter = card.ability.extra.counter + 2
      G.GAME.interest_cap = G.GAME.interest_cap + card.ability.extra.interest * 2
      local evolved = level_evo(self, card, context, "j_nacho_torterra")
      if evolved then
        return evolved
      end
      return {
          message = localize("poke_leech_seed_ex"),
          card = card,
        }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.1,
      func = function()
        G.GAME.interest_cap = G.GAME.interest_cap + card.ability.extra.counter * card.ability.extra.interest
        return true
      end
    }))
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
    G.GAME.interest_cap = G.GAME.interest_cap - card.ability.extra.counter * card.ability.extra.interest
  end,
}

-- Torterra 389
local torterra={
  name = "torterra",
  config = {extra = {h_size = 0, interest = 5, counter = 0}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.h_size, card.ability.extra.mult, G.GAME.interest_cap / 5}}
  end,
  designer = "ESN64",
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Grass",
  perishable_compat = false,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.setting_blind or context.pre_discard or context.drawing_cards then
      local old_h_size = card.ability.extra.h_size
      local dollars = (SMODS.Mods["Talisman"] or {}).can_load and to_number(G.GAME.dollars) or G.GAME.dollars
      if card.ability.extra.h_size ~= math.floor(((dollars or 0) + (G.GAME.dollar_buffer or 0)) / 15) then
        card.ability.extra.h_size = math.max( math.min(math.floor(((dollars or 0) + (G.GAME.dollar_buffer or 0)) / 15), 4), 0 )
      end
      if card.ability.extra.h_size ~= old_h_size then G.hand:change_size(card.ability.extra.h_size - old_h_size) end
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
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.1,
      func = function()
        G.GAME.interest_cap = G.GAME.interest_cap + card.ability.extra.counter * card.ability.extra.interest
        return true
      end
    }))
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
    G.GAME.interest_cap = G.GAME.interest_cap - card.ability.extra.counter * card.ability.extra.interest
  end,
}

local init = function()
  -- until I find a better way to do this I'm just gonna make the vouchers increase the interest cap instead of set it.
  SMODS.Voucher:take_ownership('seed_money', {
    redeem = function(self, card)
      G.E_MANAGER:add_event(Event({
          func = function()
              G.GAME.interest_cap = G.GAME.interest_cap + 25
              return true
          end
      }))
    end
  }, true)
  SMODS.Voucher:take_ownership('money_tree', {
    redeem = function(self, card)
      G.E_MANAGER:add_event(Event({
          func = function()
              G.GAME.interest_cap = G.GAME.interest_cap + 50
              return true
          end
      }))
    end
  }, true)
end

return {
  config_key = "turtwig",
  init = init,
  list = { turtwig, grotle, torterra }
}

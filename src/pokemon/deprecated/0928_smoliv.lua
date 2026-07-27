-- Smoliv 928
local smoliv = {
  name = "smoliv",
  config = { extra = { money = 2, rounds = 4 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money, card.ability.extra.rounds } }
  end,
  loc_txt = {
    name = "Smoliv",
    text = {
      "Adds {C:money}$#1#{} of sell value",
      "to a random {X:poke_grass,C:white}Grass{} Joker",
      "at end of round",
      "{C:inactive,s:0.8}(Evolves after {C:attention,s:0.8}#2#{C:inactive,s:0.8} rounds)",
    }
  },
  rarity = 1,
  cost = 4,
  stage = "Basic",
  ptype = "Grass",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.end_of_round and context.main_eval then
      local grass_target = pseudorandom_element(pokermon.find_pokemon_type('Grass'), 'smoliv')
      if grass_target and grass_target.set_cost then
        grass_target.ability.extra_value = (grass_target.ability.extra_value or 0) + card.ability.extra.money
        grass_target:set_cost()
      end
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_val_up'), colour = G.C.MONEY})
    end
    return pokermon.level_evo(self, card, context, 'j_nacho_dolliv')
  end,
  attributes = {"types", "joker", "sell_value", "round_evo"}
}

-- Dolliv 929
local dolliv = {
  name = "dolliv",
  config = { extra = { money = 2, money1 = 1, num = 1, den = 3, total_sell_value = 0 }, evo_rqmt = 25 },
  loc_vars = function(self, info_queue, card)
    local a = card.ability.extra or self.config.extra
    local num, den = SMODS.get_probability_vars(card, a.num, a.den, 'dolliv')
    return { vars = { a.money, a.money1, num, den, a.total_sell_value, self.config.evo_rqmt } }
  end,
  loc_txt = {
    name = "Dolliv",
    text = {
      "Adds {C:money}$#1#{} of sell value",
      "to a random {X:poke_grass,C:white}Grass{} Joker",
      "at end of round",
      "{br:2.5}ERROR - CONTACT STEAK",
      "{C:green}#3# in #4#{} chance to add",
      "{C:money}$#2#{} of sell value to",
      "each {X:poke_grass,C:white}Grass{} Joker instead",
      "{C:inactive,s:0.8}(Evolves at {C:money,s:0.8}$#5#{C:inactive,s:0.8}/$#6# total",
      "{C:inactive,s:0.8}sell value of {X:poke_grass,C:white,s:0.8}Grass{C:inactive,s:0.8} Jokers)",
    }
  },
  rarity = 3,
  cost = 7,
  stage = "One",
  ptype = "Grass",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.end_of_round and context.main_eval then
      if SMODS.pseudorandom_probability(card, 'greedent', a.num, a.den, 'dolliv') then
        for _, v in pairs(pokermon.find_pokemon_type('Grass')) do
          if v.set_cost then
            v.ability.extra_value = (v.ability.extra_value or 0) + a.money1
            v:set_cost()
          end
        end
      else
        local grass_target = pseudorandom_element(pokermon.find_pokemon_type('Grass'), 'dolliv')
        if grass_target and grass_target.set_cost then
          grass_target.ability.extra_value = (grass_target.ability.extra_value or 0) + a.money
          grass_target:set_cost()
        end
      end
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_val_up'), colour = G.C.MONEY})
    end
    local total_sell_value = 0
    PkmnDip.utils.for_each(pokermon.find_pokemon_type('Grass'), function(v) total_sell_value = total_sell_value + v.sell_cost end)
    a.total_sell_value = total_sell_value
    return pokermon.scaling_evo(self, card, context, "j_nacho_arboliva", a.total_sell_value, self.config.evo_rqmt)
  end,
  attributes = {"types", "joker", "sell_value", "condition_evo"}
}

-- Arboliva 930
local arboliva = {
  name = "arboliva",
  config = { extra = { money = 2, Xmult = 1, Xmult_mod = 0.01 } },
  loc_vars = function(self, info_queue, card)
    local a = card.ability.extra or self.config.center
    local total_sell_value = 0
    PkmnDip.utils.for_each(pokermon.find_pokemon_type('Grass'), function(v) total_sell_value = total_sell_value + v.sell_cost end)
    return { vars = { a.money, a.Xmult_mod, a.Xmult + a.Xmult_mod * total_sell_value, card.ability.extra.rounds } }
  end,
  loc_txt = {
    name = "Arboliva",
    text = {
      "Adds {C:money}$#1#{} of sell value",
      "to each {X:poke_grass,C:white}Grass{} Joker",
      "at end of round",
      "{br:2.5}ERROR - CONTACT STEAK",
      "{X:mult,C:white}X#2#{} Mult for every",
      "{C:money}${} of sell value from",
      "{X:poke_grass,C:white}Grass{} Jokers",
      "{C:inactive}(Currently {X:mult,C:white}X#3#{})"
    }
  },
  rarity = "poke_safari",
  cost = 9,
  stage = "Two",
  ptype = "Grass",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.joker_main then
      local total_sell_value = 0
      PkmnDip.utils.for_each(pokermon.find_pokemon_type('Grass'), function(v) total_sell_value = total_sell_value + v.sell_cost end)
      return { xmult = a.Xmult + a.Xmult_mod * total_sell_value }
    end
    if context.end_of_round and context.main_eval then
      for _, v in pairs(pokermon.find_pokemon_type('Grass')) do
        if v.set_cost then
          v.ability.extra_value = (v.ability.extra_value or 0) + a.money
          v:set_cost()
        end
      end
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_val_up'), colour = G.C.MONEY})
    end
  end,
  attributes = {"types", "joker", "sell_value", "xmult"}
}

return {
  can_load = false,
  config_key = "smoliv",
  list = { smoliv, dolliv, arboliva }
}

-- Smoliv 928
local smoliv = {
  name = "smoliv",
  config = { extra = { money = 2, rounds = 4 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.money, card.ability.extra.rounds } }
  end,
  rarity = 1,
  cost = 4,
  stage = "Basic",
  ptype = "Grass",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.end_of_round and context.main_eval then
      local grass_target = pseudorandom_element(find_pokemon_type('Grass'), 'smoliv')
      if grass_target.set_cost then 
        grass_target.ability.extra_value = (grass_target.ability.extra_value or 0) + card.ability.extra.money
        grass_target:set_cost()
      end
    end
    return level_evo(self, card, context, 'j_nacho_dolliv')
  end,
}

-- Dolliv 929
local dolliv = {
  name = "dolliv",
  config = { extra = { money = 2, num = 1, den = 3, rounds = 4 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, 'dolliv')
    return { vars = { card.ability.extra.money, num, den, card.ability.extra.rounds } }
  end,
  rarity = 3,
  cost = 7,
  stage = "One",
  ptype = "Grass",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.end_of_round and context.main_eval then
      if SMODS.pseudorandom_probability(card, 'greedent', card.ability.extra.num, card.ability.extra.den, 'dolliv') then
        for _, v in pairs(find_pokemon_type('Grass')) do
          if v.set_cost then 
            v.ability.extra_value = (v.ability.extra_value or 0) + card.ability.extra.money
            v:set_cost()
          end
        end
      else
        local grass_target = pseudorandom_element(find_pokemon_type('Grass'), 'dolliv')
        if grass_target.set_cost then 
          grass_target.ability.extra_value = (grass_target.ability.extra_value or 0) + card.ability.extra.money
          grass_target:set_cost()
        end
      end
    end
    return level_evo(self, card, context, 'j_nacho_arboliva')
  end,
}

-- Arboliva 930
local arboliva = {
  name = "arboliva",
  config = { extra = { money = 2, Xmult = 1, Xmult_mod = 0.01 } },
  loc_vars = function(self, info_queue, card)
    local a = card.ability.extra or self.config.center
    local total_sell_value = 0
    PkmnDip.utils.for_each(find_pokemon_type('Grass'), function(v) total_sell_value = total_sell_value + v.sell_cost end)
    type_tooltip(self, info_queue, card)
    return { vars = { a.money, a.Xmult_mod, a.Xmult + a.Xmult_mod * total_sell_value, card.ability.extra.rounds } }
  end,
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
      PkmnDip.utils.for_each(find_pokemon_type('Grass'), function(v) total_sell_value = total_sell_value + v.sell_cost end)
      return { xmult = a.Xmult + a.Xmult_mod * total_sell_value }
    end
    if context.end_of_round and context.main_eval then
      for _, v in pairs(find_pokemon_type('Grass')) do
        if v.set_cost then 
          v.ability.extra_value = (v.ability.extra_value or 0) + a.money
          v:set_cost()
        end
      end
    end
  end,
}

return {
  config_key = "smoliv",
  list = { smoliv, dolliv, arboliva }
}

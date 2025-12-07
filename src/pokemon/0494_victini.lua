-- Victini 494
local victini = {
  name = "victini",
  config = { extra = { Xmult = 1, Xmult_mod = 0.1 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_mod } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Fire",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.mod_probability and not context.blueprint then
      if context.from_roll then
        card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
      end
      return { numerator = context.numerator * 3 }
    end

    if context.joker_main then
      return { Xmult = card.ability.extra.Xmult }
    end
  end
}

return {
  config_key = "victini",
  list = { victini }
}

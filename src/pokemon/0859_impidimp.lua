-- Impidimp 859
local impidimp={
  name = "impidimp",
  config = {extra = {rounds = 4}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.hands, card.ability.extra.chips, card.ability.extra.chip_loss, card.ability.extra.rounds}}
  end,
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Fairy",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before then
      PkmnDip.eff.switch_cards(G.play, 'impidimp', context)
    end
    return pokermon.level_evo(self, card, context, "j_nacho_morgrem")
  end,
  attributes = {},
}

-- Morgrem 860
local morgrem={
  name = "morgrem",
  config = {extra = {rounds = 4}},
  loc_vars = function(self, info_queue, card)
    return {vars = {}}
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Fairy",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before then
      PkmnDip.eff.shuffle_cards(G.play, 'morgrem', context, 3)
    end
    return pokermon.level_evo(self, card, context, "j_nacho_grimmsnarl")
  end,
  attributes = {},
}

-- Grimmsnarl 861
local grimmsnarl={
  name = "grimmsnarl",
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.hands, card.ability.extra.chips}}
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Fairy",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before then
      PkmnDip.eff.shuffle_cards(G.play, 'grimmsnarl', context)
    end
  end,
  attributes = {},
}

return {
  -- can_load = false,
  config_key = "impidimp",
  list = { impidimp, morgrem, grimmsnarl }
}

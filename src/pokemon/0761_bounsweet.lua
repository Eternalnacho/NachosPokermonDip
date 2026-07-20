local is_grass = function(j) return pokermon.is_type(j, "Grass") end

local bounsweet = {
  name = "bounsweet",
  config = { extra = { mult = 3, rounds = 4 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult, card.ability.extra.rounds } }
  end,
  designer = "One Punch Idiot",
  nacho_from_bfp = true,
  rarity = 1,
  cost = 4,
  stage = "Basic",
  ptype = "Grass",
  gen = 7,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      local mult = card.ability.extra.mult
      if #pokermon.find_pokemon_type("Grass", card) > 0 then
        mult = mult * 3
      end
      return { mult = card.ability.extra.mult }
    end
    return pokermon.level_evo(self, card, context, "j_nacho_steenee")
  end
}

local steenee = {
  name = "steenee",
  config = { extra = { mult = 7 }, evo_rqmt = 3 },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult, self.config.evo_rqmt } }
  end,
  designer = "One Punch Idiot",
  nacho_from_bfp = true,
  rarity = 2,
  cost = 6,
  stage = "One",
  ptype = "Grass",
  gen = 7,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      local count = #pokermon.find_pokemon_type("Grass")
      return { mult = card.ability.extra.mult * count }
    end
    local grass_count = #pokermon.find_pokemon_type("Grass")
    return pokermon.scaling_evo(self, card, context, "j_nacho_tsareena", grass_count, self.config.evo_rqmt)
  end
}

local tsareena = {
  name = "tsareena",
  config = { extra = { mult = 11 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  designer = "One Punch Idiot",
  nacho_from_bfp = true,
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Grass",
  gen = 7,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      local count = #pokermon.find_pokemon_type("Grass")
      return { mult = card.ability.extra.mult * count }
    end
  end
}

return {
  config_key = 'bounsweet',
  init = init,
  list = { bounsweet, steenee, tsareena }
}

local jd_def = JokerDisplay.Definitions

-- Bounsweet
jd_def["j_nacho_bounsweet"] = {
  text = {
    { text = "+" },
    { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
  },
  text_config = { colour = G.C.MULT },
  calc_function = function(card)
    local count = #pokermon.find_pokemon_type("Grass", card)
    card.joker_display_values.mult = card.ability.extra.mult * (count > 0 and 3 or 1)
  end
}

-- Steenee
jd_def["j_nacho_steenee"] = {
  text = {
    { text = "+" },
    { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
  },
  text_config = { colour = G.C.MULT },
  calc_function = function(card)
    local count = #pokermon.find_pokemon_type("Grass")
    card.joker_display_values.mult = card.ability.extra.mult * count
  end
}

-- Tsareena
jd_def["j_nacho_tsareena"] = {
  text = {
    { text = "+" },
    { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
  },
  text_config = { colour = G.C.MULT },
  calc_function = function(card)
    local count = #pokermon.find_pokemon_type("Grass")
    card.joker_display_values.mult = card.ability.extra.mult * count
  end
}
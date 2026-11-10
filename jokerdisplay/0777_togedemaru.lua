local jd_def = JokerDisplay.Definitions

-- Turtonator
jd_def["j_nacho_togedemaru"] = {
  text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "lightning_count", colour = G.C.ORANGE },
    { text = "x" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text_l", colour = G.C.GREEN },
    { text = ")" },
  },
  text_config = {
    colour = G.C.UI.TEXT_INACTIVE,
    scale = 0.3
  },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "metal_count", colour = G.C.ORANGE },
    { text = "x" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text_m", colour = G.C.GREEN },
    { text = ")" },
  },
  calc_function = function(card)
    local lightning_count = #pokermon.find_pokemon_type("Lightning")
    local metal_count = #pokermon.find_pokemon_type("Metal")
    card.joker_display_values.lightning_count = lightning_count
    card.joker_display_values.localized_text_l = "Lightning"
    card.joker_display_values.metal_count = metal_count
    card.joker_display_values.localized_text_m = "Metal"
  end,
  mod_function = function(card, mod_joker)
    return {
      x_mult = pokermon.is_type(card, "Lightning") and mod_joker.ability.extra.Xmult_multi ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil,
      dollars = pokermon.is_type(card, "Metal") and mod_joker.ability.extra.money_mod ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil
    }
  end
}

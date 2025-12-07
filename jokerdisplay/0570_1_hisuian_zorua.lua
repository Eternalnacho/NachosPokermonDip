local jd_def = JokerDisplay.Definitions

-- Hisuian Zorua
jd_def["j_nacho_hisuian_zorua"] = {
  reminder_text = {
      { text = "(" },
      { ref_table = "card.joker_display_values", ref_value = "blueprint_compat", colour = G.C.RED },
      { text = ")" }
  },
  calc_function = function(card)
      local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
      card.joker_display_values.blueprint_compat = localize('k_incompatible')
      JokerDisplay.copy_display(card, copied_joker, copied_debuff)
  end,
  get_blueprint_joker = function(card)
      return G.jokers.cards[1]
  end
}

-- Hisuian Zoroark
jd_def["j_nacho_hisuian_zoroark"] = {
  reminder_text = {
      { text = "(" },
      { ref_table = "card.joker_display_values", ref_value = "blueprint_compat", colour = G.C.RED },
      { text = ")" }
  },
  calc_function = function(card)
      local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
      card.joker_display_values.blueprint_compat = localize('k_incompatible')
      JokerDisplay.copy_display(card, copied_joker, copied_debuff)
  end,
  get_blueprint_joker = function(card)
      return G.jokers.cards[1]
  end
}

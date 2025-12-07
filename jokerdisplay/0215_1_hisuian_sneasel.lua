local jd_def = JokerDisplay.Definitions

-- Hisuian Sneasel
jd_def["j_nacho_hisuian_sneasel"] = {
	text = {
		{
			border_nodes = {
				{ text = "X" },
				{ ref_table = "card.ability.extra", ref_value = "Xmult_mod" },
			},
		},
	},
  reminder_text = {
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
  },
  calc_function = function(card)
    card.joker_display_values.localized_text = "(Toxic Scaling)"
  end
}

-- Hisuian Sneasler
jd_def["j_nacho_sneasler"] = {
	text = {
		{
			border_nodes = {
				{ text = "X" },
				{ ref_table = "card.ability.extra", ref_value = "Xmult_mod" },
			},
		},
	},
  reminder_text = {
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
  },
  calc_function = function(card)
    card.joker_display_values.localized_text = "(Toxic Scaling)"
  end
}

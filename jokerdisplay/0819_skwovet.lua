local jd_def = JokerDisplay.Definitions

-- Skwovet
jd_def["j_nacho_skwovet"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
}

-- Greedent
jd_def["j_nacho_greedent"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    extra = {
      {
        { text = "(", colour = G.C.GREEN, scale = 0.3 },
        { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
        { text = ")", colour = G.C.GREEN, scale = 0.3 },
      },
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
      local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, 'greedent')
      card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { num, den } }
    end
}
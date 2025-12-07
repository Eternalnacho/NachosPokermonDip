local jd_def = JokerDisplay.Definitions

-- jd_def["j_nacho_clauncher"] = {
--   retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
--     if held_in_hand then return 0 end
--     local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
--     local second_card = scoring_hand and JokerDisplay.sort_cards(scoring_hand)[2]
--     return first_card and playing_card == first_card and
--     joker_card.ability.extra.retriggers * JokerDisplay.calculate_joker_triggers(joker_card) or 0 and
--     second_card and playing_card == second_card and
--     joker_card.ability.extra.retriggers * JokerDisplay.calculate_joker_triggers(joker_card) or 0
--   end
-- }

jd_def["j_nacho_clawitzer"] = {
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  calc_function = function(card)
    card.joker_display_values.localized_text = "Editioned Cards"
  end,
  retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
    return playing_card.edition and joker_card.ability.extra.retriggers * JokerDisplay.calculate_joker_triggers(joker_card) or 0
  end
}

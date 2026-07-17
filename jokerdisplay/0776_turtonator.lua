local jd_def = JokerDisplay.Definitions

-- Turtonator
jd_def["j_nacho_turtonator"] = {
  text = {
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" },
      },
    },
  },
  calc_function = function(card)
    local triggers = 0
    local _, _, scoring_hand = JokerDisplay.evaluate_hand()
    if card.ability.extra.trapped or G.play.cards then
      for _, scoring_card in pairs(scoring_hand) do
        triggers = triggers + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
      end
    end
    card.joker_display_values.x_mult = card.ability.extra.Xmult_multi ^ triggers
  end
}

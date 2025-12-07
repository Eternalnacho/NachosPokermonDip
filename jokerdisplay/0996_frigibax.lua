local jd_def = JokerDisplay.Definitions

-- Frigibax
jd_def["j_nacho_frigibax"] = {
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  calc_function = function(card)
    card.joker_display_values.localized_text = localize('Five of a Kind', 'poker_hands')
  end,
}

-- Arctibax
jd_def["j_nacho_arctibax"] = {
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  calc_function = function(card)
    card.joker_display_values.localized_text = localize('Five of a Kind', 'poker_hands')
  end,
}

-- Baxcalibur
jd_def["j_nacho_baxcalibur"] = {
  text = {
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" },
      },
    },
  },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  calc_function = function(card)
    local x_mult = 1
    local foil_count = 0
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
    if G.playing_cards then
      foil_count = #PkmnDip.utils.filter(G.playing_cards, function(v) return v.edition and v.edition.foil end)
    end
    if text == 'Five of a Kind' then
      for _, scoring_card in pairs(scoring_hand) do
        local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
        x_mult = x_mult * (1 + card.ability.extra.Xmult_multi * foil_count) ^ (retriggers)
      end
    end
    card.joker_display_values.localized_text = localize('Five of a Kind', 'poker_hands')
    card.joker_display_values.x_mult = x_mult
  end,
}
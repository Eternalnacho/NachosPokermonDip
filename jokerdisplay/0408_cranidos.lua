local jd_def = JokerDisplay.Definitions

-- Cranidos
jd_def["j_nacho_cranidos"] = {
  text = {
    { text = "+" , colour = G.C.MULT },
    { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    { text = " " },
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" },
      },
    },
  },
  reminder_text = {
    { ref_table = "card.joker_display_values", ref_value = "localized_text" }
  },
  calc_function = function(card)
    local count = 0
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
    local fives = PkmnDip.utils.filter(scoring_hand, function(c) return c:get_id() == 5 end)
    if text ~= 'Unknown' then count = #fives end
    local first_five = JokerDisplay.calculate_leftmost_card(fives)
    local mult = count >= 1 and card.ability.extra.mult or 0
    local xmult = count >= 3 and card.ability.extra.Xmult_multi or 1

    card.joker_display_values.mult = first_five and mult * JokerDisplay.calculate_card_triggers(first_five, scoring_hand) or 0
    card.joker_display_values.Xmult = first_five and xmult ^ JokerDisplay.calculate_card_triggers(first_five, scoring_hand) or 1
    card.joker_display_values.localized_text = "(" .. localize("5", "ranks") .. ")"
  end
}


-- Rampardos
jd_def["j_nacho_rampardos"] = {
  text = {
    { text = "+" , colour = G.C.MULT },
    { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    { text = " " },
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" },
      },
    },
  },
  reminder_text = {
    { ref_table = "card.joker_display_values", ref_value = "localized_text" }
  },
  calc_function = function(card)
    local _, _, scoring_hand = JokerDisplay.evaluate_hand()
    
    local fives = PkmnDip.utils.filter(scoring_hand, function(c) return c:get_id() == 5 end)
    local first_five = JokerDisplay.calculate_leftmost_card(fives)
    local mult = #fives >= 1 and card.ability.extra.mult * #fives or 0
    local xmult = #fives >= 3 and 1 + card.ability.extra.Xmult_mod * #fives or 1

    card.joker_display_values.mult = first_five and mult * JokerDisplay.calculate_card_triggers(first_five, scoring_hand) or 0
    card.joker_display_values.Xmult = first_five and xmult ^ JokerDisplay.calculate_card_triggers(first_five, scoring_hand) or 1
    card.joker_display_values.localized_text = "(" .. localize("5", "ranks") .. ")"
  end,
  retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
    local fives = PkmnDip.utils.filter(scoring_hand, function(c) return c:get_id() == 5 end)
    local first_five = JokerDisplay.calculate_leftmost_card(fives)
    
    if #fives >= 4 and playing_card == first_five then
        return joker_card.ability.extra.retriggers * (#fives - 1) * JokerDisplay.calculate_joker_triggers(joker_card)
    end
  end
}

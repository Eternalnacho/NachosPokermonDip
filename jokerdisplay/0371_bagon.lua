local jd_def = JokerDisplay.Definitions

-- Bagon
jd_def["j_nacho_bagon"] = {
  text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  text_config = { colour = G.C.MULT },
  calc_function = function(card)
    local mult = 0
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
    if text == "Two Pair" then
        for _, scoring_card in pairs(scoring_hand) do
            local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
            mult = mult + (scoring_card.base.nominal / 3) * retriggers
        end
        card.joker_display_values.mult = mult
    else
        card.joker_display_values.mult = 0
    end
    card.joker_display_values.localized_text = localize('Two Pair', 'poker_hands')
  end
}

-- Shelgon
jd_def["j_nacho_shelgon"] = {
  text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  text_config = { colour = G.C.MULT },
  calc_function = function(card)
    local mult = 0
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
    if text == "Two Pair" then
        for _, scoring_card in pairs(scoring_hand) do
            local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
            mult = mult + (scoring_card.base.nominal / 2) * retriggers
        end
        card.joker_display_values.mult = mult
    else
        card.joker_display_values.mult = 0
    end
    card.joker_display_values.localized_text = localize('Two Pair', 'poker_hands')
  end
}

-- Salamence
jd_def["j_nacho_salamence"] = {
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
    local avg_rank = 0
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
    if G.playing_cards then
        for k, v in pairs(G.playing_cards) do
            avg_rank = v.base.nominal + avg_rank
        end
        avg_rank = avg_rank / #G.playing_cards
    end
    if text == 'Two Pair' then
      for _, scoring_card in pairs(scoring_hand) do
        local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
        x_mult = x_mult * (1 + card.ability.extra.Xmult * avg_rank) ^ (retriggers)
      end
    end
    card.joker_display_values.localized_text = localize('Two Pair', 'poker_hands')
    card.joker_display_values.x_mult = x_mult
  end,
}

-- Mega Salamence
jd_def["j_nacho_mega_salamence"] = {
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
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
    if text == 'Two Pair' then
      for _, scoring_card in pairs(scoring_hand) do
        local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
        x_mult = x_mult * (card.ability.extra.Xmult ^ (retriggers))
      end
    end
    card.joker_display_values.localized_text = localize('Two Pair', 'poker_hands')
    card.joker_display_values.x_mult = x_mult
  end,
  retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
    if held_in_hand then
        return 0
    elseif playing_card:get_id() > 9 then
        return (joker_card.ability.extra.retriggers * JokerDisplay.calculate_joker_triggers(joker_card)) or 0
    else return 0 end
end,
}
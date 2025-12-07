local jd_def = JokerDisplay.Definitions

-- Goomy
jd_def["j_nacho_goomy"] = {
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
    card.joker_display_values.mult = 0
    local _, poker_hands, _ = JokerDisplay.evaluate_hand()
    if poker_hands['Flush'] and next(poker_hands['Flush']) then
      card.joker_display_values.mult = card.ability.extra.mult_mod
    end
    card.joker_display_values.localized_text = localize('Flush', 'poker_hands')
  end
}

-- Sliggoo
jd_def["j_nacho_sliggoo"] = {
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
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
    local unique_ranks = {}
    if text == "Flush" then
      for _, scoring_card in pairs(scoring_hand) do
        if not PkmnDip.utils.contains(unique_ranks, scoring_card:get_id()) then
          unique_ranks[#unique_ranks+1] = scoring_card:get_id()
        end
      end
      card.joker_display_values.mult = card.ability.extra.mult_mod * #unique_ranks
    else
      card.joker_display_values.mult = 0
    end
    card.joker_display_values.localized_text = localize('Flush', 'poker_hands')
  end
}

-- Goodra
jd_def["j_nacho_goodra"] = {
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
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
    local unique_ranks = {}
    if text == "Flush" then
      for _, scoring_card in pairs(scoring_hand) do
        if not PkmnDip.utils.contains(unique_ranks, scoring_card:get_id()) then
          unique_ranks[#unique_ranks+1] = scoring_card:get_id()
        end
      end
      card.joker_display_values.x_mult = card.ability.extra.Xmult_multi * #unique_ranks
    else
      card.joker_display_values.x_mult = 0
    end
    card.joker_display_values.localized_text = localize('Flush', 'poker_hands')
  end
}

-- Hisuian Sliggoo
jd_def["j_nacho_hisuian_sliggoo"] = {
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  calc_function = function(card)
    card.joker_display_values.localized_text = localize('Flush House', 'poker_hands')
  end,
}

-- Hisuian Goodra
jd_def["j_nacho_hisuian_goodra"] = {
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
    local playing_hand = next(G.play.cards)
    local x_mult = 1
    local first_rank = nil
    local second_rank = nil
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
    if text == 'Flush House' then
        for _, scoring_card in pairs(scoring_hand) do
            if not first_rank and scoring_card:get_id() > 0 then
                first_rank = scoring_card.base.nominal
            elseif not second_rank and scoring_card:get_id() > 0 and scoring_card.base.nominal ~= first_rank then
                second_rank = scoring_card.base.nominal
            end
        end
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if playing_card.facing and not (playing_card.facing == 'back') and SMODS.has_enhancement(playing_card, 'm_steel') and not playing_card.debuff then
                    local triggers = JokerDisplay.calculate_card_triggers(playing_card, scoring_hand, true)
                    if first_rank and second_rank and second_rank ~= first_rank then
                        x_mult = x_mult * (math.abs(second_rank - first_rank) / 3.0) ^ triggers
                    end
                end
            end
        end
    end
    card.joker_display_values.localized_text = localize('Flush House', 'poker_hands')
    card.joker_display_values.x_mult = x_mult
  end,
}
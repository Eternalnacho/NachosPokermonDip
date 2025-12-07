local jd_def = JokerDisplay.Definitions

-- Snover
jd_def["j_nacho_snover"] = {
  text = {
    { text = "+$" },
    { ref_table = "card.joker_display_values", ref_value = "money", retrigger_type = "mult" },
  },
  text_config = { colour = G.C.GOLD },
  calc_function = function(card)
      local count = 0
      local hand = next(G.play.cards) and G.play.cards or G.hand.highlighted
      local text, _, scoring_hand = JokerDisplay.evaluate_hand(hand)
      if text ~= "Unknown" then
          for _, scoring_card in pairs(scoring_hand) do --Polychrome cards scored
              if scoring_card.ability.effect and scoring_card.ability.effect == "Glass Card" then
                  count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
              end
          end
      end
      card.joker_display_values.money = card.ability.extra.money_mod * count
  end
}

-- Abomasnow
jd_def["j_nacho_abomasnow"] = {
  text = {
    { text = "+$" },
    { ref_table = "card.joker_display_values", ref_value = "money", retrigger_type = "mult" },
  },
  text_config = { colour = G.C.GOLD },
  calc_function = function(card)
      local count = 0
      local hand = next(G.play.cards) and G.play.cards or G.hand.highlighted
      local text, _, scoring_hand = JokerDisplay.evaluate_hand(hand)
      if text ~= "Unknown" then
          for _, scoring_card in pairs(scoring_hand) do --Polychrome cards scored
              if scoring_card.ability.effect and scoring_card.ability.effect == "Glass Card" then
                  count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
              end
          end
      end
      card.joker_display_values.money = card.ability.extra.money_mod * count
  end
}

-- Mega Abomasnow
jd_def["j_nacho_mega_abomasnow"] = {
  text = {
    { text = "+$" },
    { ref_table = "card.ability.extra", ref_value = "money_mod", retrigger_type = "mult" },
  },
  text_config = { colour = G.C.GOLD },
}
local jd_def = JokerDisplay.Definitions

-- Galarian Meowth
jd_def["j_nacho_galarian_meowth"] = {
  text = {
    { text = "+" },
    { ref_table = "card.joker_display_values", ref_value = "e_plus", retrigger_type = "mult" }
  },
  text_config = { colour = pokermon.colours.pink },
  calc_function = function(card)
    local steel_found
    local hand = next(G.play.cards) and G.play.cards or G.hand.highlighted
    local text, _, scoring_hand = JokerDisplay.evaluate_hand(hand)
    if text ~= "Unknown" then
      if PkmnDip.utils.any(scoring_hand, PkmnDip.con.is_steel) then 
        steel_found = true
      end
    end
    card.joker_display_values.e_plus = steel_found and 1 or 0
  end,
}

-- Perrserker
jd_def["j_nacho_perrserker"] = {
  text = {
    { text = "+" },
    { ref_table = "card.joker_display_values", ref_value = "e_plus", retrigger_type = "mult" }
  },
  text_config = { colour = pokermon.colours.pink },
  calc_function = function(card)
    local count = 0
    local hand = next(G.play.cards) and G.play.cards or G.hand.highlighted
      local text, _, scoring_hand = JokerDisplay.evaluate_hand(hand)
      if text ~= "Unknown" then
        for _, scoring_card in pairs(scoring_hand) do
          if PkmnDip.con.is_steel(scoring_card) then
            count = count + 1
          end
        end
      end
    card.joker_display_values.e_plus = math.min(count, 3)
  end,
}

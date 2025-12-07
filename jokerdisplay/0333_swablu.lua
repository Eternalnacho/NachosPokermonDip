local jd_def = JokerDisplay.Definitions

-- Swablu
jd_def["j_nacho_swablu"] = {
  text = {
    { text = "+$" },
    { ref_table = "card.joker_display_values", ref_value = "money" },
  },
  reminder_text = {
    { ref_table = "card.joker_display_values", ref_value = "localized_text" },
  },
  text_config = { colour = G.C.GOLD },
  calc_function = function(card)
    local nine_tally = G.playing_cards and #PkmnDip.utils.filter(G.playing_cards, function(v) return v:get_id() == 9 end) or 0
    card.joker_display_values.money = nine_tally
    card.joker_display_values.localized_text = "(" .. localize("k_round") .. ")"
  end
}

-- Altaria
jd_def["j_nacho_altaria"] = {
  text = {
    { text = "+$" },
    { ref_table = "card.joker_display_values", ref_value = "money" },
  },
  reminder_text = {
    { ref_table = "card.joker_display_values", ref_value = "localized_text" },
  },
  text_config = { colour = G.C.GOLD },
  calc_function = function(card)
    local nine_tally = 0
    if G.playing_cards then
      local nines = PkmnDip.utils.filter(G.playing_cards, function(v) return v:get_id() == 9 end); nine_tally = #nines
      for k, v in pairs(nines) do
        if v.config.center ~= G.P_CENTERS.c_base then nine_tally = nine_tally + 1 end
      end
    end
    card.joker_display_values.money = nine_tally
    card.joker_display_values.localized_text = "(" .. localize("k_round") .. ")"
  end
}
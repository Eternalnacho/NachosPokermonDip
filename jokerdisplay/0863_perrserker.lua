local jd_def = JokerDisplay.Definitions

-- Galarian Meowth
jd_def["j_nacho_galarian_meowth"] = {
  retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
    return SMODS.has_enhancement(playing_card, 'm_steel') and joker_card.ability.extra.retriggers * JokerDisplay.calculate_joker_triggers(joker_card) or 0
  end
}

-- Perrserker
jd_def["j_nacho_perrserker"] = {
  text = {
      {
          border_nodes = {
              { text = "X" },
              { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" },
          },
      },
  },
  calc_function = function(card)
    local total_xmult = 1.5
    if G.jokers then
      local total_energy = 0
      PkmnDip.utils.for_each(SMODS.find_card('j_nacho_perrserker'), function(v) total_energy = total_energy + get_total_energy(v) end)
      total_xmult = total_xmult + total_xmult * .05 * total_energy
    end
    card.joker_display_values.x_mult = total_xmult
  end,
  retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
    return SMODS.has_enhancement(playing_card, 'm_steel') and joker_card.ability.extra.retriggers * JokerDisplay.calculate_joker_triggers(joker_card) or 0
  end
}
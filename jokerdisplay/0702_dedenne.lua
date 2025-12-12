local jd_def = JokerDisplay.Definitions

jd_def["j_nacho_dedenne"] = {
  text = {
    {ref_table = "card.joker_display_values", ref_value = "status", colour = G.C.GREY}
  },
  extra = {
    {
      { text = "(", colour = G.C.GREEN, scale = 0.3 },
      { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
      { text = ")", colour = G.C.GREEN, scale = 0.3 },
    },
  },
  calc_function = function(card)
    local playing_hand = next(G.play.cards)
    card.joker_display_values.status = "Not Active!"
    for _, playing_card in ipairs(G.hand.cards) do
      if playing_hand or not playing_card.highlighted then
        if playing_card.facing and not (playing_card.facing == 'back') and SMODS.has_enhancement(playing_card, 'm_gold') and not playing_card.debuff then
          card.joker_display_values.status = "Active!"
          break
        end
      end
    end
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, 'dedenne')
    card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { num, den } }
  end
}
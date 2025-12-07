local jd_def = JokerDisplay.Definitions

-- Piplup
jd_def["j_nacho_piplup"] = {
    text = {
        { text = "+",                              colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values",        ref_value = "chips", colour = G.C.CHIPS },
    },
    text_config = { colour = G.C.CHIPS },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        card.joker_display_values.chips = math.max(card.ability.extra.chips - #scoring_hand * 20, 0)
    end
}

-- Prinplup
jd_def["j_nacho_prinplup"] = {
    text = {
        { text = "+",                              colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values",        ref_value = "chips", colour = G.C.CHIPS },
    },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local total = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if playing_card.facing and not (playing_card.facing == 'back') and not SMODS.has_no_rank(playing_card) and not playing_card.debuff then
                    total = total + playing_card.base.nominal
                end
            end
        end
        card.joker_display_values.chips = total + card.ability.extra.chips
    end
}

-- Empoleon
jd_def["j_nacho_empoleon"] = {
    text = {
        { text = "+",                              colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values",        ref_value = "chips", colour = G.C.CHIPS },
    },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local total = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if playing_card.facing and not (playing_card.facing == 'back') and not SMODS.has_no_rank(playing_card) and not playing_card.debuff then
                    total = total + playing_card.base.nominal * 2
                end
            end
        end
        card.joker_display_values.chips = total + card.ability.extra.chips
    end
}
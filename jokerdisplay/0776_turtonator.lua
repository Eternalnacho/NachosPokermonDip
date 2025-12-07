local jd_def = JokerDisplay.Definitions

-- Turtonator
jd_def["j_nacho_turtonator"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" },
            },
        },
    },
    calc_function = function(card)
        local x_mult = 1
        if card.ability.extra.trapped then
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            for _, scoring_card in pairs(scoring_hand) do
                local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                x_mult = x_mult * (card.ability.extra.Xmult_mod ^ retriggers)
            end
        end
        card.joker_display_values.x_mult = x_mult
    end
}
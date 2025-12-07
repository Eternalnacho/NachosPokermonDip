local jd_def = JokerDisplay.Definitions

-- Ralts
jd_def["j_nacho_ralts"] = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
        local mult = 0
        for _, v in pairs(G.GAME.hands) do
          mult = mult + (v.level - 1) * card.ability.extra.mult_mod
        end
        card.joker_display_values.mult = mult
    end
}

-- Kirlia
jd_def["j_nacho_kirlia"] = {
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
        local mult = 0
        for _, v in pairs(G.GAME.hands) do
          mult = mult + (v.level - 1) * card.ability.extra.mult_mod
        end
        card.joker_display_values.mult = mult
    end
}

-- Gardevoir
jd_def["j_nacho_gardevoir"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" },
            },
        },
    },
    calc_function = function(card)
        local xmult = 1
        for _, v in pairs(G.GAME.hands) do
            xmult = xmult + (v.level - 1) * card.ability.extra.Xmult_mod
        end
        card.joker_display_values.Xmult = xmult
    end
}

-- Gallade
jd_def["j_nacho_gallade"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" },
            },
        },
    },
    calc_function = function(card)
        local text, _, _ = JokerDisplay.evaluate_hand()
        card.joker_display_values.Xmult = 1 + card.ability.extra.Xmult_mod * ((text ~= 'Unknown' and G.GAME and G.GAME.hands[text] and G.GAME.hands[text].played + (next(G.play.cards) and 0 or 1)) or 0)
    end
}

-- Mega Gallade
jd_def["j_nacho_mega_gallade"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" },
            },
        },
    },
    calc_function = function(card)
        local text, _, _ = JokerDisplay.evaluate_hand()
        card.joker_display_values.Xmult = 1 + card.ability.extra.Xmult_mod * ((text ~= 'Unknown' and G.GAME and G.GAME.hands[text] and G.GAME.hands[text].played + (next(G.play.cards) and 0 or 1)) or 0)
    end
}

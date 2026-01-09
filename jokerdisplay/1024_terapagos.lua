local jd_def = JokerDisplay.Definitions

-- Terapagos-Terastal
jd_def["j_nacho_terapagos_terastal"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" },
            },
        },
    },
    calc_function = function(card)
        local count = G.jokers and #PkmnDip.utils.filter(G.jokers.cards,
          function(v) return v.config.center.rarity and is_type(v, card.ability.extra.ptype) and v ~= card end) or 0
        card.joker_display_values.count = count
        card.joker_display_values.Xmult = 1 + count * card.ability.extra.Xmult_mod
        card.joker_display_values.localized_text = card.ability.extra.ptype
    end,
}

-- Terapagos-Stellar
jd_def["j_nacho_terapagos_stellar"] = {
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "count",          colour = G.C.ORANGE },
        { text = "x" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.GREEN },
        { text = ")" },
    },
    calc_function = function(card)
        local count = G.jokers and #PkmnDip.utils.filter(G.jokers.cards, function(v) return v.config.center.rarity and is_type(v, "Stellar") end) or 0
        card.joker_display_values.count = count
        card.joker_display_values.localized_text = "Stellar"
    end,
    mod_function = function(card, mod_joker)
        return { x_mult = (is_type(card, "Stellar") and (1 + mod_joker.ability.extra.Xmult_mod * get_total_energy(card)) ^ JokerDisplay.calculate_joker_triggers(mod_joker)) }
    end
}
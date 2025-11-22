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

--	Swablu
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

-- Bagon
jd_def["j_nacho_bagon"] = {
  text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  calc_function = function(card)
    local mult = 0
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
    if text == "Two Pair" then
        for _, scoring_card in pairs(scoring_hand) do
            local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
            mult = mult + (scoring_card.base.nominal / 3) * retriggers
        end
        card.joker_display_values.mult = mult
    else
        card.joker_display_values.mult = 0
    end
    card.joker_display_values.localized_text = localize('Two Pair', 'poker_hands')
  end
}

-- Shelgon
jd_def["j_nacho_shelgon"] = {
  text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  calc_function = function(card)
    local mult = 0
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
    if text == "Two Pair" then
        for _, scoring_card in pairs(scoring_hand) do
            local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
            mult = mult + (scoring_card.base.nominal / 2) * retriggers
        end
        card.joker_display_values.mult = mult
    else
        card.joker_display_values.mult = 0
    end
    card.joker_display_values.localized_text = localize('Two Pair', 'poker_hands')
  end
}

-- Salamence
jd_def["j_nacho_salamence"] = {
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
    local x_mult = 1
    local avg_rank = 0
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
    if G.playing_cards then
        for k, v in pairs(G.playing_cards) do
            avg_rank = v.base.nominal + avg_rank
        end
        avg_rank = avg_rank / #G.playing_cards
    end
    if text == 'Two Pair' then
      for _, scoring_card in pairs(scoring_hand) do
        local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
        x_mult = x_mult * (1 + card.ability.extra.Xmult * avg_rank) ^ (retriggers)
      end
    end
    card.joker_display_values.localized_text = localize('Two Pair', 'poker_hands')
    card.joker_display_values.x_mult = x_mult
  end,
}

-- Mega Salamence
jd_def["j_nacho_mega_salamence"] = {
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
    local x_mult = 1
    local text, _, scoring_hand = JokerDisplay.evaluate_hand()
    if text == 'Two Pair' then
      for _, scoring_card in pairs(scoring_hand) do
        local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
        x_mult = x_mult * (card.ability.extra.Xmult ^ (retriggers))
      end
    end
    card.joker_display_values.localized_text = localize('Two Pair', 'poker_hands')
    card.joker_display_values.x_mult = x_mult
  end,
  retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
    if held_in_hand then
        return 0
    elseif playing_card:get_id() > 9 then
        return (joker_card.ability.extra.retriggers * JokerDisplay.calculate_joker_triggers(joker_card)) or 0
    else return 0 end
end,
}

-- Chimchar
jd_def["j_nacho_chimchar"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
}

-- Monferno
jd_def["j_nacho_monferno"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
}

-- Infernape
jd_def["j_nacho_infernape"] = {
    text = {
        { text = "+" ,
        colour = G.C.MULT},
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult", 
        colour = G.C.MULT},
        {text = " "},
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Ymult", retrigger_type = "exp" },
            },
        },
    },
}

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

-- Audino
jd_def["j_nacho_audino"] = {
  text = {
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "exp" },
      },
    },
  },
}

-- Mega Audino
jd_def["j_nacho_mega_audino"] = {
  text = {
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "exp" },
      },
    },
  },
}

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

-- Skwovet
jd_def["j_nacho_skwovet"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
}

-- Greedent
jd_def["j_nacho_greedent"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
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
        return { x_mult = (is_type(card, "Stellar") and (1 + mod_joker.ability.extra.Xmult_mod * get_total_energy(card)) ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
    end
}
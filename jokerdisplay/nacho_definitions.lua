local jd_def = JokerDisplay.Definitions



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

jd_def["j_nacho_bagon"] = {
  text = {
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" },
      },
    },
  },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  calc_function = function(card)
    local text, _, _ = JokerDisplay.evaluate_hand()
    if text == "Two Pair" then
      card.joker_display_values.Xmult = card.ability.extra.Xmult
    else
      card.joker_display_values.Xmult = 1
    end
    card.joker_display_values.localized_text = localize('Two Pair', 'poker_hands')
  end
}

jd_def["j_nacho_shelgon"] = {
  text = {
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" },
      },
    },
  },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  calc_function = function(card)
    local text, _, _ = JokerDisplay.evaluate_hand()
    if text == "Two Pair" then
      card.joker_display_values.Xmult = card.ability.extra.Xmult
    else
      card.joker_display_values.Xmult = 1
    end
    card.joker_display_values.localized_text = localize('Two Pair', 'poker_hands')
  end
}

jd_def["j_nacho_salamence"] = {
  text = {
    {
      border_nodes = {
        { text = "X" },
        { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" },
      },
    },
  },
  reminder_text = {
    { text = "(" },
    { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
    { text = ")" },
  },
  calc_function = function(card)
    local text, _, _ = JokerDisplay.evaluate_hand()
    if text == "Two Pair" then
      card.joker_display_values.Xmult = card.ability.extra.Xmult
    else
      card.joker_display_values.Xmult = 1
    end
    card.joker_display_values.localized_text = localize('Two Pair', 'poker_hands')
  end
}

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

jd_def["j_nacho_chimchar"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
}

jd_def["j_nacho_monferno"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
}


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

jd_def["j_nacho_gallade"] = {
    text = {
        { text = "+" ,
        colour = G.C.MULT},
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", 
        colour = G.C.MULT},
        {text = " "},
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" },
            },
        },
    },
    calc_function = function(card)
        local text, _, _ = JokerDisplay.evaluate_hand()
        card.joker_display_values.mult = card.ability.extra.mult_mod * ((text ~= 'Unknown' and G.GAME and G.GAME.hands[text] and G.GAME.hands[text].played + (next(G.play.cards) and 0 or 1)) or 0)
        card.joker_display_values.Xmult = 1 + card.ability.extra.Xmult_mod * ((text ~= 'Unknown' and G.GAME and G.GAME.hands[text] and G.GAME.hands[text].played + (next(G.play.cards) and 0 or 1)) or 0)
    end
}

jd_def["j_nacho_mega_gallade"] = {
    text = {
        { text = "+" ,
        colour = G.C.MULT},
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", 
        colour = G.C.MULT},
        {text = " "},
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" },
            },
        },
    },
    calc_function = function(card)
        local text, _, _ = JokerDisplay.evaluate_hand()
        card.joker_display_values.mult = card.ability.extra.mult_mod * ((text ~= 'Unknown' and G.GAME and G.GAME.hands[text] and G.GAME.hands[text].played + (next(G.play.cards) and 0 or 1)) or 0)
        card.joker_display_values.Xmult = 1 + card.ability.extra.Xmult_mod * ((text ~= 'Unknown' and G.GAME and G.GAME.hands[text] and G.GAME.hands[text].played + (next(G.play.cards) and 0 or 1)) or 0)
    end
}

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

jd_def["j_nacho_skwovet"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
}

jd_def["j_nacho_greedent"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
}

jd_def["j_nacho_perrserker"] = {
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "count",          colour = G.C.ORANGE },
        { text = "x" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.GREEN },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        if G.jokers then
            for _, joker_card in ipairs(G.jokers.cards) do
                if joker_card.config.center.rarity and is_type(joker_card, "Metal") then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.count = count
        card.joker_display_values.localized_text = "Metal"
    end,
    mod_function = function(card, mod_joker)
        local count = 0
        local all_metal = 1
        if G.jokers then
            for _, joker_card in ipairs(G.jokers.cards) do
                if joker_card.config.center.rarity and is_type(joker_card, "Metal") then
                    count = count + 1
                end
            end
            if count == #G.jokers.cards then
                all_metal = 2
            end
        end
        return { x_mult = (is_type(card, "Metal") and (mod_joker.ability.extra.Ymult ^ all_metal) ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
    end
}

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

jd_def["j_nacho_terapagos_terastal"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "exp" },
            },
        },
    },
}

jd_def["j_nacho_terapagos_stellar"] = {
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "count",          colour = G.C.ORANGE },
        { text = "x" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.GREEN },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        if G.jokers then
            for _, joker_card in ipairs(G.jokers.cards) do
                if joker_card.config.center.rarity and is_type(joker_card, "Stellar") then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.count = count
        card.joker_display_values.localized_text = "Stellar"
    end,
    mod_function = function(card, mod_joker)
        local count = 0
        if G.jokers then
            for _, joker_card in ipairs(G.jokers.cards) do
                if joker_card.config.center.rarity and is_type(joker_card, "Stellar") then
                    count = count + 1
                end
            end
        end
        return { x_mult = (is_type(card, "Stellar") and (1 + mod_joker.ability.extra.Xmult_mod * get_total_energy(card)) ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
    end
}
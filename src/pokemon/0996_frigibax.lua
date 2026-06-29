-- Frigibax 996
local frigibax = {
  name = "frigibax",
  config = { extra = {}, evo_rqmt = 9 },
  loc_vars = function(self, info_queue, card)
    local foil_count = G.playing_cards and G.STAGE == G.STAGES.RUN and #PkmnDip.utils.filter(G.playing_cards, function(card) return (card.edition and card.edition.foil) end) or 0
    local deck_data = G.playing_cards and G.STAGE == G.STAGES.RUN and '['..tostring(foil_count)..'/'..card.ability.evo_rqmt..'] ' or card.ability.evo_rqmt..' '
    return { vars = { deck_data } }
  end,
  designer = "king_alloy, roxie",
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Dragon",
  gen = 9,
  pseudol = true,
  nacho_pseudol = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.scoring_hand then
      local card_count = #PkmnDip.utils.filter(context.scoring_hand, function(pcard) return pokermon.total_mult(pcard) > 0 end)
      if context.before and context.cardarea == G.jokers then
        -- Five of a Kind gives held cards foil
        if context.scoring_name == "Five of a Kind" then
          for _, v in pairs(G.hand.cards) do v:set_edition({foil = true}, true, true) end
          play_sound('foil2', 0.5, 0.4)
        end
        -- Scoring mult cards give *a* card in deck foil
        if card_count > 0 then
          local viable_targets = PkmnDip.utils.filter(G.deck.cards, function(pcard) return not (pcard.edition and pcard.edition.foil) end)
          local target = pseudorandom_element(viable_targets, pseudoseed('frigibax'))
          if target then target:set_edition({foil = true}, true) end
        end
      end
    end
    return pokermon.edition_evo(self, card, context, "j_nacho_arctibax", 'foil', nil, card.ability.evo_rqmt)
  end,
  attributes = {"hand_type", "editions", "full_deck", "condition_evo"}
}

-- Arctibax 997
local arctibax = {
  name = "arctibax",
  config = { extra = { }, evo_rqmt = 18 },
  loc_vars = function(self, info_queue, card)
    local foil_count = G.playing_cards and G.STAGE == G.STAGES.RUN and #PkmnDip.utils.filter(G.playing_cards, function(card) return (card.edition and card.edition.foil) end) or 0
    local deck_data = G.playing_cards and G.STAGE == G.STAGES.RUN and '['..tostring(foil_count)..'/'..card.ability.evo_rqmt..'] ' or card.ability.evo_rqmt..' '
    return { vars = { deck_data } }
  end,
  designer = "king_alloy, roxie",
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Dragon",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.scoring_hand then
      local has_mult = 0
      local is_rank
      for _, v in pairs(context.scoring_hand) do
        if pokermon.total_mult(v) > 0 and not is_rank then has_mult = has_mult + 1; is_rank = v:get_id()
        elseif pokermon.total_mult(v) > 0 and v:get_id() == is_rank then has_mult = has_mult + 1 end
      end
      if context.before and context.cardarea == G.jokers then
        -- Five of a Kind gives held cards foil
        if context.scoring_name == "Five of a Kind" then
          for _, v in pairs(G.hand.cards) do
            v:set_edition({foil = true}, true, true)
          end
          play_sound('foil2', 0.5, 0.4)
        end
        -- Scoring mult cards with the same rank give cards in deck foil
        if has_mult > 0 then
          for _ = 1, has_mult do
            local viable_targets = PkmnDip.utils.filter(G.deck.cards, function(card) return not (card.edition and card.edition.foil) end)
            local target = pseudorandom_element(viable_targets, pseudoseed('arctibax'))
            if target then target:set_edition({foil = true}, true) end
          end
        end
      end
    end
    return pokermon.edition_evo(self, card, context, "j_nacho_baxcalibur", 'foil', nil, card.ability.evo_rqmt)
  end,
  attributes = {"hand_type", "editions", "full_deck", "condition_evo"}
}

-- Baxcalibur 998
local baxcalibur = {
  name = "baxcalibur",
  config = { extra = { Xmult_multi = 0.03 } },
  loc_vars = function(self, info_queue, card)
    local foil_count = G.playing_cards and #PkmnDip.utils.filter(G.playing_cards, function(v) return v.edition and v.edition.foil end) or 0
    return { vars = { card.ability.extra.Xmult_multi, 1 + card.ability.extra.Xmult_multi * foil_count } }
  end,
  designer = "king_alloy, roxie",
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Dragon",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Scoring cards with Mult gain Foil
    if context.before and context.cardarea == G.jokers and not context.blueprint then
      local converted
      for _, v in pairs(G.play.cards) do
        if pokermon.total_mult(v) > 0 then
          v:set_edition({foil = true}, true, true)
          converted = true
        end
      end
      if converted then play_sound('foil2', 0.5, 0.4) end
    end
    -- Five of a Kinds go stoopid
    if context.scoring_hand and context.scoring_name == "Five of a Kind" and not card.ability.extra.disabled then
      if context.individual and context.cardarea == G.play then
        local foil_count = #PkmnDip.utils.filter(G.playing_cards, function(v) return (v.edition and v.edition.foil) end)
        return {
          Xmult = 1 + card.ability.extra.Xmult_multi * foil_count
        }
      end
    end
  end,
  attributes = {"hand_type", "editions", "full_deck", "xmult"}
}

return {
  config_key = "frigibax",
  list = { frigibax, arctibax, baxcalibur }
}

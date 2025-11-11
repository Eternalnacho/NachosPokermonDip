-- Frigibax 996
local frigibax = {
  name = "frigibax",
  config = { extra = {}, evo_rqmt = 9 },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local deck_data = card.ability.evo_rqmt..' '
    if G.playing_cards then
      local foil_count = 0
      for k, v in pairs(G.playing_cards) do
        if v.edition and v.edition.foil then foil_count = foil_count + 1 end
      end
      deck_data = '['..tostring(foil_count)..'/'..card.ability.evo_rqmt..'] '
    end
    return { vars = { deck_data } }
  end,
  designer = "king_alloy, roxie",
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Dragon",
  gen = 9,
  pseudol = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.scoring_hand then
      local has_mult = 0
      for k, v in pairs(context.scoring_hand) do
        if poke_total_mult(v) > 0 then has_mult = has_mult + 1 end
      end
      if context.before and context.cardarea == G.jokers then
        -- Five of a Kind gives held cards foil
        if context.scoring_name == "Five of a Kind" then
          for k, v in pairs(G.hand.cards) do
            v:set_edition({foil = true}, true)
          end
        end
        -- Scoring mult cards give *a* card in deck foil
        if has_mult > 0 then
          local viable_targets = {}
          for k, v in pairs(G.deck.cards) do
            if not (v.edition and v.edition.foil) then viable_targets[#viable_targets+1] = v end
          end
          local target = pseudorandom_element(viable_targets, pseudoseed('frigibax'))
          if target then target:set_edition({foil = true}, true) end
        end
      end
    end
    return edition_evo(self, card, context, "j_nacho_arctibax", 'foil', nil, card.ability.evo_rqmt)
  end,
}

-- Arctibax 997
local arctibax = {
  name = "arctibax",
  config = { extra = { }, evo_rqmt = 18 },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local deck_data = card.ability.evo_rqmt..' '
    if G.playing_cards then
      local foil_count = 0
      for k, v in pairs(G.playing_cards) do
        if v.edition and v.edition.foil then foil_count = foil_count + 1 end
      end
      deck_data = '['..tostring(foil_count)..'/'..card.ability.evo_rqmt..'] '
    end
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
      for k, v in pairs(context.scoring_hand) do
        if poke_total_mult(v) > 0 and not is_rank then has_mult = has_mult + 1; is_rank = v:get_id()
        elseif poke_total_mult(v) > 0 and v:get_id() == is_rank then has_mult = has_mult + 1 end
      end
      if context.before and context.cardarea == G.jokers then
        -- Five of a Kind gives held cards foil
        if context.scoring_name == "Five of a Kind" then
          for k, v in pairs(G.hand.cards) do
            v:set_edition({foil = true}, true)
          end
        end
        -- Scoring mult cards with the same rank give cards in deck foil
        if has_mult > 0 then
          for i = 1, has_mult do
            local viable_targets = {}
            for k, v in pairs(G.deck.cards) do
              if not (v.edition and v.edition.foil) then viable_targets[#viable_targets+1] = v end
            end
            local target = pseudorandom_element(viable_targets, pseudoseed('arctibax'))
            if target then target:set_edition({foil = true}, true) end
          end
        end
      end
    end
    return edition_evo(self, card, context, "j_nacho_baxcalibur", 'foil', nil, card.ability.evo_rqmt)
  end,
}

-- Baxcalibur 998
local baxcalibur = {
  name = "baxcalibur",
  config = { extra = { Xmult_multi = 0.03 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local foil_count = 0
    if G.playing_cards then
      for k, v in pairs(G.playing_cards) do
        if v.edition and v.edition.foil then foil_count = foil_count + 1 end
      end
    end
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
      for k, v in pairs(G.play.cards) do
        if poke_total_mult(v) > 0 then v:set_edition({foil = true}, true) end
      end
    end
    -- Five of a Kinds go stoopid
    if context.scoring_hand and context.scoring_name == "Five of a Kind" and not card.ability.extra.disabled then
      if context.individual and context.cardarea == G.play then
        local foil_count = 0
        for k, v in pairs(G.playing_cards) do
          if v.edition and v.edition.foil then foil_count = foil_count + 1 end
        end
        return {
          Xmult = 1 + card.ability.extra.Xmult_multi * foil_count
        }
      end
    end
  end,
}

return {
  name = "Nacho's Frigibax Evo Line",
  enabled = nacho_config.frigibax or false,
  list = { frigibax, arctibax, baxcalibur }
}

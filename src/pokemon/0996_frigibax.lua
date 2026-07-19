local filter = PkmnDip.utils.filter
local for_each = PkmnDip.utils.for_each

local set_foil = function(card) card:set_edition({foil = true}, true, true) end
local foil_sound = function() local f = G.P_CENTERS['e_foil'].sound; play_sound(f.sound, f.per, f.vol) end
local has_mult = function(card) return PkmnDip.calc.get_mult(card) > 0 end
local thermal_exchange = function(cards, con)
  for _, c in ipairs(cards) do
    if has_mult(c) and con > 0 then
      set_foil(c); con = con - 1
    end
  end
  if con == 0 then PkmnDip.defer(foil_sound) end
end

-- Frigibax 996
local frigibax = {
  name = "frigibax",
  config = { extra = {}, evo_rqmt = 9 },
  loc_vars = function(self, info_queue, card)
    local deck_data
    if G.playing_cards and G.STAGE == G.STAGES.RUN then
      local foil_count = #filter(G.playing_cards, PkmnDip.con.is_foil)
      deck_data = '['.. foil_count .. '/' .. card.ability.evo_rqmt ..']' .. ' '
    else
      deck_data = card.ability.evo_rqmt .. ' '
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
  nacho_pseudol = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before then
      -- Five of a Kind gives held cards foil
      if context.scoring_name == "Five of a Kind" then
        for_each(G.hand.cards, set_foil)
        PkmnDip.defer(foil_sound)
      end
      -- First scoring card with mult becomes foil
      local bax_calc = function() thermal_exchange(context.scoring_hand, 1) end
      PkmnDip.RNG_protect(bax_calc)
    end
    return pokermon.edition_evo(self, card, context, "j_nacho_arctibax", 'foil', nil, card.ability.evo_rqmt)
  end,
  attributes = {"hand_type", "editions", "full_deck", "condition_evo"}
}

-- Arctibax 997
local arctibax = {
  name = "arctibax",
  config = { extra = {}, evo_rqmt = 18 },
  loc_vars = function(self, info_queue, card)
    local deck_data
    if G.playing_cards and G.STAGE == G.STAGES.RUN then
      local foil_count = tostring( #filter(G.playing_cards, PkmnDip.con.is_foil) )
      deck_data = '[' .. foil_count .. '/' .. card.ability.evo_rqmt .. ']' .. ' '
    else
      deck_data = card.ability.evo_rqmt .. ' '
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
    if context.before then
      -- Five of a Kind gives held cards foil
      if context.scoring_name == "Five of a Kind" then
        for_each(G.hand.cards, set_foil)
        PkmnDip.defer(foil_sound)
      end
      -- First two scoring cards with mult become foil
      local bax_calc = function() thermal_exchange(context.scoring_hand, 2) end
      PkmnDip.RNG_protect(bax_calc)
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
    local a = card.ability.extra or self.config.extra
    local foil_count = G.playing_cards and #filter(G.playing_cards, PkmnDip.con.is_foil) or 0
    return { vars = { a.Xmult_multi, 1 + a.Xmult_multi * foil_count } }
  end,
  designer = "king_alloy, roxie",
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Dragon",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and not context.blueprint then
      -- We have to do this rng state bullshit because of lucky cards
      local bax_calc = function() for_each(context.scoring_hand, function(c) thermal_exchange({c}, 1) end) end
      PkmnDip.RNG_protect(bax_calc)
    end
    -- Five of a Kinds go stoopid
    if context.individual and context.cardarea == G.play and context.scoring_name == "Five of a Kind" then
      local foil_count = #filter(G.playing_cards, PkmnDip.con.is_foil)
      return { Xmult = 1 + card.ability.extra.Xmult_multi * foil_count }
    end
  end,
  megas = {'mega_baxcalibur'},
  attributes = {"hand_type", "editions", "full_deck", "xmult"}
}

-- Mega Baxcalibur 998-1
local mega_baxcalibur = {
  name = "mega_baxcalibur",
  pos = { x = 8, y = 7 },
  soul_pos = { x = 9, y = 7 },
  config = { extra = { Xmult_multi = 0.05 } },
  loc_vars = function(self, info_queue, card)
    local a = card.ability.extra or self.config.extra
    local foil_count = G.playing_cards and #filter(G.playing_cards, PkmnDip.con.is_foil) or 0
    return { vars = { a.Xmult_multi, 1 + a.Xmult_multi * foil_count } }
  end,
  rarity = "poke_mega",
  cost = 14,
  stage = "Mega",
  ptype = "Dragon",
  atlas = "AtlasJokersBasicGen09",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.before and context.main_eval then
      PkmnDip.RNG_protect(function()
        for _, c in ipairs(context.scoring_hand) do 
          if PkmnDip.calc.get_mult(c) > 0 then return end
        end
        a.no_score = true
        PkmnDip.eff.faint(card)
      end)
    end

    -- Foil cards go even stoopider (but only sometimes)
    if context.individual and context.cardarea == G.play and not a.no_score
        and PkmnDip.con.is_foil(context.other_card) then
      local foil_count = #filter(G.playing_cards, PkmnDip.con.is_foil)
      return { Xmult = 1 + a.Xmult_multi * foil_count }
    end

    if context.after and not context.blueprint then
      a.no_score = nil
      if card.debuff then PkmnDip.eff.faint(card, true) end
    end
  end,
  megas = {'mega_baxcalibur'},
  attributes = {"hand_type", "editions", "full_deck", "xmult"}
}

return {
  config_key = "frigibax",
  list = { frigibax, arctibax, baxcalibur, mega_baxcalibur }
}
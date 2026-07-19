local not_edition = function(card, e) return not card.edition or (card.edition and not card.edition[e]) end

-- Clauncher 692
local clauncher = {
  name = "clauncher",
  config = { extra = { retriggers = 1, played_editions = {}, held_editions = {}, rounds = 4 } },
  loc_vars = function(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      if not_edition(card, 'polychrome') then info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome end
      if not_edition(card, 'foil') then info_queue[#info_queue+1] = G.P_CENTERS.e_foil end
      if not_edition(card, 'holo') then info_queue[#info_queue+1] = G.P_CENTERS.e_holo end
    end
    return { vars = { card.ability.extra.rounds } }
  end,
  rarity = 1,
  cost = 5,
  stage = "Basic",
  ptype = "Water",
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    -- Retriggers all the unique editions (played and held counted separately)
    if PkmnDip.con.has_repeat_effect(context) and PkmnDip.con.played_or_held(context) and context.other_card.edition then
      local other = context.other_card
      -- Played unique editions
      if context.cardarea == G.play and not a.played_editions[other.edition.key] then
        a.played_editions[other.edition.key] = true
        return { repetitions = card.ability.extra.retriggers }
      end
      -- Held unique editions
      if context.cardarea == G.hand and not a.held_editions[other.edition.key] then
        a.held_editions[other.edition.key] = true
        return { repetitions = card.ability.extra.retriggers }
      end
    end
    -- Reset after calculating individual and at the beginning of round for end-of-round effects
    if (context.joker_main or context.setting_blind) and not context.blueprint then
      a.played_editions = {}
      a.held_editions = {}
    end
    return pokermon.level_evo(self, card, context, "j_nacho_clawitzer")
  end,
  in_pool = function(self, args)
    local has_edition = function(pcard) return pcard.edition end
    return G.playing_cards and PkmnDip.utils.any(G.playing_cards, has_edition)
  end,
  attributes = {"editions", "retrigger", "round_evo"}
}

-- Clawitzer 693
local clawitzer = {
  name = "clawitzer",
  config = { extra = { retriggers = 1 } },
  loc_vars = function(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      if not_edition(card, 'polychrome') then info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome end
      if not_edition(card, 'foil') then info_queue[#info_queue+1] = G.P_CENTERS.e_foil end
      if not_edition(card, 'holo') then info_queue[#info_queue+1] = G.P_CENTERS.e_holo end
    end
    return { vars = {} }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Water",
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
    if PkmnDip.con.has_repeat_effect(context) and PkmnDip.con.played_or_held(context) and context.other_card.edition then
      return { repetitions = card.ability.extra.retriggers }
    end
  end,
  in_pool = function(self, args)
    local has_edition = function(pcard) return pcard.edition end
    return G.playing_cards and PkmnDip.utils.any(G.playing_cards, has_edition)
  end,
  attributes = {"editions", "retrigger"}
}

return {
  config_key = "clauncher",
  list = { clauncher, clawitzer }
}

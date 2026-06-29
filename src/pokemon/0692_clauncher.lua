-- Clauncher 692
local clauncher = {
  name = "clauncher",
  config = {extra = {retriggers = 1, editions = {}, rounds = 4}},
  loc_vars = function(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      if not card.edition or (card.edition and not card.edition.polychrome) then
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
      end
      if not card.edition or (card.edition and not card.edition.foil) then
        info_queue[#info_queue+1] = G.P_CENTERS.e_foil
      end
      if not card.edition or (card.edition and not card.edition.holo) then
        info_queue[#info_queue+1] = G.P_CENTERS.e_holo
      end
    end
    return {vars = {card.ability.extra.rounds}}
  end,
  rarity = 1,
  cost = 5,
  stage = "Basic",
  ptype = "Water",
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
    -- Retriggers all the unique editions
    if context.repetition and (context.cardarea == G.play or context.cardarea == G.hand)
        and (next(context.card_effects[1]) or #context.card_effects > 1) and context.other_card.edition
        and not card.ability.extra.scored_editions[context.other_card.edition.key] then
      card.ability.extra.scored_editions[context.other_card.edition.key] = true
      return {
        message = localize('k_again_ex'),
        repetitions = card.ability.extra.retriggers,
        card = card
      }
    end
    -- Resets the table of scored editions between played cards and held cards
    if context.repetition and context.cardarea == G.play and not context.blueprint then
      if context.other_card == G.play.cards[#G.play.cards] then
        card.ability.extra.scored_editions = {}
      end
    end
    -- Resets the table of scored editions after a hand is scored and before the first hand is calculated
    if (context.joker_main or context.setting_blind) and not context.blueprint then
      if card.ability.extra.scored_editions ~= {} then
        card.ability.extra.scored_editions = {}
      end
    end
    return pokermon.level_evo(self, card, context, "j_nacho_clawitzer")
  end,
  in_pool = function(self, args)
    return G.playing_cards and #PkmnDip.utils.filter(G.playing_cards, function(pcard) return pcard.edition end) > 0
  end,
  attributes = {"editions", "retrigger", "round_evo"}
}

-- Clawitzer 693
local clawitzer = {
  name = "clawitzer",
  config = {extra = {retriggers = 1}},
  loc_vars = function(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      if not card.edition or (card.edition and not card.edition.polychrome) then
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
      end
      if not card.edition or (card.edition and not card.edition.foil) then
        info_queue[#info_queue+1] = G.P_CENTERS.e_foil
      end
      if not card.edition or (card.edition and not card.edition.holo) then
        info_queue[#info_queue+1] = G.P_CENTERS.e_holo
      end
    end
    return {vars = {}}
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Water",
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
    if context.repetition and (context.cardarea == G.hand or context.cardarea == G.play) and
        (next(context.card_effects[1]) or #context.card_effects > 1) and context.other_card.edition then
      return {
        message = localize('k_again_ex'),
        repetitions = card.ability.extra.retriggers,
        card = card
      }
    end
  end,
  in_pool = function(self, args)
    return G.playing_cards and #PkmnDip.utils.filter(G.playing_cards, function(pcard) return pcard.edition end) > 0
  end,
  attributes = {"editions", "retrigger"}
}

return {
  config_key = "clauncher",
  list = { clauncher, clawitzer }
}

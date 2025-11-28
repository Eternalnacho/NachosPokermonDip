-- Clauncher 692
local clauncher = {
  name = "clauncher",
  config = {extra = {retriggers = 1, editions = {}, rounds = 4}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
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
  designer = "Eternalnacho",
  rarity = 1,
  cost = 5,
  stage = "Basic",
  ptype = "Water",
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
    -- Retriggers all the unique editions
    if context.repetition and (context.cardarea == G.play or context.cardarea == G.hand) and context.other_card.edition and
        (next(context.card_effects[1]) or #context.card_effects > 1) then
      if not PkmnDip.utils.contains(card.ability.extra.editions, context.other_card.edition.key) then
        if not context.blueprint then
          card.ability.extra.editions[#card.ability.extra.editions+1] = context.other_card.edition.key
        end
        return {
          message = localize('k_again_ex'),
          repetitions = card.ability.extra.retriggers,
          card = card
        }
      end
    end
    -- Resets the table of scored editions between played cards and held cards
    if context.repetition and context.cardarea == G.play and not context.blueprint then
      if context.other_card == G.play.cards[#G.play.cards] then
        if card.ability.extra.editions ~= {} then
          for i = 1, #card.ability.extra.editions do table.remove(card.ability.extra.editions) end
        end
      end
    end
    -- Resets the table of scored editions after a hand is scored and before the first hand is calculated
    if (context.joker_main or context.setting_blind) and not context.blueprint then
      if card.ability.extra.editions ~= {} then
        for i = 1, #card.ability.extra.editions do table.remove(card.ability.extra.editions) end
      end
    end
    return level_evo(self, card, context, "j_nacho_clawitzer")
  end,
  in_pool = function(self, args)
    if G.playing_cards then
      for k, v in pairs(G.playing_cards) do
        if v.edition and (v.edition.foil or v.edition.holographic or v.edition.polychrome) then return true end
      end
    end
    return false
  end,
}

-- Clawitzer 693
local clawitzer = {
  name = "clawitzer",
  config = {extra = {retriggers = 1}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
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
  designer = "Eternalnacho",
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
    if G.playing_cards then
      for k, v in pairs(G.playing_cards) do
        if v.edition and (v.edition.foil or v.edition.holographic or v.edition.polychrome) then return pokemon_in_pool(self) end
      end
    end
    return false
  end,
}

return {
  name = "Nacho's Clauncher Evo Line",
  enabled = nacho_config.clauncher or false,
  list = { clauncher, clawitzer }
}

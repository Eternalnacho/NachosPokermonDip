-- Snover 459
local snover = {
  name = "snover",
  config = {extra = {money_mod = 2, triggered = false}},
  loc_vars = function(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = G.P_CENTERS.m_glass
    end
    local deck_data = ''
    if G.playing_cards then
      local enhance_count = #PkmnDip.utils.filter(G.playing_cards, function(v) return SMODS.has_enhancement(v, 'm_glass') end)
      deck_data = '['..tostring(enhance_count)..'/'..tostring(math.ceil(#G.playing_cards/8))..'] '
    end
		return {vars = {card.ability.extra.money_mod, deck_data}}
  end,
  designer = "CBMX",
  rarity = 1,
  cost = 4,
  enhancement_gate = 'm_glass',
  stage = "Basic",
  ptype = "Grass",
  gen = 4,
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Check if first glass card breaks, then convert an unenhanced card in deck to glass
    if context.remove_playing_cards and not card.ability.extra.triggered then
      local glass_cards = #PkmnDip.utils.filter(context.removed, function(v) return v.shattered end)
      if glass_cards > 0 then
        local viable_targets = PkmnDip.utils.filter(G.deck.cards, PkmnDip.con.is_base)
        local target = pseudorandom_element(viable_targets, pseudoseed('snover'))
        pokermon.convert_cards(target, {mod_conv = 'm_glass'}, true, true)
        SMODS.calculate_effect({ message = localize('poke_ice_shard_ex') }, card)
        card.ability.extra.triggered = true
      end
    end

    -- Earn money when glass is scored
    if context.individual and context.cardarea == G.play and context.main_scoring
        and PkmnDip.con.is_glass(context.other_card) then
      local earned = pokermon.ease_poke_dollars(card, "snover", card.ability.extra.money_mod, true)
      return { dollars = earned, card = card }
    end
    -- Reset trigger at end of round
    if context.end_of_round then card.ability.extra.triggered = false end

    return pokermon.deck_enhance_evo(self, card, context, "j_nacho_abomasnow", "Glass", .125)
  end,
  attributes = {"enhancements", "economy", "modify_card", "condition_evo"},
}

-- Abomasnow 460
local abomasnow = {
  name = "abomasnow",
  config = {extra = {money_mod = 3}},
  loc_vars = function(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = G.P_CENTERS.m_glass
    end
    return {vars = {card.ability.extra.money_mod}}
  end,
  designer = "CBMX",
  rarity = 2,
  cost = 7,
  enhancement_gate = 'm_glass',
  stage = "One",
  ptype = "Grass",
  gen = 4,
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Check if glass card breaks, then convert an unenhanced card in deck to glass
    if context.remove_playing_cards then
      local glass_cards = #PkmnDip.utils.filter(context.removed, function(v) return v.shattered end)
      if glass_cards > 0 then
        local targets = {}
        local viable_targets = PkmnDip.utils.filter(G.deck.cards, PkmnDip.con.is_base)
        pseudoshuffle(viable_targets, pseudoseed('abomasnow'))
        table.move(viable_targets, 1, glass_cards, 1, targets)
        pokermon.convert_cards(targets, {mod_conv = 'm_glass', edition = "e_foil"}, true, true)
        SMODS.calculate_effect({ message = localize('poke_ice_shard_ex') }, card)
      end
    end

    -- Earn money when glass is scored
    if context.individual and context.cardarea == G.play and context.main_scoring
        and PkmnDip.con.is_glass(context.other_card) then
      local earned = pokermon.ease_poke_dollars(card, "snover", card.ability.extra.money_mod, true)
      return { dollars = earned, card = card }
    end
  end,
  megas = {"mega_abomasnow"},
  attributes = {"enhancements", "editions", "economy", "modify_card"},
}

-- Mega Abomasnow 460-1
local mega_abomasnow={
  name = "mega_abomasnow",
  config = {extra = {money_mod = 20}},
  loc_vars = function(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = G.P_CENTERS.m_glass
    end
    return {vars = {card.ability.extra.money_mod}}
  end,
  designer = "CBMX",
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Water",
  gen = 4,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.remove_playing_cards then
      local glass_cards = #PkmnDip.utils.filter(context.removed, function(v) return v.shattered end)
      if glass_cards > 0 then
        local earned = pokermon.ease_poke_dollars(card, "snover", card.ability.extra.money_mod * glass_cards, true)
        return {
          dollars = earned,
          card = card
        }
      end
    end
  end,
  attributes = {"enhancements", "economy"},
}

return {
  config_key = "snover",
  list = { snover, abomasnow, mega_abomasnow }
}

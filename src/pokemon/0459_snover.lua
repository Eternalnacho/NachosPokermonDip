-- Snover 459
local snover = {
  name = "snover",
  config = {extra = {money_mod = 2, triggered = false}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local deck_data = ''
    if G.playing_cards then
      local enhance_count = 0
      for k, v in pairs(G.playing_cards) do
        if SMODS.has_enhancement(v, 'm_glass') then enhance_count = enhance_count  + 1 end
      end
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
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
    local a = card.ability.extra

    -- Check if first glass card breaks, then convert an unenhanced card in deck to glass
    if context.remove_playing_cards then
      local glass_cards = 0
      for _, removed_card in ipairs(context.removed) do
        if removed_card.shattered then glass_cards = glass_cards + 1 end
      end
      if glass_cards > 0 and not a.triggered then
        local viable_targets = {}
        for k, v in pairs(G.playing_cards) do
          if v.config.center == G.P_CENTERS.c_base then viable_targets[#viable_targets+1] = v end
        end
        local target = pseudorandom_element(viable_targets, pseudoseed('snover'))
        poke_convert_cards_to(target, {mod_conv = 'm_glass'}, true, true)
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('poke_ice_shard_ex')})
        a.triggered = true
      end
    end

    -- Earn money when glass is scored
    if context.individual and not context.end_of_round and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_glass') then
      local earned = ease_poke_dollars(card, "snover", a.money_mod, true)
      return {
        dollars = earned,
        card = card
      }
    end

    -- Reset trigger at end of round
    if context.end_of_round then
      a.triggered = false
    end
    return deck_enhance_evo(self, card, context, "j_nacho_abomasnow", "Glass", .125)
  end,
}

-- Abomasnow 460
local abomasnow = {
  name = "abomasnow",
  config = {extra = {money_mod = 3}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.money_mod}}
  end,
  designer = "CBMX",
  rarity = 2,
  cost = 7,
  enhancement_gate = 'm_glass',
  stage = "One",
  ptype = "Grass",
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
    -- Check if glass card breaks, then convert an unenhanced card in deck to glass
    if context.remove_playing_cards then
      local glass_cards = 0
      for _, removed_card in ipairs(context.removed) do
        if removed_card.shattered then glass_cards = glass_cards + 1 end
      end
      if glass_cards > 0 then
        for i = 1, glass_cards do
          local viable_targets = {}
          for k, v in pairs(G.playing_cards) do
            if v.config.center == G.P_CENTERS.c_base then viable_targets[#viable_targets+1] = v end
          end
          local target = pseudorandom_element(viable_targets, pseudoseed('abomasnow'))
          if target then
            poke_convert_cards_to(target, {mod_conv = 'm_glass', edition = "e_foil"}, true, true)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('poke_ice_shard_ex')})
          end
        end
      end
    end

    -- Earn money when glass is scored
    if context.individual and not context.end_of_round and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_glass') then
      local earned = ease_poke_dollars(card, "snover", card.ability.extra.money_mod, true)
      return {
        dollars = earned,
        card = card
      }
    end
  end,
  megas = {"mega_abomasnow"}
}

-- Mega Abomasnow 460-1
local mega_abomasnow={
  name = "mega_abomasnow",
  config = {extra = {money_mod = 20}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.money_mod}}
  end,
  designer = "CBMX",
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Grass",
  gen = 4,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.remove_playing_cards then
      local glass_cards = 0
      for _, removed_card in ipairs(context.removed) do
        if removed_card.shattered then glass_cards = glass_cards + 1 end
      end
      if glass_cards > 0 then
        local earned = ease_poke_dollars(card, "snover", card.ability.extra.money_mod * glass_cards, true)
        return {
          dollars = earned,
          card = card
        }
      end
    end
  end,
}

return {
  name = "Nacho's Snover Evo Line",
  enabled = nacho_config.snover or false,
  list = { snover, abomasnow, mega_abomasnow }
}

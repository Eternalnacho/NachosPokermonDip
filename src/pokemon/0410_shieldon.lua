local shieldon = {
  name = "shieldon",
  config = { extra = { rank = "6", chips = 12, third_times = 0 }, evo_rqmt = 5 },
  loc_vars = function(self, info_queue, card)
    local a = card.ability.extra or self.config.extra
    info_queue[#info_queue+1] = {set = 'Other', key = 'ancient', vars = {localize(a.rank, 'ranks')}}
    return { vars = { localize(a.rank, 'ranks'), a.chips, math.max(self.config.evo_rqmt - a.third_times, 0) }}
  end,
  rarity = 2,
  cost = 5,
  stage = "Basic",
  ptype = "Earth",
  gen = 4,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.before and not context.blueprint then
      pokermon.get_ancient_amount(context.scoring_hand, 6, card)
    end

    -- 1: Scoring 6s give +12 chips for each played 6
    if context.individual and not context.end_of_round and context.cardarea == G.play and a.ancient_count > 0 then
      if context.other_card:get_id() == 6 then
        return { chips = a.chips * a.ancient_count, card = context.other_card }
      end
    end
    -- 2: First scoring card in poker hand becomes steel
    if context.before and a.ancient_count > 1 then
      context.scoring_hand[1]:set_ability('m_steel', nil, true)
      PkmnDip.defer(function()
        context.scoring_hand[1]:juice_up()
      end)
    end
    -- 3: Held steel cards give +12 chips for each played 6
    if context.individual and not context.end_of_round and context.cardarea == G.hand and a.ancient_count > 2 then
      if SMODS.has_enhancement(context.other_card, 'm_steel') then
        return { h_chips = a.chips * a.ancient_count, card = context.other_card }
      end
    end

    if context.after then
      if a.ancient_count > 2 then a.third_times = a.third_times + 1 end
      a.ancient_count = 0
    end
    return pokermon.scaling_evo(self, card, context, "j_nacho_bastiodon", card.ability.extra.third_times, self.config.evo_rqmt)
  end,
  generate_ui = pokermon.fossil_generate_ui,
  attributes = {"ancient", "rank", "six", "enhancements", "chips", "trigger_evo"},
}

local bastiodon = {
  name = "bastiodon",
  config = { extra = { rank = "6", chips = 24 } },
  loc_vars = function(self, info_queue, card)
    local a = card.ability.extra or self.config.extra
    info_queue[#info_queue+1] = {set = 'Other', key = 'ancient', vars = {localize(a.rank, 'ranks')}}
    return {vars = {localize(a.rank, 'ranks'), a.chips }}
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Earth",
  gen = 4,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.before and not context.blueprint then
      pokermon.get_ancient_amount(context.scoring_hand, 6, card)
    end

    -- 1: Scoring 6s give +24 chips for each played 6
    if context.individual and not context.end_of_round and context.cardarea == G.play and a.ancient_count > 0 then
      if context.other_card:get_id() == 6 then 
        return { chips = a.chips * a.ancient_count, card = context.other_card }
      end
    end
    -- 2: First scoring card in poker hand becomes steel
    if context.before and a.ancient_count > 1 then
      context.scoring_hand[1]:set_ability('m_steel', nil, true)
      PkmnDip.defer(function()
        context.scoring_hand[1]:juice_up()
      end)
    end
    -- 3: Held steel cards give +24 chips for each played 6
    if context.individual and not context.end_of_round and context.cardarea == G.hand and a.ancient_count > 2 then
      if SMODS.has_enhancement(context.other_card, 'm_steel') then 
        return { h_chips = a.chips * a.ancient_count, card = context.other_card }
      end
    end
    -- 4: Held ranks below 6 become steel
    if context.before and a.ancient_count > 3 then
      PkmnDip.utils.for_each(G.hand.cards, function(v)
        if v:get_id() < 6 then
          v:set_ability('m_steel', nil, true)
          PkmnDip.defer(function() v:juice_up() end)
        end
      end)
    end

    if context.after then
      card.ability.extra.ancient_count = 0
    end
  end,
  generate_ui = pokermon.fossil_generate_ui,
  attributes = {"ancient", "rank", "six", "enhancements", "chips"},
}

return {
  config_key = "shieldon",
  list = { shieldon, bastiodon }
}
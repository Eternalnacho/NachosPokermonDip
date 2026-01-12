local shieldon = {
  name = "shieldon",
  config = { extra = { rank = "6", chips = 12, third_times = 0 }, evo_rqmt = 5 },
  loc_vars = function(self, info_queue, card)
    local a = card.ability.extra or self.config.extra
    type_tooltip(self, info_queue, card)
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
      get_ancient_amount(context.scoring_hand, 6, card)
    end

    if context.individual and not context.end_of_round and context.cardarea == G.play and a.ancient_count > 0 then
      if context.other_card:get_id() == 6 then 
        return { chips = a.chips * a.ancient_count, card = context.other_card }
      end
    end

    if context.before and a.ancient_count > 1 then
      context.scoring_hand[1]:set_ability('m_steel', nil, true)
      G.E_MANAGER:add_event(Event({ func = function() context.scoring_hand[1]:juice_up(); return true end }))
    end

    if context.individual and not context.end_of_round and context.cardarea == G.hand and a.ancient_count > 2 then
      if SMODS.has_enhancement(context.other_card, 'm_steel') then 
        return { h_chips = a.chips * a.ancient_count, card = context.other_card }
      end
    end
    
    if context.after then
      card.ability.extra.ancient_count = 0
    end
    return scaling_evo(self, card, context, "j_nacho_bastiodon", card.ability.extra.third_times, self.config.evo_rqmt)
  end,
  generate_ui = fossil_generate_ui,
}

local bastiodon = {
  name = "bastiodon",
  config = { extra = { rank = "6", chips = 24 } },
  loc_vars = function(self, info_queue, card)
    local a = card.ability.extra or self.config.extra
    type_tooltip(self, info_queue, card)
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
      get_ancient_amount(context.scoring_hand, 6, card)
    end

    if context.individual and not context.end_of_round and context.cardarea == G.play and a.ancient_count > 0 then
      if context.other_card:get_id() == 6 then 
        return { chips = a.chips * a.ancient_count, card = context.other_card }
      end
    end

    if context.before and a.ancient_count > 1 then
      context.scoring_hand[1]:set_ability('m_steel', nil, true)
      G.E_MANAGER:add_event(Event({ func = function() context.scoring_hand[1]:juice_up(); return true end }))
    end

    if context.individual and not context.end_of_round and context.cardarea == G.hand and a.ancient_count > 2 then
      if SMODS.has_enhancement(context.other_card, 'm_steel') then 
        return { h_chips = a.chips * a.ancient_count, card = context.other_card }
      end
    end

    if context.before and a.ancient_count > 3 then
      for _, v in pairs(G.hand.cards) do
        if v:get_id() < 6 then
          v:set_ability('m_steel', nil, true) 
          G.E_MANAGER:add_event(Event({
            func = function()
                v:juice_up()
                return true
            end
          }))
        end
      end
    end
    
    if context.after then
      card.ability.extra.ancient_count = 0
    end
  end,
  generate_ui = fossil_generate_ui,
}

return {
  config_key = "shieldon",
  list = { shieldon, bastiodon }
}
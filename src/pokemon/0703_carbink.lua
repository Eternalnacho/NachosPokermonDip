-- Carbink 703
local carbink = {
  name = "carbink",
  config = {extra = { hazard_level = 1 }},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'hazard_level', vars = poke_get_hazard_level_vars()}
    info_queue[#info_queue+1] = G.P_CENTERS.m_hazard
    info_queue[#info_queue+1] = G.P_CENTERS.m_gold
    return {vars = { card.ability.extra.hazard_level }}
  end,
  rarity = 3,
  cost = 7,
  stage = "Basic",
  ptype = "Fairy",
  blueprint_compat = false,
  enhancement_gate = 'm_poke_hazard',
  calculate = function(self, card, context)
    if context.check_enhancement and context.other_card.config.center.key == 'm_poke_hazard' then
      return {m_gold = true}
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    poke_change_hazard_level(card.ability.extra.hazard_level)
  end,
  remove_from_deck = function(self, card, from_debuff)
    poke_change_hazard_level(-card.ability.extra.hazard_level)
  end
}

return {
  config_key = "carbink",
  list = { carbink }
}

-- Carbink 703
local carbink = {
  name = "carbink",
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_gold
    return {vars = {}}
  end,
  designer = "Eternalnacho",
  rarity = 1,
  cost = 5,
  stage = "Basic",
  ptype = "Fairy",
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
    if context.check_enhancement and not context.blueprint then
      if SMODS.has_no_rank(context.other_card) then
        return {m_gold = true}
      end
    end
  end,
  in_pool = function(self, args)
    for k, v in pairs(G.playing_cards) do
      if SMODS.has_no_rank(v) then return true end
    end
    for k, v in pairs(G.jokers.cards) do
      if v.hazard_poke then return true end
    end
    return false
  end,
}

return {
  name = "Nacho's Carbink",
  enabled = nacho_config.carbink or false,
  list = { carbink }
}

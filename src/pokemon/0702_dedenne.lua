-- Dedenne 702
local dedenne = {
  name = "dedenne",
  config = {extra = {num = 1, den = 4}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_gold
    info_queue[#info_queue+1] = {set = 'Other', key = 'pickup'}
    local a = card.ability.extra
    local num, den = SMODS.get_probability_vars(card, a.num, a.den, 'dedenne')
    return {vars = {num, den}}
  end,
  rarity = 1,
  cost = 4,
  enhancement_gate = "m_gold",
  stage = "Basic",
  ptype = "Lightning",
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.dedenne_trig and SMODS.pseudorandom_probability(card, 'dedenne', a.num, a.den) then
      local key = pokermon.generate_pickup_item_key('dedenne')
      return {
        remove_default_message = true,
        func = function() pokermon.create_consumeable({set = 'poke_item', key = key}, true, card) end
      }
    end
  end,
  attributes = {"enhancements", "chance", "item", "generation"}
}

return {
  config_key = "dedenne",
  list = { dedenne }
}

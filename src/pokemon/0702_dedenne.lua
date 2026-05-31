-- Dedenne 702
local dedenne = {
  name = "dedenne",
  config = {extra = {num = 1, den = 4}},
  loc_vars = function(self, info_queue, card)
    pokermon.type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_gold
    info_queue[#info_queue+1] = {set = 'Other', key = 'pickup'}
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, 'dedenne')
    return {vars = {num, den}}
  end,
  rarity = 1,
  cost = 4,
  enhancement_gate = "m_gold",
  stage = "Basic",
  ptype = "Lightning",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.dedenne_trig and (#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit)
        and SMODS.pseudorandom_probability(card, 'dedenne', card.ability.extra.num, card.ability.extra.den, 'dedenne') then
      G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
      PkmnDip.defer(function()
        local _card = SMODS.add_card({set = 'poke_Item', area = G.consumeables, key = pokermon.generate_pickup_item_key('dedenne')})
        card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('poke_plus_pokeitem'), colour = G.ARGS.LOC_COLOURS.item})
        G.GAME.consumeable_buffer = 0
      end)
    end
  end,
  attributes = {"enhancements", "chance", "item", "generation"}
}

return {
  config_key = "dedenne",
  list = { dedenne }
}

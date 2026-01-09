-- Meowth 52-2
local galarian_meowth={
  name = "galarian_meowth",
  config = {extra = { retriggers = 1, triggered = 0 }, evo_rqmt = 20},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
		return {vars = {card.ability.extra.retriggers, math.max(card.ability.evo_rqmt - card.ability.extra.triggered, 0)}}
  end,
  rarity = 2,
  cost = 6,
  enhancement_gate = 'm_steel',
  stage = "Basic",
  ptype = "Metal",
  gen = 1,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1)
    and SMODS.has_enhancement(context.other_card, "m_steel") then
      if not context.blueprint then
        local eor
        for i = 1, #context.card_effects do
          if context.card_effects[i].end_of_round and next(context.card_effects[i].end_of_round) then eor = true
          elseif context.end_of_round and context.card_effects[i].jokers then eor = true end
        end
        if not context.end_of_round or eor then
          card.ability.extra.triggered = card.ability.extra.triggered + 1
        end
      end
      return {
        message = localize('k_again_ex'),
        repetitions = card.ability.extra.retriggers,
        card = card
      }
    end
    return scaling_evo(self, card, context, "j_nacho_perrserker", card.ability.extra.triggered, self.config.evo_rqmt)
  end,
}

-- Perrserker 863
local perrserker = {
  name = "perrserker",
  config = { extra = { Xmult_multi = 1.5, retriggers = 1 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    local total_xmult = 1.5
    local total_energy = 0
    PkmnDip.utils.for_each(SMODS.find_card('j_nacho_perrserker'), function(v) total_energy = total_energy + get_total_energy(v) end)
    total_xmult = total_xmult + total_xmult * .05 * total_energy
    return { vars = { total_xmult } }
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "One",
  ptype = "Metal",
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) 
    and SMODS.has_enhancement(context.other_card, "m_steel") then
      return {
        message = not context.retrigger_joker and localize('k_again_ex'),
        repetitions = card.ability.extra.retriggers,
        card = card
      }
    end
  end,
}

local init = function()
  get_h_x_mult_ref = Card.get_chip_h_x_mult
  Card.get_chip_h_x_mult = function(self)
    local data = self.ability.h_x_mult
    if next(SMODS.find_card('j_nacho_perrserker')) and SMODS.has_enhancement(self, 'm_steel') then
      local total_energy = 0
      PkmnDip.utils.for_each(SMODS.find_card('j_nacho_perrserker'), function(v) total_energy = total_energy + get_total_energy(v) end)
      self.ability.h_x_mult = (data + self.ability.h_x_mult * .05 * total_energy) or 1
    end
    local ret = get_h_x_mult_ref(self)
    self.ability.h_x_mult = data
    return ret
  end
end

return {
  config_key = "galarian_meowth",
  init = init,
  list = { galarian_meowth, perrserker }
}
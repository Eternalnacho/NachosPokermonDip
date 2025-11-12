-- Meowth 52-2
local galarian_meowth={
  name = "galarian_meowth",
  config = {extra = {metals = 0, retriggers = 1, counter = 0}, evo_rqmt = 2},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
		return {vars = {card.ability.extra.retriggers}}
  end,
  designer = "Eternalnacho",
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
    if context.before and context.cardarea == G.jokers and not context.blueprint and not context.retrigger_joker then
      card.ability.extra.counter = 0
      return{}
    end
    if context.repetition and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) 
    and SMODS.has_enhancement(context.other_card, "m_steel") and card.ability.extra.counter < 2 then
      if not context.blueprint and not context.retrigger_joker then
        card.ability.extra.counter = card.ability.extra.counter + 1
      end
      return {
        message = localize('k_again_ex'),
        repetitions = card.ability.extra.retriggers,
        card = card
      }
    end

    return scaling_evo(self, card, context, "j_nacho_perrserker", card.ability.extra.metals, self.config.evo_rqmt)
  end,
  update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and card.area == G.jokers then
      local metals = 0
      local adjacent_jokers = poke_get_adjacent_jokers(card)
      for i = 1, #adjacent_jokers do
        if is_type(adjacent_jokers[i], "Metal") then metals = metals + 1 end
      end
      card.ability.extra.metals = metals
      return {}
    end
  end,
}

-- Perrserker 863
local perrserker = {
  name = "perrserker",
  config = { extra = {Ymult = 1.5, retriggers = 1, counter = 0}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    return { vars = {card.ability.extra.Ymult} }
  end,
  designer = "Eternalnacho",
  rarity = "poke_safari",
  cost = 10,
  stage = "One",
  ptype = "Metal",
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and not context.blueprint and not context.retrigger_joker then
      card.ability.extra.counter = 0
      return{}
    end

    if context.repetition and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) 
    and SMODS.has_enhancement(context.other_card, "m_steel") then
      if not context.blueprint and not context.retrigger_joker then
        card.ability.extra.counter = card.ability.extra.counter + 1
      end
      if card.ability.extra.counter > 3 then return end
      return {
        message = localize('k_again_ex'),
        repetitions = card.ability.extra.retriggers,
        card = card
      }
    end

    if context.other_joker and is_type(context.other_joker, "Metal") then
      G.E_MANAGER:add_event(Event({
        func = function()
            context.other_joker:juice_up(0.5, 0.5)
            return true
        end
      })) 
      return {
        message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Ymult}}, 
        colour = G.C.XMULT,
        Xmult_mod = card.ability.extra.Ymult,
        message_card = context.other_joker,
      }
    end

    if context.retrigger_joker_check and not context.retrigger_joker then
      local metals = #PkmnDip.utils.filter(G.jokers.cards, function(v) return is_type(v, "Metal") end)
      if metals == #G.jokers.cards and (context.other_card.ability and context.other_card == card) then
        return {
          message = localize("k_again_ex"),
          colour = G.C.BLACK,
          repetitions = 1,
          card = card,
        }
      end
		end
  end,
}

return {
  name = "Nacho's Galarian Meowth Evo Line",
  enabled = nacho_config.galarian_meowth or false,
  list = { galarian_meowth, perrserker }
}

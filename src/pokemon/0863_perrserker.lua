-- Meowth 52-2
local galarian_meowth={
  name = "galarian_meowth",
  config = {extra = { retriggers = 1, triggered = 0 }, evo_rqmt = 20},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
		return {vars = {card.ability.extra.retriggers, math.max(card.ability.evo_rqmt - card.ability.extra.triggered, 0)}}
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
    if context.post_trigger and context.other_context.individual and context.other_context.cardarea == G.hand
    and SMODS.has_enhancement(context.other_context.other_card, 'm_steel') then
      card.ability.extra.to_retrigger = true
    end
    if context.repetition and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1)
    and SMODS.has_enhancement(context.other_card, "m_steel") and (not context.end_of_round or card.ability.extra.to_retrigger) then
      card.ability.extra.to_retrigger = nil
      if not context.blueprint then
        card.ability.extra.triggered = card.ability.extra.triggered + 1
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
  designer = "Eternalnacho",
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
        message = not context.retrigger_joker and localize('k_again_ex') or nil,
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

-- local score_metal_jokers = function(card, context)
--   local temp_steel = SMODS.create_card({set = 'Enhanced', enhancement = 'm_steel'})
--   temp_steel.states.visible = nil
--   temp_steel:hard_set_T(context.other_joker.T.x, context.other_joker.T.y, context.other_joker.T.w, context.other_joker.T.h)
--   local temp_context = {
--     cardarea = G.hand,
--     individual = true,
--     main_scoring = true,
--     other_card = temp_steel,
--     full_hand = context.full_hand,
--     poker_hands = context.poker_hands,
--     scoring_hand = context.scoring_hand,
--     scoring_name = context.scoring_name,
--     retrigger_joker = context.retrigger_joker
--   }
--   local reps = { 1 }
--   local j = 1
--   while j <= #reps do
--     if reps[j] ~= 1 then
--         local _, eff = next(reps[j])
--         eff.message_card = context.other_joker
--         while eff.retrigger_flag do
--             SMODS.calculate_effect(eff, temp_steel); j = j+1; _, eff = next(reps[j])
--             G.E_MANAGER:add_event(Event({
--               func = function()
--                   context.other_joker:juice_up(0.5, 0.5)
--                   return true
--               end
--             }))
--         end
--         SMODS.calculate_effect(eff, temp_steel)
--         G.E_MANAGER:add_event(Event({
--           func = function()
--               context.other_joker:juice_up(0.5, 0.5)
--               return true
--           end
--         }))
--     end

--     temp_context.main_scoring = true
--     local effects = { eval_card(temp_steel, temp_context) }
--     effects.message_card = context.other_joker
--     SMODS.calculate_quantum_enhancements(temp_steel, effects, temp_context)
--     temp_context.main_scoring = nil
--     temp_context.individual = true
--     temp_context.other_card = temp_steel

--     if next(effects) then
--         SMODS.calculate_card_areas('jokers', temp_context, effects, { main_scoring = true })
--         SMODS.calculate_card_areas('individual', temp_context, effects, { main_scoring = true })
--     end

--     local flags = SMODS.trigger_effects(effects, temp_steel)

--     temp_context.individual = nil
--     if reps[j] == 1 and flags.calculated then
--         temp_context.repetition = true
--         temp_context.card_effects = effects
--         SMODS.calculate_repetitions(temp_steel, temp_context, reps)
--         temp_context.repetition = nil
--         temp_context.card_effects = nil
--     end
--     j = j + (flags.calculated and 1 or #reps)
--     temp_context.other_card = nil
--     temp_steel.lucky_trigger = nil
--   end

--   temp_steel:start_dissolve(nil, true)
-- end
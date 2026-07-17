local get_adj = pokermon.get_adjacent_jokers
local is_metal = function(card) return pokermon.is_type(card, "Metal") end
local get_ecount = pokermon.energy.get_total_energy
local total_ecount = function(key)
  local count = 0
  local add_total = function(joker) count = count + get_ecount(joker) end
  PkmnDip.utils.for_each(SMODS.find_card(key), add_total)
  return count
end

local score_metal_jokers = function(card, context)
  -- Create a temporary steel card and set it's position to the relevant joker
  local temp_steel = SMODS.create_card({set = 'Enhanced', enhancement = 'm_steel'})
  temp_steel.scoring_metal_for = card
  -- Call set_base with no args to remove rank + suit
  temp_steel:set_base()
  -- Set the steel card's major to the joker for click + drag reasons
  PkmnDip.defer(function() temp_steel:set_role({major = card, role_type = 'Glued'}) end)
  -- Set the scoring animation bit onto the target joker
  temp_steel.juice_up = function(self, ...) card:juice_up(...) end
  -- Create fake context to trick Balatro into thinking we're calculating held steel cards
  local temp_context = {
    cardarea = G.hand,
    individual = true,
    main_scoring = true,
    other_card = temp_steel,
    full_hand = context.full_hand,
    poker_hands = context.poker_hands,
    scoring_hand = context.scoring_hand,
    scoring_name = context.scoring_name,
    retrigger_joker = context.retrigger_joker,
  }
  -- The scoring code I had before wound up being a 1-for-1 of SMODS.score_card
  SMODS.score_card(temp_steel, temp_context)
  -- Remove the temporary steel card to save memory / screen real-estate
  temp_steel:remove()
end

-- Meowth 52-2
local galarian_meowth={
  name = "galarian_meowth",
  config = { extra = { Xmult_multi = 1.5 }, evo_rqmt = 2 },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'energize'}
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
		return { vars = { card.ability.extra.Xmult_multi } }
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
    if context.other_joker and card == context.other_joker then
      score_metal_jokers(context.other_joker, context)
    end
    local adj_req = #PkmnDip.utils.filter(get_adj(card), is_metal)
    return pokermon.scaling_evo(self, card, context, "j_nacho_perrserker", adj_req, self.config.evo_rqmt)
  end,
  attributes = {"enhancements", "retrigger", "condition_evo"}
}

-- Perrserker 863
local perrserker = {
  name = "perrserker",
  config = { extra = { Xmult_multi = 1.5 } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'energize'}
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    local steel_energy = 1.5 + 1.5 * .05 * total_ecount('j_nacho_perrserker')
    return { vars = { steel_energy } }
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "One",
  ptype = "Metal",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.other_joker then
      local metal_adj = PkmnDip.utils.filter(get_adj(card), is_metal)
      local other = context.other_joker
      if card == other or (next(metal_adj) and PkmnDip.utils.contains(metal_adj, other)) then
        score_metal_jokers(other, context)
      end
    end
  end,
  attributes = {"enhancements", "retrigger", "modify_card", "energy"}
}

local init = function()
  PkmnDip.utils.hook_around_function(Card, 'get_chip_h_x_mult', function(orig, self, ...)
    local data = self.ability.h_x_mult
    if (next(SMODS.find_card('j_nacho_perrserker')) or next(SMODS.find_card('j_nacho_galarian_meowth')))
        and SMODS.has_enhancement(self, 'm_steel') then
      local ecount = total_ecount('j_nacho_perrserker')
      PkmnDip.utils.for_each(SMODS.find_card('j_nacho_galarian_meowth'), function(v)
        if self.scoring_metal_for == v then ecount = ecount + get_ecount(v) end
      end)
      data = (data + self.ability.h_x_mult * .05 * ecount) or 1
    end
    local ret = orig(self)
    self.ability.h_x_mult = data
    return ret
  end)
end

return {
  config_key = "galarian_meowth",
  init = init,
  list = { galarian_meowth, perrserker }
}
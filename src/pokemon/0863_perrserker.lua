local utils = PkmnDip.utils
local get_adj = pokermon.get_adjacent_jokers
local is_metal = function(card) return pokermon.is_type(card, "Metal") end
local energize = pokermon.energy.modify

-- Meowth 52-2
local galarian_meowth={
  name = "galarian_meowth",
  config = { extra = { e_amount = 1, raised = 0, steel_scored = 0 }, evo_rqmt = 15 },
  loc_vars = function(self, info_queue, card)
    local extra = card.ability.extra or self.config.extra
    info_queue[#info_queue+1] = {set = 'Other', key = 'energize'}
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
		return { vars = { extra.raised, math.max(0, self.config.evo_rqmt - extra.steel_scored) } }
  end,
  rarity = 1,
  cost = 5,
  enhancement_gate = 'm_steel',
  stage = "Basic",
  ptype = "Metal",
  gen = 1,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local extra = card.ability.extra
    if context.before and utils.any(context.scoring_hand, PkmnDip.con.is_steel) and not (extra.raised > 0) then
      local other_metals = utils.filter(get_adj(card), is_metal)
      utils.for_each(other_metals, function(j)
        if pokermon.energy.is_energizable(j) then
          energize(j, get_type(j), extra.e_amount, true)
        end
      end)
      extra.raised = extra.raised + 1 -- Counting the number of times this effect activates
      return { message = localize('poke_energized_ex'), colour = pokermon.colours.metal }
    end

    if context.individual and not context.end_of_round and context.cardarea == G.play and not context.blueprint
        and PkmnDip.con.is_steel(context.other_card) then
      extra.steel_scored = extra.steel_scored + 1
    end

    if context.end_of_round and context.main_eval and extra.raised > 0 then
      local other_metals = utils.filter(get_adj(card), is_metal)
      utils.for_each(other_metals, function(j) 
        if pokermon.energy.is_energizable(j) then
          energize(j, get_type(j), -extra.e_amount * extra.raised, true) 
        end
      end)
      extra.raised = 0
      return { message = localize('k_reset'), colour = pokermon.colours.metal }
    end
    return pokermon.scaling_evo(self, card, context, "j_nacho_perrserker", extra.steel_scored, self.config.evo_rqmt)
  end,
  attributes = {"enhancements", "energy", "condition_evo"}
}

-- Perrserker 863
local perrserker = {
  name = "perrserker",
  config = { extra = { e_amount = 1, raised = 0, b_raised = 0, limit = 2 } },
  loc_vars = function(self, info_queue, card)
    local extra = card.ability.extra or self.config.extra
    info_queue[#info_queue+1] = {set = 'Other', key = 'energize'}
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    return { vars = { extra.b_raised, extra.limit } }
  end,
  rarity = "poke_safari",
  cost = 10,
  enhancement_gate = 'm_steel',
  stage = "One",
  ptype = "Metal",
  blueprint_compat = true,
  calculate = function(self, card, context)
    local extra = card.ability.extra
    if context.before and utils.any(context.scoring_hand, PkmnDip.con.is_steel) and not (extra.b_raised >= extra.limit) then
      local other_metals = utils.filter(get_adj(card), is_metal)
      local amount = math.min(3, #utils.filter(context.scoring_hand, PkmnDip.con.is_steel))
      utils.for_each(other_metals, function(j)
        if pokermon.energy.is_energizable(j) then
          energize(j, get_type(j), extra.e_amount * amount, true)
        end
      end)
      extra.raised = extra.raised + amount -- Counting the number of times this effect activates
      if not context.blueprint then extra.b_raised = extra.b_raised + amount end -- same as above but not counting blueprints
      return { message = localize('poke_energized_ex'), colour = pokermon.colours.metal }
    end

    if context.after and context.main_eval and extra.raised > 0 then
      local other_metals = utils.filter(get_adj(card), is_metal)
      utils.for_each(other_metals, function(j)
        if pokermon.energy.is_energizable(j) then
          energize(j, get_type(j), -extra.e_amount * extra.raised, true) 
        end
      end)
      extra.raised = 0; extra.b_raised = 0
      return { message = localize('k_reset'), colour = pokermon.colours.metal }
    end
  end,
  attributes = {"enhancements", "modify_card", "energy"}
}

local init = function()

end

return {
  config_key = "galarian_meowth",
  init = init,
  list = { galarian_meowth, perrserker }
}
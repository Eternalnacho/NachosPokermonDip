local filter = PkmnDip.utils.filter
local get_adj = pokermon.get_adjacent_jokers
local is_metal = function(card) return pokermon.is_type(card, "Metal") end
local get_ecount = pokermon.energy.get_total_energy
local total_ecount = function(key)
  local count = 0
  local add_total = function(joker) count = count + get_ecount(joker) end
  PkmnDip.utils.for_each(SMODS.find_card(key), add_total)
  return count
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
    if context.before then
      PkmnDip.eff.joker_as_card(card, {
        area = G.hand,
        enhancement = 'm_steel',
      })
    end
    local adj_req = #filter(get_adj(card), is_metal)
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
    if context.before then
      local metal_adj = filter(get_adj(card), is_metal)
      PkmnDip.utils.for_each(metal_adj, function(joker)
        PkmnDip.eff.joker_as_card(joker, {
          area = G.hand,
          enhancement = 'm_steel',
        })
      end)
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
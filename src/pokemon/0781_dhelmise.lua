local get_ecount = pokermon.energy.get_total_energy
local total_ecount = function(key)
  local count = 0
  local add_total = function(joker) count = count + get_ecount(joker) end
  PkmnDip.utils.for_each(SMODS.find_card(key), add_total)
  return count
end

-- Dhelmise 781
local dhelmise = {
  name = "dhelmise",
  config = { extra = { Xmult_multi = 1.5 } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'energize'}
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    local steel_energy = 1.5 + 1.5 * .05 * total_ecount('j_nacho_dhelmise')
    return { vars = { steel_energy } }
  end,
  rarity = 2,
  cost = 7,
  enhancement_gate = 'm_steel',
  stage = "Basic",
  ptype = "Grass",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before then
      PkmnDip.eff.joker_as_card(card, {
        area = G.hand,
        enhancement = 'm_steel',
      })
    end
  end,
  attributes = {"enhancements", "passive", "modify_card", "energy"}
}

local init = function()
  PkmnDip.Hook("around", Card, 'get_chip_h_x_mult', function(orig, self, ...)
    local data = self.ability.h_x_mult
    if next(SMODS.find_card('j_nacho_dhelmise')) and SMODS.has_enhancement(self, 'm_steel') then
      local ecount = total_ecount('j_nacho_dhelmise')
      self.ability.h_x_mult = (data + data * .05 * ecount)
    end
    local ret = orig(self)
    self.ability.h_x_mult = data
    return ret
  end)

  local steel_loc_vars = G.P_CENTERS.m_steel.loc_vars
  SMODS.Enhancement:take_ownership('m_steel', {
    loc_vars = function(self, info_queue, card)
      if next(SMODS.find_card('j_nacho_dhelmise')) then
        local Xmult = card.ability.h_x_mult or 1.5
        local ecount = total_ecount('j_nacho_dhelmise')
        Xmult = (Xmult + Xmult * .05 * ecount)
        return {
          vars = { Xmult },
          key = 'm_steel'
        }
      else
        return steel_loc_vars and steel_loc_vars(self, info_queue, card)
          or {
            vars = { card.ability.h_x_mult or 1.5 },
            key = 'm_steel'
          }
      end
    end,
  }, true)
end

return {
  config_key = "dhelmise",
  init = init,
  list = { dhelmise }
}
-- Mega Gardevoir 282-1
local mega_gardevoir = {
  name = "mega_gardevoir",
  nacho_inject_prefix = "poke",
  pos = { x = 2, y = 6 },
  soul_pos = { x = 3, y = 6 },
  config = { extra = { Xmult = 1, Xmult_mod = 0.1, e_limit = 1 } },
  loc_txt = {
    name = "Mega Gardevoir",
    text = {
      "{C:pink}+#1#{} Energy Limit",
      "{br:2.5}ERROR - CONTACT STEAK",
      "{X:mult,C:white}X#2#{} Mult for each",
      "{C:pink}Energized{} Joker and each",
      "{C:attention}hand level{} above 1",
      "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local a = center.ability.extra
    local xmult = a.Xmult
    for _, v in pairs(G.GAME.hands) do
      xmult = xmult + math.max((v.level - 1) * a.Xmult_mod, 0)
    end
    -- Count energized jokers
    if G.jokers and G.jokers.cards then
      xmult = xmult + a.Xmult_mod * #PkmnDip.utils.filter(G.jokers.cards, function(joker) return get_total_energy(joker) > 0 end)
    end
    return {vars = { a.e_limit, a.Xmult_mod, xmult }}
  end,
  rarity = "poke_mega",
  cost = 12,
  gen = 3,
  stage = "Mega",
  ptype = "Psychic",
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.joker_main then
      local xmult = a.Xmult
      -- Count hand levels above 1
      for _, v in pairs(G.GAME.hands) do
        local hand_level = (SMODS.Mods["Talisman"] or {}).can_load and (to_number(v.level) - 1) or (v.level - 1)
        xmult = xmult + math.max(hand_level * a.Xmult_mod, 0)
      end
      -- Count energized jokers
      xmult = xmult + a.Xmult_mod * #PkmnDip.utils.filter(G.jokers.cards, function(joker) return get_total_energy(joker) > 0 end)

      if xmult > 1 then
        return { xmult = xmult }
      end
    end
  end,
}

local function init()
  SMODS.Joker:take_ownership('poke_gardevoir', { megas = { 'mega_gardevoir' } }, true)
  poke_add_to_family("gardevoir", "mega_gardevoir")
end

return {
  can_load = nacho_config.other_megas,
  init = init,
  list = { mega_gardevoir }
}
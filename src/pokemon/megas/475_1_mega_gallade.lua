-- Mega Gallade 282-1
local mega_gallade = {
  name = "mega_gallade",
  nacho_inject_prefix = "poke",
  pos = { x = 0, y = 7 },
  soul_pos = { x = 1, y = 7 },
  config = { extra = { Xmult = 3, e_limit = 1 } },
  loc_txt = {
    name = "Mega Gallade",
    text = {
      "{C:pink}+#1#{} Energy Limit, {X:mult,C:white}X#2#{} Mult",
      "This Joker {C:attention}can't{} be debuffed",
      "{br:2.5}ERROR - CONTACT STEAK",
      "Raises the Energy Limit",
      "of a random Joker by {C:pink}1{}",
      "when an {C:item}Item{} is used",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = { center.ability.extra.e_limit, center.ability.extra.Xmult }}
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
    if context.using_consumeable and context.consumeable.ability.set == 'Item' then
      local target = pseudorandom_element(G.jokers.cards, 'mega_gallade')
      target.ability.extra.e_limit_up = target.ability.extra.e_limit_up and target.ability.extra.e_limit_up + 1 or 1
    end
  end,
}

local function init()
  SMODS.Joker:take_ownership('poke_gallade', { megas = { 'mega_gallade' } }, true)
  poke_add_to_family("gallade", "mega_gallade")
end

return {
  can_load = nacho_config.other_megas,
  init = init,
  list = { mega_gallade }
}
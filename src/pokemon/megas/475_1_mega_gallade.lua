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
      "{C:poke_pink}+#1#{} Energy Limit, {X:mult,C:white}X#2#{} Mult",
      "This Joker {C:attention}can't{} be debuffed",
      "{br:2.5}ERROR - CONTACT STEAK",
      "Raises the Energy Limit",
      "of a random Joker by {C:poke_pink}1{}",
      "when an {C:poke_item}Item{} is used",
    }
  },
  loc_vars = function(self, info_queue, center)
    pokermon.type_tooltip(self, info_queue, center)
    return {vars = { center.ability.extra.e_limit, center.ability.extra.Xmult }}
  end,
  rarity = "poke_mega",
  cost = 12,
  gen = 3,
  stage = "Mega",
  ptype = "Fighting",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable.ability.set == 'poke_item' then
      local target = pseudorandom_element(G.jokers.cards, 'mega_gallade')
      target.ability.extra.e_limit_up = target.ability.extra.e_limit_up and target.ability.extra.e_limit_up + 1 or 1
      return {
        message = localize('k_upgrade_ex'),
        message_card = target
      }
    end
    if context.joker_main then
      return { xmult = card.ability.extra.Xmult }
    end
  end,
  attach_mega = function(self) PkmnDip.attach_mega(self, 'poke_gallade') end
}

local function init()
  if nacho_config.mega_gallade then
    SMODS.Joker:take_ownership('poke_gallade', { megas = { 'mega_gallade' } }, true)
    pokermon.add_to_family("gallade", "mega_gallade")
  end
end

return {
  config_key = "mega_gallade",
  init = init,
  misc_config = "megas",
  list = { mega_gallade }
}
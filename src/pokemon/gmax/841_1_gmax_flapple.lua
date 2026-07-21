-- Hydrapple 1019
local gmax_flapple = {
  name = "gmax_flapple",
  config = { extra = { Xmult = 1, Xmult1 = 1.5 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult1 } }
  end,
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Flapple",
    text = {
      "Destroy all scoring cards",
      "{br:2}ERROR - CONTACT STEAK",
      "{X:mult,C:white}X#1#{} Mult for each",
      "card in poker hand",
    }
  },
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Dragon",
  gen = 8,
  blueprint_compat = true,
  poke_custom_values_to_keep = { "Xmult" },
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.destroying_card then
      return {remove = true}
    end
    if context.joker_main then
      return { xmult = a.Xmult1 * #context.scoring_hand }
    end
  end,
  attach_gmax = function(self) PkmnDip.attach_gmax(self, 'nacho_flapple', 'gmax_apples') end,
  attributes = {"xmult", "destroy_card"}
}

local init = function()
  pokermon.add_to_family("flapple", "gmax_flapple")

  SMODS.Joker:take_ownership("nacho_flapple", {
    gmax = "gmax_flapple",
    poke_custom_values_to_keep = { "Xmult" }
  }, true)
end

return {
  can_load = not not (next(SMODS.find_mod("Agarmons"))),
  config_key = "gmax_apples",
  init = init,
  misc_config = "gmax",
  list = { gmax_flapple }
}
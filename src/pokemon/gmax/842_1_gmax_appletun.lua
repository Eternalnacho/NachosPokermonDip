-- Hydrapple 1019
local gmax_appletun = {
  name = "gmax_appletun",
  config = { extra = { h_size = 3, money = 3, money1 = 3 } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'depleted'}
    return { vars = { card.ability.extra.money1 } }
  end,
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Appletun",
    text = {
      "{C:attention}+1{} hand size for",
      "each {C:agar_gmax}hand left{}",
      "{br:2}ERROR - CONTACT STEAK",
      "Earns {C:money}$#1#{} per",
      "{C:attention}depleted rank{} when",
      "hand is played"
    }
  },
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Dragon",
  gen = 8,
  blueprint_compat = true,
  poke_custom_values_to_keep = { "money" },
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.joker_main then
      local depleted = #PkmnDip.calc.get_depleted()
      local earned = pokermon.ease_poke_dollars(card, "appletun", a.money1 * depleted, true)
      return { dollars = earned }
    end
    if context.after and not context.blueprint then
      return {
        func = function()
          local h_size = a.h_size
          a.h_size = card.ability.gmax_turns_left - 1
          G.hand:change_size(a.h_size - h_size)
        end
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
  end,
  attach_gmax = function(self) PkmnDip.attach_gmax(self, 'nacho_appletun', 'gmax_apples') end,
  attributes = {"economy", "rank", "full_deck", "hand_size"}
}

local init = function()
  pokermon.add_to_family("appletun", "gmax_appletun")

  SMODS.Joker:take_ownership("nacho_appletun", {
    gmax = "gmax_appletun",
    poke_custom_values_to_keep = { "money" }
  }, true)
end

return {
  can_load = not not (next(SMODS.find_mod("Agarmons"))),
  config_key = "gmax_apples",
  init = init,
  misc_config = "gmax",
  list = { gmax_appletun }
}
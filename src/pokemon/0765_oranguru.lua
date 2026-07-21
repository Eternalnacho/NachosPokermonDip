-- Oranguru 765
local oranguru={
  name = "oranguru",
  config = {extra = {booster_choice_mod = 1}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = PkmnDip.calc.common_ranks_tooltip()
    return {vars = {}}
  end,
  rarity = 3,
  cost = 8,
  stage = "Basic",
  ptype = "Colorless",
  calculate = function(self, card, context)
    if context.open_booster and PkmnDip.con.in_booster('Standard') then
      PkmnDip.eff.mod_booster(card.ability.extra.booster_choice_mod)
    end
    if context.ending_booster and PkmnDip.con.in_booster('Standard') then
      PkmnDip.eff.mod_booster(-card.ability.extra.booster_choice_mod)
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if PkmnDip.con.in_booster('Standard') then
      PkmnDip.eff.mod_booster(card.ability.extra.booster_choice_mod)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    if PkmnDip.con.in_booster('Standard') then
      PkmnDip.eff.mod_booster(-card.ability.extra.booster_choice_mod)
    end
  end,
  attributes = {"passive", "full_deck"},
}

return {
  config_key = "oranguru",
  init = init,
  list = { oranguru }
}

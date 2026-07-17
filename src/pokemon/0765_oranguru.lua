-- Oranguru 765
local oranguru={
  name = "oranguru",
  config = {extra = {booster_choice_mod = 1}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = PkmnDip.common_ranks_tooltip()
    return {vars = {}}
  end,
  rarity = 3,
  cost = 8,
  stage = "Basic",
  ptype = "Colorless",
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.open_booster and context.booster.name:find('Standard') then
      G.GAME.modifiers.booster_choice_mod = (G.GAME.modifiers.booster_choice_mod or 0) + a.booster_choice_mod
      G.GAME.pack_choices = G.GAME.pack_choices + 1
      a.raised = true
    end

    if context.ending_booster and a.raised then
      G.GAME.modifiers.booster_choice_mod = math.max(0, (G.GAME.modifiers.booster_choice_mod or 0) - a.booster_choice_mod)
      a.raised = nil
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.ability.name:find('Standard') or G.STATE == G.STATES.STANDARD_PACK) then
      G.GAME.modifiers.booster_choice_mod = (G.GAME.modifiers.booster_choice_mod or 0) + card.ability.extra.booster_choice_mod
      G.GAME.pack_choices = G.GAME.pack_choices + 1
      card.ability.extra.raised = true
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    if card.ability.extra.raised then
      G.GAME.modifiers.booster_choice_mod = math.max(0, (G.GAME.modifiers.booster_choice_mod or 0) - card.ability.extra.booster_choice_mod)
    end

    if (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.ability.name:find('Standard') or G.STATE == G.STATES.STANDARD_PACK) then
      G.GAME.modifiers.booster_choice_mod = math.max(0, (G.GAME.modifiers.booster_choice_mod or 0) - card.ability.extra.booster_choice_mod)
      G.GAME.pack_choices = math.max(0, G.GAME.pack_choices - 1)
      if G.GAME.pack_choices <= 0 then
        G.FUNCS.end_consumeable(nil)
      end
    end
  end,
  attributes = {"passive", "full deck"},
}

return {
  config_key = "oranguru",
  init = init,
  list = { oranguru }
}

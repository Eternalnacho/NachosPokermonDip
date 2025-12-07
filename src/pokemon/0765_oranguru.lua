-- Oranguru 765
local oranguru={
  name = "oranguru",
  config = {extra = {booster_choice_mod = 1}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    common_ranks_tooltip(self, info_queue)
    return {vars = {}}
  end,
  designer = "Eternalnacho",
  rarity = 3,
  cost = 8,
  stage = "Basic",
  ptype = "Colorless",
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.open_booster and not context.blueprint then
      if context.card.ability.name:find('Standard') then
        -- set booster_choice_mod if not raised
        if not card.ability.extra.raised then
          G.GAME.modifiers.booster_choice_mod = (G.GAME.modifiers.booster_choice_mod or 0) + card.ability.extra.booster_choice_mod
          G.GAME.pack_choices = G.GAME.pack_choices + 1
          card.ability.extra.raised = true
        end
      elseif card.ability.extra.raised then
        -- lower booster_choice_mod if raised, else do nothing
        G.GAME.modifiers.booster_choice_mod = math.max(0, (G.GAME.modifiers.booster_choice_mod or 0) - card.ability.extra.booster_choice_mod)
        G.GAME.pack_choices = math.max(0, G.GAME.pack_choices - 1)
        card.ability.extra.raised = false
      end
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
    if (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.ability.name:find('Standard') or G.STATE == G.STATES.STANDARD_PACK) then
      G.GAME.modifiers.booster_choice_mod = math.max(0, (G.GAME.modifiers.booster_choice_mod or 0) - card.ability.extra.booster_choice_mod)
      G.GAME.pack_choices = math.max(0, G.GAME.pack_choices - 1)
      if G.GAME.pack_choices <= 0 then
        G.FUNCS.end_consumeable(nil)
      end
    end
  end,
}

return {
  config_key = "oranguru",
  init = init,
  list = { oranguru }
}

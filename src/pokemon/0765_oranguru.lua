-- Oranguru 765
local oranguru={
  name = "oranguru",
  config = {extra = {raised = false}},
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
          if G.GAME.modifiers.booster_choice_mod then G.GAME.modifiers.booster_choice_mod = G.GAME.modifiers.booster_choice_mod + 1
          else G.GAME.modifiers.booster_choice_mod = 1 end
          -- set booster choices
          G.GAME.pack_choices =
            math.min((context.card.ability.choose or context.card.config.center.config.choose or 1) + (G.GAME.modifiers.booster_choice_mod or 0),
            context.card.ability.extra and math.max(1, context.card.ability.extra + (G.GAME.modifiers.booster_size_mod or 0)) or
            context.card.config.center.extra and math.max(1, context.card.config.center.extra + (G.GAME.modifiers.booster_size_mod or 0)) or 1)
          -- set raised to true
          card.ability.extra.raised = true
        end
      elseif card.ability.extra.raised then
        -- lower booster_choice_mod if raised, else do nothing
        if G.GAME.modifiers.booster_choice_mod then G.GAME.modifiers.booster_choice_mod = G.GAME.modifiers.booster_choice_mod - 1
        else G.GAME.modifiers.booster_choice_mod = 0 end
        G.GAME.pack_choices =
            math.min((context.card.ability.choose or context.card.config.center.config.choose or 1) + (G.GAME.modifiers.booster_choice_mod or 0),
            context.card.ability.extra and math.max(1, context.card.ability.extra + (G.GAME.modifiers.booster_size_mod or 0)) or
            context.card.config.center.extra and math.max(1, context.card.config.center.extra + (G.GAME.modifiers.booster_size_mod or 0)) or 1)
        card.ability.extra.raised = false
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.ability.name:find('Standard') or G.STATE == G.STATES.STANDARD_PACK) then
      if not card.ability.extra.raised then
        if G.GAME.modifiers.booster_choice_mod then
          G.GAME.modifiers.booster_choice_mod = G.GAME.modifiers.booster_choice_mod + 1
        else
          G.GAME.modifiers.booster_choice_mod = 1
        end
        G.GAME.pack_choices =
            math.min((context.card.ability.choose or context.card.config.center.config.choose or 1) + (G.GAME.modifiers.booster_choice_mod or 0),
            context.card.ability.extra and math.max(1, context.card.ability.extra + (G.GAME.modifiers.booster_size_mod or 0)) or
            context.card.config.center.extra and math.max(1, context.card.config.center.extra + (G.GAME.modifiers.booster_size_mod or 0)) or 1)
        card.ability.extra.raised = true
      end
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    if card.ability.extra.raised then
      if G.GAME.modifiers.booster_choice_mod then
        G.GAME.modifiers.booster_choice_mod = G.GAME.modifiers.booster_choice_mod - 1
      else
        G.GAME.modifiers.booster_choice_mod = 0
      end
      if (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.ability.name:find('Standard') or G.STATE == G.STATES.STANDARD_PACK) then
        G.GAME.pack_choices =
            math.min((context.card.ability.choose or context.card.config.center.config.choose or 1) + (G.GAME.modifiers.booster_choice_mod or 0),
            context.card.ability.extra and math.max(1, context.card.ability.extra + (G.GAME.modifiers.booster_size_mod or 0)) or
            context.card.config.center.extra and math.max(1, context.card.config.center.extra + (G.GAME.modifiers.booster_size_mod or 0)) or 1)
      end
      card.ability.extra.raised = false
    end
  end,
}

return {
  name = "Nacho's Oranguru",
  enabled = nacho_config.oranguru or false,
  list = { oranguru }
}

-- Skwovet 819
local skwovet={
  name = "skwovet",
  config = { extra = { mult = 0, mult_mod = 1, rounds = 5, in_blind = false }, evo_rqmt = 12 },
  loc_vars = function(self, info_queue, card)
    pokermon.type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod } }
  end,
  rarity = 1,
  cost = 5,
  stage = "Basic",
  ptype = "Colorless",
  gen = 8,
  perishable_compat = false,
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Consumable Used and in Blind
    if context.using_consumeable and G.GAME.blind.in_blind and not context.blueprint then
      SMODS.scale_card(card, {
        ref_value = 'mult',
        scalar_value = 'mult_mod',
        message_colour = G.C.MULT,
      })
    end
    -- Main Scoring
    if context.joker_main then
      return { mult = card.ability.extra.mult }
    end
    return pokermon.scaling_evo(self, card, context, "j_nacho_greedent", card.ability.extra.mult, self.config.evo_rqmt)
  end,
  attributes = {"mult", "scaling", "condition_evo"}
}

-- Greedent 820
local greedent={
  name = "greedent",
  config = { extra = { mult = 0, mult_mod = 1, num = 1, den = 8 } },
  loc_vars = function(self, info_queue, card)
    pokermon.type_tooltip(self, info_queue, card)
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, 'greedent')
    return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod, num, den } }
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "One",
  ptype = "Colorless",
  gen = 8,
  perishable_compat = false,
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Consumable used
    if context.using_consumeable and G.GAME.blind.in_blind then
      if not context.blueprint then
        SMODS.scale_card(card, {
          ref_value = 'mult',
          scalar_value = 'mult_mod',
          message_colour = G.C.MULT,
        })
      end
      -- 1 in 8 chance for Leftovers
      if SMODS.pseudorandom_probability(card, 'greedent', card.ability.extra.num, card.ability.extra.den, 'greedent') and not card.debuff and
          context.consumeable.config.center.key ~= 'c_poke_leftovers' then
        SMODS.add_card({set = 'poke_item', area = G.consumeables, edition = 'e_negative', key = 'c_poke_leftovers'})
        SMODS.calculate_effect({ message = localize('poke_stuff_cheeks_ex'), colour = G.C.SECONDARY_SET['poke_item'] }, card)
      end
    end
    -- Main Scoring
    if context.joker_main then
      return { mult = card.ability.extra.mult }
    end
  end,
  attributes = {"mult", "scaling", "chance", "item", "generation"}
}

return {
  config_key = "skwovet",
  list = { skwovet, greedent }
}

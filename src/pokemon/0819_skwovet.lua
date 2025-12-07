-- Skwovet 819
local skwovet={
  name = "skwovet",
  config = {extra = {mult = 0, mult_mod = 1, rounds = 5, in_blind = false}, evo_rqmt = 12},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod}}
  end,
  designer = "Eternalnacho",
  rarity = 1,
  cost = 5,
  stage = "Basic",
  ptype = "Colorless",
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    -- Check if blind starts
    if context.setting_blind and not context.blueprint then
      card.ability.extra.in_blind = true
      return
    end

    -- Consumable Used
    if context.using_consumeable and card.ability.extra.in_blind and not context.blueprint then
      card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
      return {
          message = localize('k_upgrade_ex'),
          colour = G.C.RED
        }
    end

    -- Main Scoring
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        return {
          mult = card.ability.extra.mult
        }
      end
    end

    -- reset "in blind" check
    if context.end_of_round and not context.game_over == true and context.main_eval and not context.blueprint then
      card.ability.extra.in_blind = false
    end
    return scaling_evo(self, card, context, "j_nacho_greedent", card.ability.extra.mult, self.config.evo_rqmt)
  end,
}

-- Greedent 820
local greedent={
  name = "greedent",
  config = {extra = {mult = 0, mult_mod = 1, num = 1, den = 8, in_blind = false}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, 'greedent')
    return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod, num, den}}
  end,
  designer = "Eternalnacho",
  rarity = "poke_safari",
  cost = 10,
  stage = "One",
  ptype = "Colorless",
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    -- Check if blind starts
    if context.setting_blind and not context.blueprint then
      card.ability.extra.in_blind = true
      return{}
    end

    -- Consumable used
    if context.using_consumeable and card.ability.extra.in_blind then
      if not context.blueprint then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
      end
      -- 1 in 4 chance for Leftovers
      if SMODS.pseudorandom_probability(card, 'greedent', card.ability.extra.num, card.ability.extra.den, 'greedent') and not card.debuff and
          context.consumeable.config.center.key ~= 'c_poke_leftovers' then
        local _card = create_card('Item', G.consumeables, nil, nil, nil, nil, 'c_poke_leftovers')
        local edition = {negative = true}
        _card:set_edition(edition, true)
        _card:add_to_deck()
        G.consumeables:emplace(_card)
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('poke_stuff_cheeks_ex'), colour = G.C.FILTER})
      end
      return {
          message = localize('k_upgrade_ex'),
          colour = G.C.RED
        }
    end

    -- Main Scoring
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        return {
          message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}, 
          colour = G.C.MULT,
          mult = card.ability.extra.mult
        }
      end
    end

    -- reset "in blind" check
    if context.end_of_round and not context.game_over == true and context.main_eval and not context.blueprint then
      card.ability.extra.in_blind = false
    end
  end,
}

return {
  config_key = "skwovet",
  list = { skwovet, greedent }
}

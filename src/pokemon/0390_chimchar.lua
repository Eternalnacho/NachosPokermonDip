-- Chimchar 390
local chimchar={
  name = "chimchar",
  config = {extra = {d_size = 1, mult = 0, max_scored = 0}, evo_rqmt = 4},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.d_size, card.ability.extra.mult, math.max(0, self.config.evo_rqmt - card.ability.extra.max_scored)}}
  end,
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Fire",
  starter = true,
  nacho_starter = true,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.pre_discard and not context.blueprint then
      local highest_rank = get_highest(context.full_hand)[1][1].base.nominal
      if card.ability.extra.mult < highest_rank then
        card.ability.extra.mult = highest_rank
        return { message = localize('k_upgrade_ex'), colour = G.C.RED }
      end
    end

    if context.joker_main then
      return { mult = card.ability.extra.mult }
    end

    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
      if card.ability.extra.mult >= 11 then
        card.ability.extra.max_scored = card.ability.extra.max_scored + 1
      end
      card.ability.extra.mult = 0
      return scaling_evo(self, card, context, "j_nacho_monferno", card.ability.extra.max_scored, self.config.evo_rqmt)
      or {
        message = localize('k_reset'),
        colour = G.C.RED
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
    ease_discard(card.ability.extra.d_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
    ease_discard(-card.ability.extra.d_size)
  end,
}

-- Monferno 391
local monferno={
  name = "monferno",
  config = {extra = {d_size = 1, mult = 0, max_scored = 0}, evo_rqmt = 4},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.d_size, card.ability.extra.mult, math.max(0, self.config.evo_rqmt - card.ability.extra.max_scored)}}
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Fire",
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.pre_discard and not context.blueprint then
      local highest_rank = get_highest(context.full_hand)[1][1].base.nominal
      card.ability.extra.mult = card.ability.extra.mult + highest_rank
      return { message = localize('k_upgrade_ex'), colour = G.C.RED }
    end

    if context.joker_main then
      return { mult = card.ability.extra.mult }
    end

    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
      if card.ability.extra.mult >= 30 then
        card.ability.extra.max_scored = card.ability.extra.max_scored + 1
      end
      card.ability.extra.mult = 0
      return scaling_evo(self, card, context, "j_nacho_infernape", card.ability.extra.max_scored, self.config.evo_rqmt)
      or {
        message = localize('k_reset'),
        colour = G.C.RED
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
    ease_discard(card.ability.extra.d_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
    ease_discard(-card.ability.extra.d_size)
  end,
}

-- Infernape 392
local infernape = {
  name = "infernape",
  config = {extra = {d_size = 1, mult = 30, Xmult = 1.0, Xmult_mod = 0.3}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.d_size, card.ability.extra.mult, card.ability.extra.Xmult_mod, card.ability.extra.Xmult}}
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Fire",
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.discard and not context.blueprint and not context.other_card.debuff then
      if context.other_card:is_face() or context.other_card:get_id() == 14 then
        card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.RED
        }
      end
    end

    if context.joker_main then
      return {
        message = localize("poke_close_combat_ex"),
        colour = G.C.XMULT,
        mult_mod = card.ability.extra.mult,
        Xmult_mod = card.ability.extra.Xmult,
      }
    end

    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
      card.ability.extra.Xmult = 1.0
      return {
        message = localize('k_reset'),
        colour = G.C.RED
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
    ease_discard(card.ability.extra.d_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
    ease_discard(-card.ability.extra.d_size)
  end,
}

return {
  config_key = "chimchar",
  list = { chimchar, monferno, infernape }
}

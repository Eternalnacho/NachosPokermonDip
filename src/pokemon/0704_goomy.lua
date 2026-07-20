-- Goomy 704
local goomy={
  name = "goomy",
  config = {extra = {mult_mod = 1, flushes = 0, flush_houses = 0}, evo_rqmt1 = 6, evo_rqmt2 = 1},
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.mult_mod,
        math.max(0, self.config.evo_rqmt1 - card.ability.extra.flushes),
        self.config.evo_rqmt1 - card.ability.extra.flushes == 1 and "Flush" or "Flushes"
      }
    }
  end,
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Dragon",
  gen = 6,
  pseudol = true,
  nacho_pseudol = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.press_play then
      a.scoring_flush = get_flush(G.hand.highlighted)[1]
      a.matching_suit = a.scoring_flush and PkmnDip.calc.get_flush_suit(G.hand.highlighted)
    end
    -- Check if Flush House played
    if context.before and not context.blueprint then
      if context.scoring_name == 'Flush' then
        a.flushes = a.flushes + 1
      elseif context.scoring_name == 'Flush House' then
        a.flush_houses = a.flush_houses + 1
      end
    end
    -- Main scoring bit
    if context.individual and PkmnDip.con.played_or_held(context) and not context.end_of_round then
      if next(context.poker_hands['Flush']) and a.scoring_flush then
        -- Give cards in hand with matching suit permamult
        if a.matching_suit == 'Any' or context.other_card:is_suit(a.matching_suit) then
          context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + a.mult_mod
          return {
            extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT },
            card = card
          }
        end
      end
    end
    return pokermon.scaling_evo(self, card, context, "j_nacho_hisuian_sliggoo", card.ability.extra.flush_houses, self.config.evo_rqmt2)
        or pokermon.scaling_evo(self, card, context, "j_nacho_sliggoo", card.ability.extra.flushes, self.config.evo_rqmt1)
  end,
  attributes = {"hand_type", "mult", "modify_card", "perma_bonus", "trigger_evo"},
}

-- Sliggoo 705
local sliggoo={
  name = "sliggoo",
  config = {extra = {mult_mod = 1, flushes = 0}, evo_rqmt = 8},
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.mult_mod,
        math.max(0, self.config.evo_rqmt - card.ability.extra.flushes),
        self.config.evo_rqmt - card.ability.extra.flushes == 1 and "Flush" or "Flushes"
      }
    }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Dragon",
  gen = 6,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.press_play then
      a.scoring_flush = get_flush(G.hand.highlighted)[1]
      a.matching_suit = a.scoring_flush and PkmnDip.calc.get_flush_suit(G.hand.highlighted)
    end
    -- Count # of Flushes played
    if context.before and not context.blueprint and context.scoring_name == 'Flush' then
      a.flushes = a.flushes + 1
    end
    -- Main effect
    if context.individual and context.scoring_name == 'Flush' and a.scoring_flush then
      if PkmnDip.con.played_or_held(context) and context.main_scoring then
        local unique_ranks = PkmnDip.utils.count_unique(context.scoring_hand, Card.get_id)
        if a.matching_suit == 'Any' or context.other_card:is_suit(a.matching_suit) then
          local perma_mult = context.other_card.ability.perma_mult
          perma_mult = (perma_mult or 0) + a.mult_mod * unique_ranks
          return {
            extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT },
            card = card
          }
        end
      end
    end
    return pokermon.scaling_evo(self, card, context, "j_nacho_goodra", card.ability.extra.flushes, self.config.evo_rqmt)
  end,
  attributes = {"hand_type", "mult", "modify_card", "perma_bonus", "trigger_evo"},
}

-- Goodra 706
local goodra={
  name = "goodra",
  config = {extra = {Xmult_multi = 0.02}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_multi}}
  end,
  rarity = "poke_safari",
  cost = 11,
  stage = "Two",
  ptype = "Dragon",
  gen = 6,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.press_play then
      a.scoring_flush = get_flush(G.hand.highlighted)[1]
      a.matching_suit = a.scoring_flush and PkmnDip.calc.get_flush_suit(G.hand.highlighted)
    end
    if context.individual and context.scoring_name == 'Flush' and a.scoring_flush then
      if PkmnDip.con.played_or_held(context) and context.main_scoring then
        local unique_ranks = PkmnDip.utils.count_unique(context.scoring_hand, Card.get_id)
        if a.matching_suit == 'Any' or context.other_card:is_suit(a.matching_suit) then
          local perma_x_mult = context.other_card.ability.perma_x_mult
          perma_x_mult = (perma_x_mult or 0) + a.Xmult_multi * unique_ranks
          return {
            extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT },
            card = card
          }
        end
      end
    end
  end,
  attributes = {"hand_type", "xmult", "modify_card", "perma_bonus"},
}

-- Hisuian Sliggoo 705-1
local hisuian_sliggoo={
  name = "hisuian_sliggoo",
  config = {extra = {flush_houses = 0}, evo_rqmt = 6},
  loc_vars = function(self, info_queue, card)
    return {vars = {math.max(0, self.config.evo_rqmt - card.ability.extra.flush_houses),
      self.config.evo_rqmt - card.ability.extra.flush_houses == 1 and "Flush House" or "Flush Houses"}}
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Metal",
  gen = 6,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before and context.main_eval and context.scoring_name == 'Flush House' then
      -- Count # of Flush Houses played
      if not context.blueprint then
        card.ability.extra.flush_houses = card.ability.extra.flush_houses + 1
      end
      -- Create a Metal Coat
      pokermon.create_consumeable('c_poke_metalcoat', true, card)
      -- Create a second Metal Coat if rank difference > 6
      local first_rank, second_rank = PkmnDip.calc.get_full_house(context.scoring_hand, 'nominal')
      if math.abs(second_rank - first_rank) > 6 then
        pokermon.create_consumeable('c_poke_metalcoat', true, card)
      end
    end
    return pokermon.scaling_evo(self, card, context, "j_nacho_hisuian_goodra", card.ability.extra.flush_houses, self.config.evo_rqmt)
  end,
  in_pool = function(self) return G.GAME.hands['Flush House'].played > 0 end,
  attributes = {"hand_type", "generation", "item", "trigger_evo"},
}

-- Hisuian Goodra 706-1
local hisuian_goodra={
  name = "hisuian_goodra",
  config = {extra = {Xmult_steel = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {}}
  end,
  rarity = "poke_safari",
  cost = 11,
  stage = "Two",
  ptype = "Metal",
  gen = 6,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.scoring_name == 'Flush House' then
      -- Create a metal coat
      if context.before and context.main_eval then
        pokermon.create_held_item('c_poke_metalcoat', true, card)
      end
      -- Score held steel cards by rank difference in Flush House
      if context.individual and context.cardarea == G.hand and not context.end_of_round then
        local first_rank, second_rank = PkmnDip.calc.get_full_house(context.scoring_hand, 'nominal')
        a.Xmult_steel = math.abs(second_rank - first_rank) / 3
        if a.Xmult_steel > 1 and SMODS.has_enhancement(context.other_card, 'm_steel') then
          return { xmult = a.Xmult_steel }
        end
      end
    end
  end,
  in_pool = function(self) return G.GAME.hands['Flush House'].played > 0 end,
  attributes = {"hand_type", "enhancements", "generation", "item", "xmult"},
}

return {
  config_key = "goomy",
  list = { goomy, sliggoo, goodra, hisuian_sliggoo, hisuian_goodra}
}

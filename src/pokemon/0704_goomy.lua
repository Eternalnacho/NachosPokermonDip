-- Goomy 704
local goomy={
  name = "goomy",
  config = {extra = {mult_mod = 1, flushes = 0, flush_houses = 0}, evo_rqmt1 = 6, evo_rqmt2 = 1},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.mult_mod,
        math.max(0, self.config.evo_rqmt1 - card.ability.extra.flushes),
        self.config.evo_rqmt1 - card.ability.extra.flushes == 1 and "Flush" or "Flushes"
      }
    }
  end,
  designer = "Eternalnacho",
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Dragon",
  gen = 6,
  pseudol = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Check if Flush House played
    if context.before and context.main_eval then
      if context.scoring_name == 'Flush' then
        card.ability.extra.flushes = card.ability.extra.flushes + 1
        return
      elseif context.scoring_name == 'Flush House' then
        card.ability.extra.flush_houses = card.ability.extra.flush_houses + 1
        return
      end
    end
    -- Main scoring bit
    if context.individual and (context.cardarea == G.hand or context.cardarea == G.play) and not context.end_of_round then
      if next(context.poker_hands['Flush']) then
        -- Get cards specifically in Flush
        local scoring_flush = get_flush(context.scoring_hand)[1]
        local wildcount = 0
        local matching_suit = nil
        -- Count # of wilds and determine Flush suit
        if scoring_flush then
          for i = 1, #scoring_flush do
            if SMODS.has_enhancement(scoring_flush[i], 'm_wild') then wildcount = wildcount + 1
            else matching_suit = scoring_flush[i].config.card.suit end
          end
          -- Give cards in hand with matching suit permamult
          if wildcount == #scoring_flush or context.other_card:is_suit(matching_suit) then
            context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + card.ability.extra.mult_mod
            return {
              extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
              colour = G.C.MULT,
              card = card
            }
          end
        end
      end
    end
    return scaling_evo(self, card, context, "j_nacho_hisuian_sliggoo", card.ability.extra.flush_houses, self.config.evo_rqmt2)
        or scaling_evo(self, card, context, "j_nacho_sliggoo", card.ability.extra.flushes, self.config.evo_rqmt1)
  end
}

-- Sliggoo 705
local sliggoo={
  name = "sliggoo",
  config = {extra = {mult_mod = 1, flushes = 0}, evo_rqmt = 8},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.mult_mod,
        math.max(0, self.config.evo_rqmt - card.ability.extra.flushes),
        self.config.evo_rqmt - card.ability.extra.flushes == 1 and "Flush" or "Flushes"
      }
    }
  end,
  designer = "Eternalnacho",
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Dragon",
  gen = 6,
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Count # of Flushes played
    if context.before and context.main_eval and context.scoring_name == 'Flush' then
      card.ability.extra.flushes = card.ability.extra.flushes + 1
      return
    end
    if context.individual and (context.cardarea == G.hand or context.cardarea == G.play) and not context.end_of_round then
      if context.scoring_name == 'Flush' then
        -- Get the scoring cards that make up the Flush only
        local scoring_flush = get_flush(context.scoring_hand)[1]
        local wildcount = 0
        local matching_suit = nil
        local unique_ranks = {}
        -- Count the unique ranks in scoring hand
        for i = 1, #context.scoring_hand do
          if not PkmnDip.utils.contains(unique_ranks, context.scoring_hand[i]:get_id()) then
            unique_ranks[#unique_ranks+1] = context.scoring_hand[i]:get_id()
          end
        end
        -- Count the # of wild cards and determine Flush suit
        for i = 1, #scoring_flush do
          if SMODS.has_enhancement(scoring_flush[i], 'm_wild') then wildcount = wildcount + 1
          else matching_suit = scoring_flush[i].config.card.suit end
        end
        -- Increment permamult if card matches Flush suit
        if wildcount == #scoring_flush or context.other_card:is_suit(matching_suit) then
          context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + card.ability.extra.mult_mod * #unique_ranks
          return {
            extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
            colour = G.C.MULT,
            card = card
          }
        end
      end
    end
    return scaling_evo(self, card, context, "j_nacho_goodra", card.ability.extra.flushes, self.config.evo_rqmt)
  end,
}

-- Goodra 706
local goodra={
  name = "goodra",
  config = {extra = {Xmult_multi = 0.02}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_multi}}
  end,
  designer = "Eternalnacho",
  rarity = "poke_safari",
  cost = 11,
  stage = "Two",
  ptype = "Dragon",
  gen = 6,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and (context.cardarea == G.hand or G.play) and not context.end_of_round then
      if context.scoring_name == 'Flush' then
        -- Get the scoring cards that make up the Flush only
        local scoring_flush = get_flush(context.scoring_hand)[1]
        local wildcount = 0
        local matching_suit = nil
        local unique_ranks = {}
        -- Count the unique ranks in scoring hand
        for i = 1, #context.scoring_hand do
          if not PkmnDip.utils.contains(unique_ranks, context.scoring_hand[i]:get_id()) then
            unique_ranks[#unique_ranks+1] = context.scoring_hand[i]:get_id()
          end
        end
        -- Count the # of wild cards and determine Flush suit
        for i = 1, #scoring_flush do
          if SMODS.has_enhancement(scoring_flush[i], 'm_wild') then wildcount = wildcount + 1
          else matching_suit = scoring_flush[i].config.card.suit end
        end
        -- Increment permamult if card matches Flush suit
        if wildcount == #scoring_flush or context.other_card:is_suit(matching_suit) then
          context.other_card.ability.perma_x_mult = (context.other_card.ability.perma_x_mult or 0) + card.ability.extra.Xmult_multi * #unique_ranks
          return {
            extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
            colour = G.C.MULT,
            card = card
          }
        end
      end
    end
  end,
}

-- Hisuian Sliggoo 705-1
local hisuian_sliggoo={
  name = "hisuian_sliggoo",
  config = {extra = {flush_houses = 0}, evo_rqmt = 6},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {math.max(0, self.config.evo_rqmt - card.ability.extra.flush_houses),
      self.config.evo_rqmt - card.ability.extra.flush_houses == 1 and "Flush House" or "Flush Houses"}}
  end,
  designer = "Eternalnacho",
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Metal",
  gen = 6,
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Count # of Flush Houses played
    if context.before and context.main_eval and context.scoring_name == 'Flush House' then
      card.ability.extra.flush_houses = card.ability.extra.flush_houses + 1
      return
    end
    -- Main function
    if context.joker_main and context.scoring_name == 'Flush House' then
      -- get the different ranks of the Full House
      local part_major = get_X_same(3, context.scoring_hand, true)[1][1]
      local part_minor = get_X_same(2, PkmnDip.utils.filter(context.scoring_hand, function(v) return v:get_id() ~= part_major:get_id() end), true)[1][1]
      local first_rank = part_major.base.nominal
      local second_rank = part_minor.base.nominal
      -- Create metal coat
      if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        local _card = SMODS.add_card({set = 'Item', area = G.consumeables, key = 'c_poke_metalcoat'})
        card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('poke_plus_pokeitem'), colour = G.C.FILTER})
      end
      -- Create second metal coat if the difference in scoring ranks is > 6
      if math.abs(second_rank - first_rank) > 6 then
        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
          local _card = SMODS.add_card({set = 'Item', area = G.consumeables, key = 'c_poke_metalcoat'})
          card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('poke_plus_pokeitem'), colour = G.C.FILTER})
        end
      end
    end
    return scaling_evo(self, card, context, "j_nacho_hisuian_goodra", card.ability.extra.flush_houses, self.config.evo_rqmt)
  end,
}

-- Hisuian Goodra 706-1
local hisuian_goodra={
  name = "hisuian_goodra",
  config = {extra = {Xmult = 1}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {}}
  end,
  designer = "Eternalnacho",
  rarity = "poke_safari",
  cost = 11,
  stage = "Two",
  ptype = "Metal",
  gen = 6,
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Create a Metal Coat if Flush House played
    if context.before and context.main_eval and context.scoring_name == 'Flush House' then
      -- Create metal coat
      if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        local _card = SMODS.add_card({set = 'Item', area = G.consumeables, key = 'c_poke_metalcoat'})
        card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('poke_plus_pokeitem'), colour = G.C.FILTER})
      end
    end
    if context.individual and context.cardarea == G.hand and not context.end_of_round then
      if context.scoring_name == 'Flush House' then
        -- get the different ranks of the Full House
        local part_major = get_X_same(3, context.scoring_hand, true)[1][1]
        local part_minor = get_X_same(2, PkmnDip.utils.filter(context.scoring_hand, function(v) return v:get_id() ~= part_major:get_id() end), true)[1][1]
        local first_rank = part_major.base.nominal
        local second_rank = part_minor.base.nominal
        -- Set Xmult_mod
        card.ability.extra.Xmult = math.abs(second_rank - first_rank) / 3
        -- Score Steel cards in hand
        if SMODS.has_enhancement(context.other_card, 'm_steel') and card.ability.extra.Xmult > 1 then
          return{
            xmult = card.ability.extra.Xmult,
            card = card,
          }
        end
      end
    end
  end,
}

return {
  config_key = "goomy",
  list = { goomy, sliggoo, goodra, hisuian_sliggoo, hisuian_goodra}
}

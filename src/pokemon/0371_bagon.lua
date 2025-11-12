-- Bagon 371
local bagon={
  name = "bagon",
  config = {extra = {mult = 0}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local high_count = G.playing_cards and G.STAGE == G.STAGES.RUN and #PkmnDip.utils.filter(G.playing_cards, function(v) return v.base.nominal >= 9 end) or 0
    local deck_data = G.playing_cards and G.STAGE == G.STAGES.RUN and ' ['..tostring(high_count)..'/'..tostring(math.ceil(#G.playing_cards * 9 / 16))..']' or ''
    return {vars = {deck_data}}
  end,
  designer = "Eternalnacho",
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Dragon",
  gen = 3,
  pseudol = true,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.before and context.scoring_name == "Two Pair" then
      for k, v in pairs(G.hand.cards) do
        if v == G.hand.cards[#G.hand.cards] then
          -- This whole set of events is just the Strength Tarot from VanillaRemade
          G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.4,
          func = function()
              play_sound('tarot1')
              card:juice_up(0.3, 0.5)
              return true
          end
          }))
          local percent = 1.15 - ((v:get_id() / 7) - 0.999) / ((v:get_id() / 7) - 0.998) * 0.3
          G.E_MANAGER:add_event(Event({
              trigger = 'after',
              delay = 0.15,
              func = function()
                  v:flip()
                  play_sound('card1', percent)
                  v:juice_up(0.3, 0.3)
                  return true
              end
          }))
          delay(0.2)
          G.E_MANAGER:add_event(Event({
              trigger = 'after',
              delay = 0.1,
              func = function()
                  -- SMODS.modify_rank will increment/decrement a given card's rank by a given amount
                  assert(SMODS.modify_rank(v, math.min(14 - v:get_id(), 1)))
                  return true
              end
          }))
          local percent = 0.85 + ((v:get_id() / 7) - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
          G.E_MANAGER:add_event(Event({
              trigger = 'after',
              delay = 0.15,
              func = function()
                  v:flip()
                  play_sound('tarot2', percent, 0.6)
                  v:juice_up(0.3, 0.3)
                  return true
              end
          }))
          delay(0.5)
        end
      end
    end
    -- Scoring effect
    if context.individual and context.cardarea == G.play and context.scoring_name == "Two Pair" then
      return{
        mult = context.other_card.base.nominal / 3,
        card = context.other_card or card
      }
    end
    return deck_rank_evo(self, card, context, "j_nacho_shelgon", 9, .57)
  end
}

-- Shelgon 372
local shelgon={
  name = "shelgon",
  config = {extra = {mult = 0}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local high_count = G.playing_cards and G.STAGE == G.STAGES.RUN and #PkmnDip.utils.filter(G.playing_cards, function(v) return v.base.nominal >= 9 end) or 0
    local deck_data = G.playing_cards and G.STAGE == G.STAGES.RUN and ' ['..tostring(high_count)..'/'..tostring(math.ceil(#G.playing_cards * 3 / 4))..']' or ''
    return {vars = {deck_data}}
  end,
  designer = "Eternalnacho",
  rarity = "poke_safari",
  cost = 9,
  stage = "One",
  ptype = "Dragon",
  gen = 3,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.before and context.scoring_name == "Two Pair" then
      for k, v in pairs(G.hand.cards) do
        if v == G.hand.cards[#G.hand.cards] or v == G.hand.cards[#G.hand.cards - 1] then
          -- This whole set of events is just the Strength Tarot from VanillaRemade
          G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.4,
          func = function()
              play_sound('tarot1')
              card:juice_up(0.3, 0.5)
              return true
          end
          }))
          local percent = 1.15 - ((v:get_id() / 7) - 0.999) / ((v:get_id() / 7) - 0.998) * 0.3
          G.E_MANAGER:add_event(Event({
              trigger = 'after',
              delay = 0.15,
              func = function()
                  v:flip()
                  play_sound('card1', percent)
                  v:juice_up(0.3, 0.3)
                  return true
              end
          }))
          delay(0.2)
          G.E_MANAGER:add_event(Event({
              trigger = 'after',
              delay = 0.1,
              func = function()
                  -- SMODS.modify_rank will increment/decrement a given card's rank by a given amount
                  assert(SMODS.modify_rank(v, math.min(14 - v:get_id(), 1)))
                  return true
              end
          }))
          local percent = 0.85 + ((v:get_id() / 7) - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
          G.E_MANAGER:add_event(Event({
              trigger = 'after',
              delay = 0.15,
              func = function()
                  v:flip()
                  play_sound('tarot2', percent, 0.6)
                  v:juice_up(0.3, 0.3)
                  return true
              end
          }))
          delay(0.5)
        end
      end
    end
    -- Scoring effect
    if context.individual and context.cardarea == G.play and context.scoring_name == "Two Pair" then
      return{
        mult = context.other_card.base.nominal / 2,
        card = context.other_card or card
      }
    end
    return deck_rank_evo(self, card, context, "j_nacho_salamence", 9, .75)
  end
}

-- Salamence 373
local salamence={
  name = "salamence",
  config = {extra = {Xmult = 0.1}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult}}
  end,
  designer = "Eternalnacho",
  rarity = "poke_safari",
  cost = 11,
  stage = "Two",
  ptype = "Dragon",
  gen = 3,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if context.scoring_name == "Two Pair" then
        local avg_rank = 0
          for k, v in pairs(G.playing_cards) do
            avg_rank = v.base.nominal + avg_rank
          end
        avg_rank = avg_rank / #G.playing_cards
        return{
          Xmult = 1 + avg_rank * card.ability.extra.Xmult,
          card = context.other_card or card
        }
      end
    end
  end,
  megas = {"mega_salamence"},
}

-- Mega Salamence 373-1
local mega_salamence={
  name = "mega_salamence",
  config = {extra = {Xmult = 1.5, retriggers = 1}},
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {center.ability.extra.Xmult}}
  end,
  designer = "Eternalnacho",
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Dragon",
  gen = 3,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.scoring_name == "Two Pair" then
      return {
        xmult = card.ability.extra.Xmult,
        card = context.other_card or card
      }
    end
    if context.repetition and not context.end_of_round and context.cardarea == G.play and context.other_card:get_id() > 9 then
      card.ability.extra.retriggers = math.max(context.other_card.base.nominal - 9, 0)
      return {
        message = localize('k_again_ex'),
        repetitions = card.ability.extra.retriggers,
        card = card
      }
    end
  end,
}

return {
  name = "Nacho's Bagon Evo Line",
  enabled = nacho_config.bagon or false,
  list = { bagon, shelgon, salamence, mega_salamence }
}

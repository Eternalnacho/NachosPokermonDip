function copy_card_to_play(joker, card)
  for _ = 1, joker.ability.extra.dip_card_dupes do
    if #G.play.cards < 5 then
      local copy = copy_card(card)
      copy:add_to_deck()
      G.deck.config.card_limit = G.deck.config.card_limit + 1
      table.insert(G.playing_cards, copy)
      G.play:emplace(copy)
      copy.states.visible = nil
      copy:start_materialize()
      G.E_MANAGER:add_event(Event({
        func = function()
          G.play:add_to_highlighted(copy)
          return true
        end
      }))
      table.insert(joker.ability.extra.copied_cards, copy.unique_val)
      if joker.ability.extra.copies_req then joker.ability.extra.copies_req = joker.ability.extra.copies_req + 1 end
      playing_card_joker_effects(copy)
    end
  end
end

-- Solosis 577
local solosis = {
  name = "solosis",
  config = { extra = { dip_card_dupes = 1, copied_cards = {}, copies_req = 0 }, evo_rqmt = 4 },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.dip_card_dupes, math.max(0, self.config.evo_rqmt - card.ability.extra.copies_req) } }
  end,
  rarity = 3,
  cost = 7,
  stage = "Basic",
  ptype = "Psychic",
  gen = 5,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    -- First hand of round jiggle a la DNA
    if context.first_hand_drawn and not context.blueprint then
      local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
      juice_card_until(card, eval, true)
    end
    -- I made a custom context for this effect
    if context.mitosis and G.GAME.current_round.hands_played == 0 then
      copy_card_to_play(card, G.play.cards[1])
    end
    -- destroy the temporary copies after scoring them
    if context.destroy_card and card.ability.extra.copied_cards and not context.blueprint then
      for _, v in pairs(card.ability.extra.copied_cards) do
        if v == context.destroy_card.unique_val then return {remove = true} end
      end
    end
    return scaling_evo(self, card, context, "j_nacho_duosion", card.ability.extra.copies_req, self.config.evo_rqmt)
  end,
}

-- Duosion 578
local duosion = {
  name = "duosion",
  config = { extra = { dip_card_dupes = 2, copied_cards = {}, copies_req = 0 }, evo_rqmt = 8 },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.dip_card_dupes, math.max(0, self.config.evo_rqmt - card.ability.extra.copies_req) } }
  end,
  rarity = "poke_safari",
  cost = 9,
  stage = "One",
  ptype = "Psychic",
  gen = 5,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.first_hand_drawn and not context.blueprint then
      local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
      juice_card_until(card, eval, true)
    end
    -- I made a custom context for this effect
    if context.mitosis and G.GAME.current_round.hands_played == 0 then
      copy_card_to_play(card, G.play.cards[1])
    end
    -- destroy the temporary copies after scoring them
    if context.destroy_card and card.ability.extra.copied_cards and not context.blueprint then
      for _, v in pairs(card.ability.extra.copied_cards) do
        if v == context.destroy_card.unique_val then return {remove = true} end
      end
    end
    return scaling_evo(self, card, context, "j_nacho_reuniclus", card.ability.extra.copies_req, self.config.evo_rqmt)
  end,
}

local reuniclus = {
  name = "reuniclus",
  config = { extra = { dip_card_dupes = 2, copied_cards = {} } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.dip_card_dupes } }
  end,
  rarity = "poke_safari",
  cost = 11,
  stage = "Two",
  ptype = "Psychic",
  gen = 5,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    -- I made a custom context for this effect
    if context.mitosis then
      copy_card_to_play(card, G.play.cards[1])
    end
    -- destroy the temporary copies after scoring them
    if context.destroy_card and card.ability.extra.copied_cards and not context.blueprint then
      for _, v in pairs(card.ability.extra.copied_cards) do
        if v == context.destroy_card.unique_val then return {remove = true} end
      end
    end
  end,
}

local function init()
  if (SMODS.Mods["Talisman"] or {}).can_load then
    local evaluate_play_intro_ref = evaluate_play_intro
    evaluate_play_intro = function()
      SMODS.calculate_context({mitosis = true})
      return evaluate_play_intro_ref()
    end
  else
    local eval_play_ref = G.FUNCS.evaluate_play
    G.FUNCS.evaluate_play = function(e)
      SMODS.calculate_context({mitosis = true})
      return eval_play_ref(e)
    end
  end
end

return {
  config_key = "solosis",
  init = init,
  list = { solosis, duosion, reuniclus }
}

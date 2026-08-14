-- Solosis 577
local solosis = {
  name = "solosis",
  config = { extra = { copies = 1, copies_made = 0 }, evo_rqmt = 4 },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.copies, math.max(0, self.config.evo_rqmt - card.ability.extra.copies_made) } }
  end,
  rarity = 3,
  cost = 7,
  stage = "Basic",
  ptype = "Psychic",
  gen = 5,
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- First hand of round jiggle a la DNA
    if context.first_hand_drawn and not context.blueprint then
      local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
      juice_card_until(card, eval, true)
    end

    -- Copy the first scoring card if there are open slots to do it
    if context.press_play and G.GAME.current_round.hands_played == 0 then
      PkmnDip.defer(function()
        local copies = {}
        local delta = G.GAME.starting_params.play_limit - #G.play.cards
        if delta > 0 then
          for _ = 1, math.min(card.ability.extra.copies, delta) do
            local copy = SMODS.copy_card(G.play.cards[1], {area = G.play})
            copies[#copies+1] = copy
            copy.is_solosis_copy = true
            card.ability.extra.copies_made = card.ability.extra.copies_made + 1
          end
        end
        if next(copies) then
          SMODS.calculate_context({ playing_card_added = true, cards = copies })
        end
      end, {delay = 0.2, blockable = true})
    end

    -- destroy the temporary copies after scoring them
    if context.destroy_card and context.destroy_card.is_solosis_copy and not context.blueprint then
      return {remove = true}
    end
  
    return pokermon.scaling_evo(self, card, context, "j_nacho_duosion", card.ability.extra.copies_made, self.config.evo_rqmt)
  end,
  attributes = {"generation", "hands", "condition_evo"},
}

-- Duosion 578
local duosion = {
  name = "duosion",
  config = { extra = { copies = 2, copies_made = 0 }, evo_rqmt = 8 },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.copies, math.max(0, self.config.evo_rqmt - card.ability.extra.copies_made) } }
  end,
  rarity = "poke_safari",
  cost = 9,
  stage = "One",
  ptype = "Psychic",
  gen = 5,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.first_hand_drawn and not context.blueprint then
      local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
      juice_card_until(card, eval, true)
    end
    -- Copy the first scoring card if there are open slots to do it
    if context.press_play and G.GAME.current_round.hands_played == 0 then
      PkmnDip.defer(function()
        local copies = {}
        local delta = G.GAME.starting_params.play_limit - #G.play.cards
        if delta > 0 then
          for _ = 1, math.min(card.ability.extra.copies, delta) do
            local copy = SMODS.copy_card(G.play.cards[1], {area = G.play})
            copies[#copies+1] = copy
            copy.is_solosis_copy = true
            card.ability.extra.copies_made = card.ability.extra.copies_made + 1
          end
        end
        if next(copies) then
          SMODS.calculate_context({ playing_card_added = true, cards = copies })
        end
      end, {delay = 0.2, blockable = true})
    end

    -- destroy the temporary copies after scoring them
    if context.destroy_card and context.destroy_card.is_solosis_copy and not context.blueprint then
      return {remove = true}
    end

    return pokermon.scaling_evo(self, card, context, "j_nacho_reuniclus", card.ability.extra.copies_made, self.config.evo_rqmt)
  end,
  attributes = {"generation", "hands", "condition_evo"},
}

local reuniclus = {
  name = "reuniclus",
  config = { extra = { copies = 2 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.copies } }
  end,
  rarity = "poke_safari",
  cost = 11,
  stage = "Two",
  ptype = "Psychic",
  gen = 5,
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Copy the first scoring card if there are open slots to do it
    if context.press_play then
      PkmnDip.defer(function()
        local copies = {}
        local delta = G.GAME.starting_params.play_limit - #G.play.cards
        if delta > 0 then
          for _ = 1, math.min(card.ability.extra.copies, delta) do
            local copy = SMODS.copy_card(G.play.cards[1], {area = G.play})
            copies[#copies+1] = copy
            copy.is_solosis_copy = true
          end
        end
        if next(copies) then
          SMODS.calculate_context({ playing_card_added = true, cards = copies })
        end
      end, {delay = 0.2, blockable = true})
    end

    -- destroy the temporary copies after scoring them
    if context.destroy_card and context.destroy_card.is_solosis_copy and not context.blueprint then
      return {remove = true}
    end
  end,
  attributes = {"generation"},
}

return {
  config_key = "solosis",
  list = { solosis, duosion, reuniclus }
}

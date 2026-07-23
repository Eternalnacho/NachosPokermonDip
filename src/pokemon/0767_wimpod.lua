-- Wimpod 767
local wimpod = {
  name = "wimpod",
  config = { extra = { chips = 30, rounds = 4 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.rounds } }
  end,
  designer = "One Punch Idiot",
  nacho_from_bfp = true,
  rarity = 1,
  cost = 5,
  stage = "Basic",
  ptype = "Grass",
  gen = 7,
  blueprint_compat = true,
  eternal_compat = false,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.before and context.cardarea == G.jokers and not context.blueprint
        and G.GAME.current_round.hands_played >= 1 then
      PkmnDip.eff.faint(card)
      a.no_score = true
    end
    if context.joker_main and not a.no_score then
      return { chips = a.chips }
    end
    if context.end_of_round and not context.blueprint then
      a.no_score = nil
    end
    return pokermon.level_evo(self, card, context, 'j_nacho_golisopod')
  end
}

-- Golisopod 768
local golisopod = {
  name = "golisopod",
  config = { extra = { Xmult = 3, h_size = 1 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult } }
  end,
  designer = "One Punch Idiot",
  nacho_from_bfp = true,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Grass",
  gen = 7,
  blueprint_compat = true,
  eternal_compat = false,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.before and context.cardarea == G.jokers and not context.blueprint
        and G.GAME.current_round.hands_played >= 1 then
      PkmnDip.eff.faint(card)
      a.no_score = true
      a.ante_debuffed = true
    end
    if context.joker_main and not a.no_score then
      return { Xmult = a.Xmult }
    end
    if context.end_of_round and context.main_eval and not context.blueprint then
      if context.beat_boss then
        if not a.ante_debuffed then
          G.hand:change_size(a.h_size)
          a.raised = true
        end
        a.ante_debuffed = nil
      end
      a.no_score = nil
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    local a = card.ability.extra
    if a.raised and from_debuff then
      G.hand:change_size(a.h_size)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    local a = card.ability.extra
    G.hand:change_size(a.raised and -a.h_size or 0)
    if a.ante_debuffed then a.raised = nil end
  end,
}

return {
  config_key = "wimpod",
  list = { wimpod, golisopod }
}

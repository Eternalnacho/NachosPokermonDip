-- Audino 531
local audino = {
  name = "audino",
  config = {extra = {Xmult = 1, Xmult_mod = 0.25}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult, card.ability.extra.Xmult_mod}}
  end,
  designer = "T.F. Wright",
  rarity = 3,
  cost = 8,
  stage = "Basic",
  ptype = "Colorless",
  gen = 5,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.poke_evolved and not context.blueprint then
      SMODS.scale_card(card, {
        ref_value = 'Xmult',
        scalar_value = 'Xmult_mod',
        message_key = 'a_xmult',
        message_colour = G.C.XMULT,
      })
    end
    if context.joker_main then
      return {xmult = card.ability.extra.Xmult}
    end
    if context.evolution and not context.audino_retrigger and not context.blueprint then
      SMODS.calculate_context({ evolution = true, audino_retrigger = true })
    end
  end,
  megas = {"mega_audino"},
  attributes = {"passive", "joker", "scaling", "xmult"}
}

-- Mega Audino 531-1
local mega_audino = {
  name = "mega_audino",
  config = {extra = {Xmult = 1, Xmult_mod = 0.25, num = 1, den = 5}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'incubator'}
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, 'mega_audino')
    return {vars = {card.ability.extra.Xmult, num, den}}
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Fairy",
  gen = 5,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.joker_main then
      return {xmult = a.Xmult}
    end

    if context.end_of_round and context.beat_boss and context.game_over == false and not context.blueprint then
      local adj = pokermon.get_adjacent_jokers(card)
      -- Pre-call function to set the edition
      local poll_audino_edition = function(args)
        local shiny_odds = SMODS.pseudorandom_probability(card, 'mega_audino', a.num, a.den)
        args.edition = shiny_odds and 'e_poke_shiny' or poll_edition('mega_audino', nil, true, true, {
          { name = 'e_foil', weight = 1/3 },
          { name = 'e_holo', weight = 1/3 },
          { name = 'e_polychrome', weight = 1/3 }
        })
      end
      -- Post-call function to set the rounds to hatch
      local incubate = function(egg) egg.ability.extra.rounds = 1 end
      -- The actual effect
      PkmnDip.eff.breed(card, adj, poll_audino_edition, incubate)
      PkmnDip.defer(function() play_sound('timpani') end)
    end
  end,
  attributes = {"generation", "joker", "xmult", "boss_blind"}
}

return {
  config_key = "audino",
  list = { audino, mega_audino }
}

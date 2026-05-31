-- Audino 531
local audino = {
  name = "audino",
  config = {extra = {Xmult = 1, Xmult_mod = 0.25}},
  loc_vars = function(self, info_queue, card)
    pokermon.type_tooltip(self, info_queue, card)
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
    if context.poke_evolved then
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
  end,
  megas = {"mega_audino"},
  attributes = {"passive", "joker", "scaling", "xmult"}
}

-- Mega Audino 531-1
local mega_audino = {
  name = "mega_audino",
  config = {extra = {Xmult = 1, Xmult_mod = 0.25, num = 1, den = 5}},
  loc_vars = function(self, info_queue, card)
    pokermon.type_tooltip(self, info_queue, card)
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
      local adjacent_jokers = pokermon.get_adjacent_jokers(card)
      local incompatible = { "Other", "Baby", "Legendary" }
      local breedable = #PkmnDip.utils.filter(adjacent_jokers, function(adj_joker)
        local lowest_key = create_full_poke_key(adj_joker, pokermon.get_lowest_evo(adj_joker))
        return adj_joker.config.center.stage
           and not PkmnDip.utils.contains(incompatible, adj_joker.config.center.stage)
           and G.P_CENTERS[lowest_key].stage ~= "Legendary"
        end)
      if breedable >= 2 then
        G.GAME.joker_buffer = G.GAME.joker_buffer + 1
        if (#G.jokers.cards <= G.jokers.config.card_limit) then
          PkmnDip.defer(function()
            G.GAME.joker_buffer = 0
            play_sound('timpani')
            local parent = pseudorandom_element(adjacent_jokers, pseudoseed("daycare"))
            local lowest = pokermon.get_lowest_evo(parent)
            if lowest and type(lowest) == "string" then
              local edition = SMODS.pseudorandom_probability(card, 'mega_audino', a.num, a.den, 'mega_audino') and 'e_poke_shiny'
                  or poll_edition('audino', nil, true, true, {
                    { name = 'e_foil', weight = 1/3 },
                    { name = 'e_holo', weight = 1/3 },
                    { name = 'e_polychrome', weight = 1/3 }
                  })
              local egg = SMODS.add_card{set = 'Joker', key = 'j_poke_mystery_egg', edition = edition}
              egg.ability.extra.key = create_full_poke_key(parent, lowest)
              egg.ability.extra.rounds = 1
            end
          end, 0.4)
        end
      end
    end
  end,
  attributes = {"generation", "joker", "xmult", "boss_blind"}
}

return {
  config_key = "audino",
  list = { audino, mega_audino }
}

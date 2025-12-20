-- Audino 531
local audino = {
  name = "audino",
  config = {extra = {Xmult = 1, Xmult_mod = 0.25}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
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
      card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
      return {
        message = localize('k_upgrade_ex'),
        colour = G.C.RED
      }
    end
    if context.joker_main then
      return {xmult = card.ability.extra.Xmult}
    end
  end,
  megas = {"mega_audino"},
}

-- Mega Audino 531-1
local mega_audino = {
  name = "mega_audino",
  config = {extra = {Xmult = 1, Xmult_mod = 0.25, num = 1, den = 5}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'breed_alt', vars = {1, ''}}
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
    if context.joker_main then
      return {xmult = card.ability.extra.Xmult}
    end
    if context.end_of_round and context.beat_boss and context.game_over == false and not context.blueprint then
      local adjacent_jokers = poke_get_adjacent_jokers(card)
      local breedable = #PkmnDip.utils.filter(adjacent_jokers, function(adj_joker)
        return adj_joker.config.center.stage
           and adj_joker.config.center.stage ~= "Other"
           and adj_joker.config.center.stage ~= "Baby"
           and adj_joker.config.center.stage ~= "Legendary"
        end)
      if breedable >= 2 then
        G.GAME.joker_buffer = G.GAME.joker_buffer + 1
        if (#G.jokers.cards <= G.jokers.config.card_limit) then
          G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            G.GAME.joker_buffer = 0
            play_sound('timpani')
            local parent = pseudorandom_element(adjacent_jokers, pseudoseed("daycare"))
            local lowest = get_lowest_evo(parent)
            if lowest and type(lowest) == "string" then
              local prefix = parent.config.center.poke_custom_prefix or "poke"
              local egg_key = "j_"..prefix.."_"..lowest
              local edition = SMODS.pseudorandom_probability(card, 'mega_audino', card.ability.extra.num, card.ability.extra.den, 'mega_audino') and 'e_poke_shiny'
                  or poll_edition('audino', nil, true, true, {
                    { name = 'e_foil', weight = 1/3 }, { name = 'e_holo', weight = 1/3 }, { name = 'e_polychrome', weight = 1/3 } })
              local egg = SMODS.add_card{set = 'Joker', key = 'j_poke_mystery_egg', edition = edition}
              egg.ability.extra.key = egg_key
              egg.ability.extra.rounds = 1
            end
            return true
          end }))
        end
      end
    end
  end,
}

return {
  config_key = "audino",
  list = { audino, mega_audino }
}

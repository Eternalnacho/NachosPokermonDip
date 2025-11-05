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
  config = {extra = {Xmult = 1, Xmult_mod = 0.25, num = 1, den = 10}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue + 1] = {set = 'Other', key = 'daycare'}
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, 'mega_audino')
    return {vars = {card.ability.extra.Xmult, num, den}}
  end,
  designer = "Eternalnacho",
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
    if context.end_of_round and context.game_over == false and not context.blueprint then
      local hatchlings
      for k, v in pairs(G.jokers.cards) do
        if v.config.center.stage == "Baby" or v.config.center.stage == "Basic" or v.config.center_key == 'j_poke_mystery_egg' then hatchlings = true end
      end
      G.GAME.joker_buffer = G.GAME.joker_buffer + 1
      if (#G.jokers.cards <= G.jokers.config.card_limit) or not hatchlings then
          G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            G.GAME.joker_buffer = 0
            play_sound('timpani')
            local _card = SMODS.create_card({set = 'Joker', key = 'j_poke_mystery_egg'})
            local _edition = poll_edition('aura', nil, true, true)
            if SMODS.pseudorandom_probability(card, 'mega_audino', card.ability.extra.num, card.ability.extra.den, 'mega_audino') then
              _edition = 'e_poke_shiny'
            end
            _card:set_edition(_edition, true)
            _card:add_to_deck()
            G.jokers:emplace(_card)
            if _card.ability and _card.ability.extra then _card.ability.extra.rounds = 1 end
            return true end }))
          delay(0.6)
      end
    end
  end,
}

return {
  name = "Nacho's Audino Line",
  enabled = nacho_config.audino or false,
  list = { audino, mega_audino }
}

-- Ralts 280
local ralts={
  name = "ralts",
  config = {extra = {mult_mod = 1, rounds = 4}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local mult = 0
    for _, v in pairs(G.GAME.hands) do
      mult = mult + (v.level - 1) * card.ability.extra.mult_mod
    end
    return {vars = {card.ability.extra.mult_mod, mult, card.ability.extra.rounds}}
  end,
  designer = "Foxthor, One Punch Idiot",
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Psychic",
  gen = 3,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        local mult = 0
        for _, v in pairs(G.GAME.hands) do
          if (SMODS.Mods["Talisman"] or {}).can_load then
            mult = mult + (to_number(v.level) - 1) * card.ability.extra.mult_mod
          else
            mult = mult + (v.level - 1) * card.ability.extra.mult_mod
          end
        end
        return {
          mult = mult,
          card = card
        }
      end
    end
    return level_evo(self, card, context, "j_nacho_kirlia")
  end,
}

-- Kirlia 281
local kirlia={
  name = "kirlia",
  config = {extra = {mult_mod = 2, rounds = 5}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local mult = 0
    for _, v in pairs(G.GAME.hands) do
      mult = mult + (v.level - 1) * card.ability.extra.mult_mod
    end
    return {vars = {card.ability.extra.mult_mod, mult, card.ability.extra.rounds}}
  end,
  designer = "Foxthor, One Punch Idiot",
  rarity = "poke_safari",
  cost = 9,
  item_req = "dawnstone",
  stage = "One",
  ptype = "Psychic",
  gen = 3,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        local mult = 0
        for _, v in pairs(G.GAME.hands) do
          if (SMODS.Mods["Talisman"] or {}).can_load then
            mult = mult + (to_number(v.level) - 1) * card.ability.extra.mult_mod
          else
            mult = mult + (v.level - 1) * card.ability.extra.mult_mod
          end
        end
        return {
          mult = mult,
          card = card
        }
      end
    end
    return item_evo(self, card, context, "j_nacho_gallade") or level_evo(self, card, context, "j_nacho_gardevoir")
  end,
}

-- Gardevoir 282
local gardevoir={
  name = "gardevoir",
  config = {extra = {Xmult_mod = 0.1, Xmult = 1.0}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local xmult = 1
    for _, v in pairs(G.GAME.hands) do
      xmult = xmult + (v.level - 1) * card.ability.extra.Xmult_mod
    end
    return {vars = {card.ability.extra.Xmult_mod, xmult}}
  end,
  designer = "Foxthor, One Punch Idiot",
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Psychic",
  gen = 3,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        local xmult = 1
        for _, v in pairs(G.GAME.hands) do
          if (SMODS.Mods["Talisman"] or {}).can_load then
            xmult = xmult + (to_number(v.level) - 1) * card.ability.extra.Xmult_mod
          else
            xmult = xmult + (v.level - 1) * card.ability.extra.Xmult_mod
          end
        end
        if xmult > 1 then
          return {
            xmult = xmult,
            card = card
          }
        end
      end
    end
  end,
  megas = {"mega_gardevoir"},
}

-- Mega Gardevoir 282-1
local mega_gardevoir={
  name = "mega_gardevoir",
  config = {extra = {blackhole_amount = 2}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = {key = 'tag_orbital', set = 'Tag', specific_vars = {"Random Hand", 3}}
    return {vars = {card.ability.extra.blackhole_amount}}
  end,
  designer = "Eternalnacho, Maelmc",
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Psychic",
  gen = 3,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    -- Create Orbital Tag on Planet Use
    if context.using_consumeable and context.consumeable and context.consumeable.ability then
      if context.consumeable.ability.set == 'Planet' then
        local tag = Tag('tag_orbital')
        local _poker_hands = {}
        for k, v in pairs(G.GAME.hands) do
          if v.visible then
            _poker_hands[#_poker_hands + 1] = k
          end
        end
        tag.ability.orbital_hand = pseudorandom_element(_poker_hands, pseudoseed('mega_gardevoir'))
        G.E_MANAGER:add_event(Event({
          func = (function()
              add_tag(tag)
              play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
              play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
              return true
          end)
        }))
      end
    end
    -- Set Planet Cards in Hand to Polychrome at end of round
    if context.end_of_round and not context.blueprint then
      for k, v in ipairs(G.consumeables.cards) do
        if v.ability.set == 'Planet' and not v.edition then
          local edition = {polychrome = true}
          v:set_edition(edition, true)
        end
      end
    end
  end,
  -- Negative Black Hole generation on entry
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
      local _card = create_card("Spectral", G.consumeables, nil, nil, nil, nil, "c_black_hole")
      local edition = {negative = true}
      _card:set_edition(edition, true)
      _card:add_to_deck()
      G.consumeables:emplace(_card)
      card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
    end
  end,
}

-- Gallade 475
local gallade={
  name = "gallade",
  config = {extra = {Xmult_mod = 0.1}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_mod}}
  end,
  designer = "Eternalnacho",
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Fighting",
  gen = 4,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    -- Main Scoring
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        local Xmult = 1 + card.ability.extra.Xmult_mod * G.GAME.hands[context.scoring_name].played
        return {
          xmult = Xmult,
          card = card
        }
      end
    end
  end,
  megas = {"mega_gallade"},
}

-- Mega-Gallade 475-1
local mega_gallade={
  name = "mega_gallade",
  config = {extra = {Xmult_mod = 0.25}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_mod}}
  end,
  designer = "Eternalnacho",
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Fighting",
  gen = 4,
  perishable_compat = false,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    -- Prevent most played hand from being debuffed
    if context.debuff_hand and context.scoring_name == calc_most_played_hand() then
      return { prevent_debuff = true }
    end
    -- Main Scoring
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        local Xmult = 1 + card.ability.extra.Xmult_mod * G.GAME.hands[context.scoring_name].played
        return {
          xmult = Xmult,
          card = card
        }
      end
    end
  end,
}

local init = function()
  -- Ralts take ownership event thing
  G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.0, func = function()
    if PkmnDip.find_family('ralts') then
      SMODS.Joker:take_ownership('maelmc_ralts', { aux_poke = true, no_collection = true, custom_pool_func = true, in_pool = function() return false end }, true)
      SMODS.Joker:take_ownership('maelmc_kirlia', { aux_poke = true, no_collection = true, custom_pool_func = true, in_pool = function() return false end }, true)
      SMODS.Joker:take_ownership('maelmc_gardevoir', { aux_poke = true, no_collection = true, custom_pool_func = true, in_pool = function() return false end }, true)
      SMODS.Joker:take_ownership('maelmc_mega_gardevoir', { aux_poke = true, no_collection = true, custom_pool_func = true, in_pool = function() return false end }, true)
      PkmnDip.append_to_family('ralts', 'gallade', true)
      PkmnDip.append_to_family('ralts', 'mega_gallade', true)
    else
      pokermon.add_family({ 'ralts', 'kirlia', 'gardevoir', 'mega_gardevoir', 'gallade', 'mega_gallade' })
    end
    return true end
  }))

  -- Gallade level_up_hand hook
  local level_up_hand_ref = level_up_hand
  level_up_hand = function(card, hand, instant, amount)
    local _hand
    if next(SMODS.find_card('j_nacho_gallade')) and card and card.ability and card.ability.set == 'Planet' then
      local gallade = SMODS.find_card('j_nacho_gallade')[1]
      _hand = calc_most_played_hand()
      card_eval_status_text(gallade, 'extra', nil, nil, nil, {message = localize('poke_psycho_cut_ex'), colour = G.C.SECONDARY_SET.Planet, sound = 'slice1', pitch = 0.96+math.random()*0.08})
      delay(0.4)
      update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(_hand, 'poker_hands'),chips = G.GAME.hands[_hand].chips, mult = G.GAME.hands[_hand].mult, level=G.GAME.hands[_hand].level})
    end
    level_up_hand_ref(card, _hand or hand, instant, amount)
  end

  -- Mega Gallade card debuffing/un-debuffing function
  local parse_highlighted = CardArea.parse_highlighted
  CardArea.parse_highlighted = function(self)
    for _, card in ipairs(self.highlighted) do
      if card.debuff then card:set_debuff(false) end
    end
    local text, _, _ = G.FUNCS.get_poker_hand_info(self.highlighted)
    for _, card in ipairs(self.cards) do
      SMODS.recalc_debuff(card)
    end
    if text == calc_most_played_hand() and next(SMODS.find_card('j_nacho_mega_gallade')) then
      for _, card in ipairs(self.highlighted) do
        if card.debuff then card:set_debuff(false) end
      end
    end
    parse_highlighted(self)
  end
end

return {
  config_key = "ralts",
  init = init,
  no_family = true,
  list = { ralts, kirlia, gardevoir, mega_gardevoir, gallade, mega_gallade }
}

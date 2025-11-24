-- Applin 840
local applin = {
  name = "applin",
  config = { extra = {h_size = 1} },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = {set = 'Other', key = 'apple_evolutions'}
    end
    return { vars = { card.ability.extra.h_size } }
  end,
  designer = "Kek",
  rarity = 1,
  cost = 4,
  stage = "Basic",
  ptype = "Dragon",
  gen = 8,
  item_req = {"sweetapple", "tartapple", "syrupyapple"},
  custom_item_evo = true,
  evo_list = {sweetapple = "j_nacho_appletun", tartapple = 'j_nacho_flapple', syrupyapple = 'j_nacho_dipplin'},
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.end_of_round and not context.individual and not context.repetition and not context.game_over then
      local target = pseudorandom_element(G.deck.cards, pseudoseed('applin'))
      if target then
        SMODS.destroy_cards(target, nil, true)
        card:juice_up()
      end
    end
    return item_evo(self, card, context)
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
  end,
}

-- Flapple 841
local flapple = {
  name = "flapple",
  config = { extra = { Xmult = 1, Xmult_mod = 0.3 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_mod, 0.1, card.ability.extra.Xmult } }
  end,
  designer = "Kek",
  rarity = 3,
  cost = 8,
  stage = "One",
  ptype = "Dragon",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    -- Replace all destroyed cards with Wild copies and count Wild cards destroyed
    if context.remove_playing_cards and not context.blueprint then
      -- increment Xmult
      a.Xmult = a.Xmult + a.Xmult_mod * #context.removed
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={a.Xmult}}, colour = G.C.FILTER})
    end

    if context.joker_main or context.debuffed_hand then
      if not context.blueprint and not context.retrigger_joker then a.Xmult = math.max(a.Xmult - 0.1, 1) end
    end

    if context.joker_main then
      return {
        xmult = a.Xmult
      }
    end
  end,
}

-- Appletun 842
local appletun = {
  name = "appletun",
  config = { extra = { h_size = 1, money = 3 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.money } }
  end,
  designer = "Kek",
  rarity = 3,
  cost = 8,
  stage = "One",
  ptype = "Dragon",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.setting_blind or context.pre_discard then
      local old_h_size = a.h_size
      local ranks = {}
      for i = 2, 14 do
        for k, v in pairs(G.deck.cards) do
          if v:get_id() == i and not PkmnDip.utils.contains(ranks, i) then ranks[#ranks+1] = i end
        end
      end
      a.h_size = #ranks < 13 and 2 or 1
      G.hand:change_size(a.h_size - old_h_size)
    end
    if context.remove_playing_cards then
      local total_removed = #context.removed
      ease_poke_dollars(card, "appletun", a.money * total_removed)
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    local ranks = {}
    for i = 2, 14 do
      for k, v in pairs(G.deck.cards) do
        if v:get_id() == i and not PkmnDip.utils.contains(ranks, i) then ranks[#ranks+1] = i end
      end
    end
    card.ability.extra.h_size = #ranks < 13 and 2 or 1
    G.hand:change_size(card.ability.extra.h_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
  end,
}

-- Dipplin 1011
local dipplin = {
  name = "dipplin",
  config = { extra = { } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = G.P_CENTERS.m_wild
    end
    local enhance_count = G.playing_cards and G.STAGE == G.STAGES.RUN and #PkmnDip.utils.filter(G.playing_cards, function(v) return SMODS.has_enhancement(v, 'm_wild') end) or 0
    local deck_data = G.playing_cards and G.STAGE == G.STAGES.RUN and '['..tostring(enhance_count)..'/'..tostring(math.ceil(#G.playing_cards/4))..'] ' or ''
    return { vars = { deck_data } }
  end,
  designer = "Eternalnacho",
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Dragon",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.remove_playing_cards then
      for _, removed in pairs(context.removed) do
        local copies = SMODS.has_enhancement(removed, 'm_wild') and 2 or 1
        for i = 1, copies do
          -- copy destroyed card and convert to wild
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
              local copy = copy_card(removed, nil, nil, G.playing_card)
              copy:add_to_deck()
              G.deck.config.card_limit = G.deck.config.card_limit + 1
              table.insert(G.playing_cards, copy)
              G.deck:emplace(copy)
              copy.states.visible = nil
              copy:start_materialize()
              poke_convert_cards_to(copy, {mod_conv = 'm_wild'}, true, true)
              playing_card_joker_effects({copy})
              return true
            end
          }))
          -- "copied" status text
          card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_copied_ex'), colour = G.C.FILTER})
        end
      end
      return {
        playing_cards_created = {true}
      }
    end
    return deck_enhance_evo(self, card, context, "j_nacho_hydrapple", "Wild", .25)
  end,
}

-- Hydrapple 1019
local hydrapple = {
  name = "hydrapple",
  config = { extra = { Xmult = 1, Xmult_mod = 0.2 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = G.P_CENTERS.m_wild
    end
    local a = card.ability.extra
    return { vars = { a.Xmult, a.Xmult_mod, a.Xmult_mod * 2 } }
  end,
  designer = "Eternalnacho",
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Dragon",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    -- Replace all destroyed cards with Wild copies and count Wild cards destroyed
    if context.remove_playing_cards then
      for _, removed in pairs(context.removed) do
        -- copy destroyed card and convert to wild
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.1,
          func = function()
            local copy = copy_card(removed, nil, nil, G.playing_card)
            copy:add_to_deck()
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            table.insert(G.playing_cards, copy)
            G.deck:emplace(copy)
            copy.states.visible = nil
            copy:start_materialize()
            poke_convert_cards_to(copy, {mod_conv = 'm_wild'}, true, true)
            playing_card_joker_effects({copy})
            return true
          end
        }))

        -- increment Xmult
        a.Xmult = a.Xmult + a.Xmult_mod * (SMODS.has_enhancement(removed, 'm_wild') and 2 or 1)

        -- "copied" status text
        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_copied_ex'), colour = G.C.FILTER})
      end
      if not context.blueprint then
        delay(0.3)
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={a.Xmult}}, colour = G.C.FILTER})
      end
      return {
        playing_cards_created = {true}
      }
    end
    if context.joker_main then
      return {
        xmult = a.Xmult
      }
    end
  end,
}

return {
  name = "Nacho's Applin Evo Line",
  enabled = nacho_config.applin or false,
  list = { applin, flapple, appletun, dipplin, hydrapple }
}

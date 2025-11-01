-- Terapagos 1024
local terapagos={
  name = "terapagos",
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'energize'}
    return {vars = {}}
  end,
  designer = "Eternalnacho",
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Colorless",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable and context.consumeable.ability then
      if context.consumeable.ability.name == 'teraorb' then
        if G.jokers.highlighted[1] == card and #G.jokers.highlighted == 1 then
          poke_evolve(card, 'j_nacho_terapagos_terastal')
        elseif G.jokers.cards[1] == card and #G.jokers.highlighted == 0 then
          poke_evolve(card, 'j_nacho_terapagos_terastal')
        end
      end
    end
    if context.end_of_round and not context.individual and context.main_eval and not from_debuff then
      local _card = create_card("Item", G.consumeables, nil, nil, nil, nil, "c_poke_teraorb")
      local edition = {negative = true}
      _card:set_edition(edition, true)
      _card:add_to_deck()
      G.consumeables:emplace(_card)
      card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('poke_plus_pokeitem'), colour = G.ARGS.LOC_COLOURS.item})
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
      local _card = create_card("Item", G.consumeables, nil, nil, nil, nil, "c_poke_teraorb")
      local edition = {negative = true}
      _card:set_edition(edition, true)
      _card:add_to_deck()
      G.consumeables:emplace(_card)
      card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('poke_plus_pokeitem'), colour = G.ARGS.LOC_COLOURS.item})
    end
  end,
}

-- Terapagos-Terastal 1024-1
local terapagos_terastal={
  name = "terapagos_terastal",
  config = {extra = {Xmult_mod = 0.4, changedtype = "Colorless"}},
  loc_vars = function(self, info_queue, card)
    local count = #find_pokemon_type(card.ability.extra.ptype) - 1
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'energize'}
    return {vars = {card.ability.extra.Xmult_mod, math.max(1, 1 + card.ability.extra.Xmult_mod * count)}}
  end,
  designer = "Eternalnacho",
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Colorless",
  gen = 9,
  blueprint_compat = true,
  custom_pool_func = true,
  aux_poke = true,
  in_pool = function(self)
    return false
  end,
  calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable and context.consumeable.ability then
      if context.consumeable.ability.name == 'teraorb' then
        if (G.jokers.highlighted[1] == card and #G.jokers.highlighted == 1) or (G.jokers.cards[1] == card and #G.jokers.highlighted == 0) then
          if not (context.consumeable.ability.extra.change_to_type == card.ability.extra.changedtype) then
            energy_increase(card, type_sticker_applied(card))
            card.ability.extra.changedtype = card.ability.extra.ptype
          end
          for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] ~= card then
              apply_type_sticker(G.jokers.cards[i], card.ability.extra.ptype)
            end
          end
          if get_total_energy(card) >= 6 then
            poke_evolve(card, 'j_nacho_terapagos_stellar')
          end
        end
      end
    end
    if context.joker_main then
      local count = #find_pokemon_type(card.ability.extra.ptype) - 1
      return{
        xmult = 1 + card.ability.extra.Xmult_mod * count
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
      if not G.GAME.energy_plus then
        G.GAME.energy_plus = 3
      else
        G.GAME.energy_plus = G.GAME.energy_plus + 3
      end
      for i = 1, #G.jokers.cards do
        apply_type_sticker(G.jokers.cards[i], type_sticker_applied(card))
      end
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    if not G.GAME.energy_plus then
      G.GAME.energy_plus = 0
    else
      G.GAME.energy_plus = G.GAME.energy_plus - 3
    end
  end,
}


-- Terapagos-Stellar 1024-2
local terapagos_stellar={
  name = "terapagos_stellar",
  poke_custom_prefix = "nacho",
  pos = {x = 0, y = 0},
  soul_pos = {x = 0, y = 0,
    draw = function(card, scale_mod, rotate_mod)
      -- AAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      card.children.floating_sprite.scale.x = card.children.center.scale.x * (108/71)
      card.children.floating_sprite.scale.y = card.children.center.scale.y * (108/71)
      local red_scale_mod = scale_mod - (1 - 71/108)

      card.children.center.VT.w = card.T.w
      card.children.floating_sprite:draw_shader('dissolve', 0, nil, nil, card.children.center, red_scale_mod, rotate_mod, -(1 - 71/108), 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL) - 0.5, nil, 0.6)
      card.children.floating_sprite:draw_shader('dissolve', nil, nil, nil, card.children.center, red_scale_mod, rotate_mod, -(1 - 71/108), -0.5)
      card.children.center.VT.w = card.T.w
    end},
  config = {extra = {Xmult_mod = 0.1, Xmult = 1, energy_total = 0}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'energize'}
    info_queue[#info_queue+1] = {set = 'Other', key = 'stellar_type'}
    return {vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult}}
  end,
  designer = "Eternalnacho",
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Stellar",
  atlas = "j_nacho_terapagos_stellar",
  blueprint_compat = true,
  custom_pool_func = true,
  aux_poke = true,
  in_pool = function(self)
    return false
  end,
  calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable and context.consumeable.ability then
      if context.consumeable.ability.name == 'teraorb' then
        if (G.jokers.highlighted[1] == card and #G.jokers.highlighted == 1) or (G.jokers.cards[1] == card and #G.jokers.highlighted == 0) then
          for i = 1, #G.jokers.cards do
            energy_increase(G.jokers.cards[i], G.jokers.cards[i].ability.extra.ptype)
	          apply_type_sticker(G.jokers.cards[i], "Stellar")
          end
        end
      end
    end
    if context.other_joker and is_type(context.other_joker, "Stellar") then
      local xmult = 1 + card.ability.extra.Xmult_mod * get_total_energy(context.other_joker)
      G.E_MANAGER:add_event(Event({
        func = function()
            context.other_joker:juice_up(0.5, 0.5)
            return true
        end
      }))
      return{
        message = localize{type = 'variable', key = 'a_xmult', vars = {xmult}},
        colour = G.C.XMULT,
        Xmult_mod = xmult
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.0, func = function()
              card.children.center:reset()
              if card.children.floating_sprite then
                card.children.floating_sprite.atlas = G.ASSET_ATLAS[card.children.center.atlas.name .. "_soul"]
                card.children.floating_sprite:reset()
              end
              apply_type_sticker(card, "Stellar")
              return true end }))
    if not G.GAME.energy_plus then
      G.GAME.energy_plus = 5
    else
      G.GAME.energy_plus = G.GAME.energy_plus + 5
    end
    if not from_debuff then
      for i = 1, #G.jokers.cards do
        apply_type_sticker(G.jokers.cards[i], "Stellar")
      end
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    if not G.GAME.energy_plus then
      G.GAME.energy_plus = 0
    else
      G.GAME.energy_plus = G.GAME.energy_plus - 5
    end
  end,
  set_sprites = function(self, card, front)
    if self.discovered or card.bypass_discovery_center then
      card.children.center:reset()
      if card.children.floating_sprite then
        card.children.floating_sprite.atlas = G.ASSET_ATLAS[card.children.center.atlas.name .. "_soul"]
        card.children.floating_sprite:reset()
      end
    end
  end,
  update = function(self, card, dt)
    if poke_is_in_collection(card) and not type_sticker_applied(card) then
      apply_type_sticker(card, "Stellar")
    end
  end,
}

return {
  name = "Nacho's Terapagos Line",
  enabled = nacho_config.Terapagos or false,
  list = {terapagos, terapagos_terastal, terapagos_stellar}
}

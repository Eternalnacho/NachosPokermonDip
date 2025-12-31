-- Terapagos 1024
local terapagos={
  name = "terapagos",
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'energize'}
    return {vars = {}}
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Colorless",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable and context.consumeable.ability then
      if context.consumeable.ability.name == 'teraorb' and card == poke_find_leftmost_or_highlighted() then
        poke_evolve(card, 'j_nacho_terapagos_terastal')
      end
    end
    if context.end_of_round and not context.individual and context.main_eval then
      local _card = SMODS.add_card({set = "Item", area = G.consumeables, edition = 'e_negative', key = "c_poke_teraorb"})
      card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('poke_plus_pokeitem'), colour = G.ARGS.LOC_COLOURS.item})
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
      local _card = SMODS.add_card({set = "Item", area = G.consumeables, edition = 'e_negative', key = "c_poke_teraorb"})
      card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('poke_plus_pokeitem'), colour = G.ARGS.LOC_COLOURS.item})
    end
  end,
}

-- Terapagos-Terastal 1024-1
local terapagos_terastal={
  name = "terapagos_terastal",
  config = {extra = {Xmult_mod = 0.4, changedtype = "Colorless"}},
  loc_vars = function(self, info_queue, card)
    local count = not poke_is_in_collection(card) and (#find_pokemon_type(card.ability.extra.ptype) - 1) or 0
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'energize'}
    return {vars = {card.ability.extra.Xmult_mod, math.max(1, 1 + card.ability.extra.Xmult_mod * count)}}
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Colorless",
  gen = 9,
  blueprint_compat = true,
  custom_pool_func = true,
  in_pool = function(self)
    return false
  end,
  calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable and context.consumeable.ability then
      if context.consumeable.ability.name == 'teraorb' and card == poke_find_leftmost_or_highlighted() then
        if not (context.consumeable.ability.extra.change_to_type == card.ability.extra.changedtype) then
          energy_increase(card, get_type(card))
          card.ability.extra.changedtype = card.ability.extra.ptype
        end
        PkmnDip.utils.for_each(G.jokers.cards, function(joker) if joker ~= card then apply_type_sticker(joker, card.ability.extra.ptype) end end)
        if get_total_energy(card) >= 6 then
          poke_evolve(card, 'j_nacho_terapagos_stellar')
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
      G.GAME.energy_plus = G.GAME.energy_plus and (G.GAME.energy_plus + 3) or 3
      PkmnDip.utils.for_each(G.jokers.cards, function(joker) apply_type_sticker(joker, get_type(card)) end)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.energy_plus = G.GAME.energy_plus and (G.GAME.energy_plus - 3) or 0
  end,
}


-- Terapagos-Stellar 1024-2
local terapagos_stellar={
  name = "terapagos_stellar",
  poke_custom_prefix = "nacho",
  pos = {x = 0, y = 0},
  soul_pos = {x = 0, y = 0,
    draw = function(card, scale_mod, rotate_mod)
      local _c, _f = card.children.center, card.children.floating_sprite
      -- this little for loop gives the floating sprite the right parameters to draw from itself
      for k, v in pairs(_c.VT) do _f.VT[k] = v end
      -- first line draws the shadow, second draws the sprite
      _f:draw_shader('dissolve', 0, nil, nil, _f, scale_mod, rotate_mod, nil, 0.1 + 0.03 * math.sin(1.8 * G.TIMERS.REAL), nil, 0.6)
      _f:draw_shader('dissolve', nil, nil, nil, _f, scale_mod, rotate_mod, nil)
      if card.edition then
        local edition = G.P_CENTERS[card.edition.key]
        if edition.apply_to_float then
          edition.apply_to_float = false
          _f:draw_shader(edition.shader, nil, nil, nil, _f, scale_mod, rotate_mod)
        end
      end
    end},
  config = {extra = {Xmult_mod = 0.1, Xmult = 1, energy_total = 0}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'energize'}
    info_queue[#info_queue+1] = {set = 'Other', key = 'stellar_type'}
    return {vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult}}
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Stellar",
  atlas = "nacho_terapagos_stellar",
  blueprint_compat = true,
  custom_pool_func = true,
  in_pool = function(self)
    return false
  end,
  calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable and context.consumeable.ability then
      if context.consumeable.ability.name == 'teraorb' and card == poke_find_leftmost_or_highlighted() then
        PkmnDip.utils.for_each(G.jokers.cards,
          function(joker)
            energy_increase(joker, get_type(joker))
            apply_type_sticker(joker, "Stellar")
          end)
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
        self:set_sprites(card)
        apply_type_sticker(card, "Stellar")
      return true end }))
    G.GAME.energy_plus = G.GAME.energy_plus and (G.GAME.energy_plus + 5) or 5
    if not from_debuff then
      PkmnDip.utils.for_each(G.jokers.cards, function(joker) apply_type_sticker(joker, "Stellar") end)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.energy_plus = G.GAME.energy_plus and (G.GAME.energy_plus - 5) or 0
  end,
  set_sprites = function(self, card, front)
    if self.discovered or card.bypass_discovery_center and card.children.floating_sprite then
      card.children.floating_sprite:remove()
      -- creates the animated sprite with its atlas (since they're separate)
      local soul_altas = 'nacho_'..(card.edition and card.edition.poke_shiny and 'shiny_' or '')..'terapagos_stellar_soul'
      card.children.floating_sprite = SMODS.create_sprite(card.T.x, card.T.y, card.T.w * (71 / 108), card.T.h * (95 / 145), soul_altas, card.config.center.soul_pos)
      card.children.floating_sprite.role.draw_major = card
      card.children.floating_sprite.states.hover.can = false
      card.children.floating_sprite.states.click.can = false
    end
  end,
  update = function(self, card, dt)
    if poke_is_in_collection(card) and not type_sticker_applied(card) then
      apply_type_sticker(card, "Stellar")
    end
  end,
}

local init = function()
  is_type_ref = is_type
  is_type = function(card, target_type)
    if card.ability and card.ability.stellar_sticker then return true end
    return is_type_ref(card, target_type)
  end

  energy_matches_ref = energy_matches
  energy_matches = function(card, etype, include_colorless)
    if card.ability and card.ability.stellar_sticker then return true
    else return energy_matches_ref(card, etype, include_colorless) end
  end

  matching_energy_ref = matching_energy
  matching_energy = function(card, allow_bird)
    if card.ability and card.ability.stellar_sticker then return "c_poke_colorless_energy"
    else return matching_energy_ref(card, allow_bird) end
  end

  find_pokemon_type_ref = find_pokemon_type
  find_pokemon_type = function(target_type, exclude_card)
    local ret = find_pokemon_type_ref(target_type, exclude_card)
    if type(ret) == "table" and G.jokers then
      for k, v in pairs(G.jokers.cards) do
        if v.ability.stellar_sticker and v ~= exclude_card and not PkmnDip.utils.contains(ret, v) then table.insert(ret, v) end
      end
    end
    return ret
  end
end

return {
  config_key = "terapagos",
  init = init,
  list = {terapagos, terapagos_terastal, terapagos_stellar}
}

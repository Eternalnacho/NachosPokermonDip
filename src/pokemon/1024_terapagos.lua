-- Terapagos 1024
local terapagos={
  name = "terapagos",
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
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
    if context.using_consumeable and context.consumeable.ability.name == 'teraorb' and card == pokermon.find_leftmost_or_highlighted() then
      pokermon.evolve(card, 'j_nacho_terapagos_terastal')
    end
    if context.end_of_round and context.main_eval then
      pokermon.create_held_item({ key = 'c_poke_teraorb', edition = 'e_negative' })
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
      pokermon.create_held_item({ key = 'c_poke_teraorb', edition = 'e_negative' })
    end
  end,
  attributes = {"item", "generation", "condition_evo"}
}

-- Terapagos-Terastal 1024-1
local terapagos_terastal={
  name = "terapagos_terastal",
  config = {extra = {Xmult_mod = 0.4, changedtype = "Colorless"}},
  loc_vars = function(self, info_queue, card)
    local count = not pokermon.is_in_collection(card) and (#pokermon.find_pokemon_type(card.ability.extra.ptype) - 1) or 0
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
    if context.using_consumeable and context.consumeable.ability.name == 'teraorb' and card == pokermon.find_leftmost_or_highlighted() then
      pokermon.energy.increase(card, pokermon.get_type(card))
      PkmnDip.utils.for_each(G.jokers.cards, function(joker) pokermon.apply_type_sticker(joker, card.ability.extra.ptype) end)
      if pokermon.energy.get_total_energy(card) >= 6 then
        pokermon.evolve(card, 'j_nacho_terapagos_stellar')
      end
    end
    if context.joker_main then
      local count = #pokermon.find_pokemon_type(card.ability.extra.ptype) - 1
      return{
        xmult = 1 + card.ability.extra.Xmult_mod * count
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
      G.GAME.poke_energy_plus = G.GAME.poke_energy_plus and (G.GAME.poke_energy_plus + 3) or 3
      PkmnDip.utils.for_each(G.jokers.cards, function(joker) pokermon.apply_type_sticker(joker, pokermon.get_type(card)) end)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.poke_energy_plus = G.GAME.poke_energy_plus and (G.GAME.poke_energy_plus - 3) or 0
  end,
  attributes = {"energy_limit", "item", "passive", "types", "joker", "xmult", "condition_evo"}
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
    if context.using_consumeable and context.consumeable.ability.name == 'teraorb' and card == pokermon.find_leftmost_or_highlighted() then
      PkmnDip.utils.for_each(G.jokers.cards,
        function(joker)
          pokermon.energy.increase(joker, pokermon.get_type(joker))
          pokermon.apply_type_sticker(joker, "Stellar")
        end)
    end
    if context.other_joker and pokermon.is_type(context.other_joker, "Stellar") then
      local xmult = 1 + card.ability.extra.Xmult_mod * pokermon.energy.get_total_energy(context.other_joker)
      if xmult > 1 then return { Xmult = xmult, card = context.other_joker } end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    PkmnDip.defer(function()
      self:set_sprites(card)
      pokermon.apply_type_sticker(card, "Stellar")
    end)
    G.GAME.poke_energy_plus = G.GAME.poke_energy_plus and (G.GAME.poke_energy_plus + 5) or 5
    if not from_debuff then
      PkmnDip.utils.for_each(G.jokers.cards, function(joker) pokermon.apply_type_sticker(joker, "Stellar") end)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.poke_energy_plus = G.GAME.poke_energy_plus and (G.GAME.poke_energy_plus - 5) or 0
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
    if pokermon.is_in_collection(card) and not pokermon.type_sticker_applied(card) then
      pokermon.apply_type_sticker(card, "Stellar")
    end
  end,
  attributes = {"energy_limit", "item", "passive", "types", "joker", "xmult"}
}

local init = function()
  -- Hooking Pokermon Type-related functions for the stellar type
  for _, func in ipairs{
    -- [1] = ref_table, [2] = ref_value (func), [3] = return value
    {pokermon, 'type_sticker_applied', "Stellar"},
    {pokermon, 'is_type', true},
    {pokermon.energy, 'energy_matches', true},
    {pokermon.energy, 'get_matching_energy', 'c_poke_colorless_energy'}
  } do 
    PkmnDip.utils.hook_before_function(func[1], func[2], function(card, ...)
      if card and card.ability and card.ability['stellar_sticker'] then return func[3] end
    end)
  end

  PkmnDip.utils.hook_around_function(pokermon, 'apply_type_sticker', function(orig, card, sticker_type, ...)
    return next(SMODS.find_card('j_nacho_terapagos_stellar')) and orig(card, "stellar", ...)
        or orig(card, sticker_type, ...)
  end)

  PkmnDip.utils.hook_around_function(pokermon, 'type_evo', function(orig, self, card, context, forced_key, type_req, ...)
    return orig(self, card, context, forced_key, 'stellar', ...)
        or orig(self, card, context, forced_key, type_req, ...)
  end)

  PkmnDip.utils.hook_around_function(pokermon, 'find_pokemon_type', function(orig, target_type, exclude_card, exclude_name, ...)
    local ret = orig(target_type, exclude_card, exclude_name, ...)
    if type(ret) == "table" and G.jokers then
      pokermon.table_append(ret, PkmnDip.utils.filter(G.jokers.cards, function(joker)
        return joker.ability['stellar_sticker'] 
           and joker ~= exclude_card
           and joker.ability.name ~= exclude_name
           and not PkmnDip.utils.contains(ret, joker)
      end))
    end
    return ret
  end)
end

return {
  config_key = "terapagos",
  init = init,
  list = {terapagos, terapagos_terastal, terapagos_stellar}
}

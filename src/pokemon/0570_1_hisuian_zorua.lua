-- Hisuian Zorua 570-1
local hisuian_zorua = {
  name = "hisuian_zorua",
  pos = { x = 0, y = 9 },
  soul_pos = { x = 99, y = 99 },
  config = {extra = {hidden_key = nil, rounds = 5, active = true}},
  designer = "ESN64",
  rarity = 3,
  cost = 8,
  stage = "Basic",
  ptype = "Colorless",
  gen = 5,
  blueprint_compat = true,
  rental_compat = false,
  calculate = function(self, card, context)
    local other_joker = G.jokers.cards[1]
    if other_joker and other_joker ~= card and not context.no_blueprint and card.ability.extra.active then
      context.blueprint = (context.blueprint or 0) + 1
      context.blueprint_card = context.blueprint_card or card
      if context.blueprint > #G.jokers.cards + 1 then return end

      local other_joker_ret = Card.calculate_joker(other_joker, context)

      context.blueprint = nil
      local eff_card = context.blueprint_card or card
      context.blueprint_card = nil
      if other_joker_ret then 
        other_joker_ret.card = eff_card
        other_joker_ret.colour = G.C.BLACK
        return other_joker_ret
      end
    end
    if context.after and G.jokers.cards[1] ~= card and card.ability.extra.active then
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function() 
          card.ability.extra.active = false
          card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('poke_reveal_ex')})
      return true end }))
    end
    if context.end_of_round and not context.individual and not context.repetition then
      card.ability.extra.active = true
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_reset')})
    end
    return level_evo(self, card, context, "j_nacho_hisuian_zoroark")
  end,
  set_card_type_badge = function(self, card, badges)
    local card_type = SMODS.Rarity:get_rarity_badge(card.config.center.rarity)
    local card_type_colour = get_type_colour(card.config.center or card.config, card)
    if card.area and card.area ~= G.jokers and not poke_is_in_collection(card) then
      local _o = G.P_CENTERS[card.ability.extra.hidden_key]
      card_type = SMODS.Rarity:get_rarity_badge(_o.rarity)
      card_type_colour = get_type_colour(_o, card)
    end
    badges[#badges + 1] = create_badge(card_type, card_type_colour, nil, 1.2)
  end,
  set_sprites = function(self, card, front)
    if card.ability and card.ability.extra and card.ability.extra.hidden_key then
      self:set_ability(card)
    end
  end,
  set_ability = function(self, card, initial, delay_sprites)
    if not type_sticker_applied(card) and not poke_is_in_collection(card) and not G.SETTINGS.paused then
      apply_type_sticker(card, "Colorless")
    end
    if card.area ~= G.jokers and not poke_is_in_collection(card) and not G.SETTINGS.paused then
      card.ability.extra.hidden_key = card.ability.extra.hidden_key or get_random_poke_key('zorua', nil, 1)
      local _o = G.P_CENTERS[card.ability.extra.hidden_key]
      card.children.center.atlas = G.ASSET_ATLAS[_o.atlas]
      card.children.center:set_sprite_pos(_o.pos)
    else
      card.children.center.atlas = G.ASSET_ATLAS[self.atlas]
      card.children.center:set_sprite_pos(self.pos)
    end
  end,
  generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local _c = card and card.config.center or card
    local _o
    if card.ability and card.ability.extra then
      card.ability.extra.hidden_key = card.ability.extra.hidden_key or get_random_poke_key('zorua', nil, 1)
      _o = G.P_CENTERS[card.ability.extra.hidden_key]
    end
    if card.area ~= G.jokers and not poke_is_in_collection(card) and _o then
      local temp_ability = card.ability
      card.ability = _o.config
      _o:generate_ui(info_queue, card, desc_nodes, specific_vars, full_UI_table)
      if not full_UI_table.name then
        full_UI_table.name = localize({ type = "name", set = _o.set, key = _o.key, nodes = full_UI_table.name })
      end
      card.ability = temp_ability
      if full_UI_table.name[1].nodes[1] then
        local textDyna = full_UI_table.name[1].nodes[1].nodes[1].config.object
        textDyna.string = textDyna.string .. localize("poke_illusion")
        textDyna.config.string = {textDyna.string}
        textDyna.strings = {}
        textDyna:update_text(true)
      end
      card.children.center.atlas = G.ASSET_ATLAS[_o.atlas]
      card.children.center:set_sprite_pos(_o.pos)
      local poketype_list = {Grass = true, Fire = true, Water = true, Lightning = true, Psychic = true, Fighting = true, Colorless = true, Dark = true, Metal = true, Fairy = true, Dragon = true, Earth = true}
      for i = #info_queue, 1, -1 do
        if info_queue[i].set == "Other" and info_queue[i].key and poketype_list[info_queue[i].key] then
          table.remove(info_queue, i)
        end
      end
    else
      if not full_UI_table.name then
        full_UI_table.name = localize({ type = "name", set = _c.set, key = _c.key, nodes = full_UI_table.name })
      end
      card.ability.blueprint_compat_ui = card.ability.blueprint_compat_ui or ''
      card.ability.blueprint_compat_check = nil
      local main_end = (card.area and card.area == G.jokers) and {
        {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
          {n=G.UIT.C, config={ref_table = card, align = "m", colour = G.C.JOKER_GREY, r = 0.05, padding = 0.06, func = 'blueprint_compat'}, nodes={
            {n=G.UIT.T, config={ref_table = card.ability, ref_value = 'blueprint_compat_ui',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
          }}
        }}
      } or nil
      local rounds = 5
      local active
      if _o then rounds = card.ability.extra.rounds; active = card.ability.extra.active end
      localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = {rounds, colours = {not active and G.C.UI.TEXT_INACTIVE}}}
      desc_nodes[#desc_nodes+1] = main_end
    end
  end,
  update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and card.area == G.jokers then
      local other_joker = G.jokers.cards[1]
      card.ability.blueprint_compat = ( other_joker and other_joker ~= card and not other_joker.debuff and other_joker.config.center.blueprint_compat and 'compatible') or 'incompatible'
      if card.ability.blueprint_compat == 'compatible' and not card.debuff and card.ability.extra.active and other_joker.children.center.atlas.px == 71 then
        card.children.center.atlas = other_joker.children.center.atlas
        card.children.center:set_sprite_pos(other_joker.children.center.sprite_pos)
        if other_joker.children.floating_sprite then
          card.children.floating_sprite.atlas = other_joker.children.floating_sprite.atlas
          card.children.floating_sprite:set_sprite_pos(other_joker.children.floating_sprite.sprite_pos)
          card.config.center.soul_pos.draw = other_joker.config.center.soul_pos.draw
        else
          card.children.floating_sprite.atlas = G.ASSET_ATLAS[self.atlas]
          card.children.floating_sprite:set_sprite_pos(self.soul_pos)
        end
      else
        card.children.center.atlas = G.ASSET_ATLAS[card.edition and card.edition.poke_shiny and "poke_AtlasJokersBasicGen05Shiny" or "poke_AtlasJokersBasicGen05"]
        card.children.center:set_sprite_pos(self.pos)
        card.children.floating_sprite.atlas = G.ASSET_ATLAS[card.edition and card.edition.poke_shiny and "poke_AtlasJokersBasicGen05Shiny" or "poke_AtlasJokersBasicGen05"]
        card.children.floating_sprite:set_sprite_pos(self.soul_pos)
      end
    elseif poke_is_in_collection(card) and card.children.center.sprite_pos ~= self.pos and card.children.center.atlas.name ~= self.atlas then
      self:set_ability(card)
    end
  end,
}

-- Hisuian Zoroark 571-1
local hisuian_zoroark = {
  name = "hisuian_zoroark",
  pos = { x = 2, y = 9 },
  soul_pos = { x = 99, y = 99 },
  config = {extra = {hidden_key = nil}},
  designer = "ESN64",
  rarity = "poke_safari",
  cost = 12,
  stage = "One",
  ptype = "Colorless",
  gen = 5,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local other_joker = G.jokers.cards[1]
    if other_joker and other_joker ~= card and not context.no_blueprint then
      context.blueprint = (context.blueprint or 0) + 1
      context.blueprint_card = context.blueprint_card or card
      if context.blueprint > #G.jokers.cards + 1 then return end

      local other_joker_ret = Card.calculate_joker(other_joker, context)

      context.blueprint = nil
      local eff_card = context.blueprint_card or card
      context.blueprint_card = nil
      if other_joker_ret then 
        other_joker_ret.card = eff_card
        other_joker_ret.colour = G.C.BLACK
        return other_joker_ret
      end
    end
  end,
  set_card_type_badge = function(self, card, badges)
    local card_type = SMODS.Rarity:get_rarity_badge(card.config.center.rarity)
    local card_type_colour = get_type_colour(card.config.center or card.config, card)
    if card.area ~= G.jokers and not poke_is_in_collection(card) then
      local _o = G.P_CENTERS[card.ability.extra.hidden_key]
      card_type = SMODS.Rarity:get_rarity_badge(_o.rarity)
      card_type_colour = get_type_colour(_o, card)
    end
    badges[#badges + 1] = create_badge(card_type, card_type_colour, nil, 1.2)
  end,
  set_sprites = function(self, card, front)
    if card.ability and card.ability.extra and card.ability.extra.hidden_key then
      self:set_ability(card)
    end
  end,
  set_ability = function(self, card, initial, delay_sprites)
    if not type_sticker_applied(card) and not poke_is_in_collection(card) and not G.SETTINGS.paused then
      apply_type_sticker(card, "Colorless")
    end
    if card.area ~= G.jokers and not poke_is_in_collection(card) and not G.SETTINGS.paused then
      card.ability.extra.hidden_key = card.ability.extra.hidden_key or get_random_poke_key('zoroark', nil, 'poke_safari', nil, nil, {j_poke_zoroark = true})
      local _o = G.P_CENTERS[card.ability.extra.hidden_key]
      card.children.center.atlas = G.ASSET_ATLAS[_o.atlas]
      card.children.center:set_sprite_pos(_o.pos)
    else
      card.children.center.atlas = G.ASSET_ATLAS[self.atlas]
      card.children.center:set_sprite_pos(self.pos)
    end
  end,
  generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local _c = card and card.config.center or card
    local _o
    if card.ability and card.ability.extra then
      card.ability.extra.hidden_key = card.ability.extra.hidden_key or get_random_poke_key('zoroark', nil, 'poke_safari', nil, nil, {j_poke_zoroark = true})
      _o = G.P_CENTERS[card.ability.extra.hidden_key]
    end
    if card.area ~= G.jokers and not poke_is_in_collection(card) and _o then
      local temp_ability = card.ability
      card.ability = _o.config
      _o:generate_ui(info_queue, card, desc_nodes, specific_vars, full_UI_table)
      card.ability = temp_ability
      if full_UI_table.name[1].nodes[1] then
        local textDyna = full_UI_table.name[1].nodes[1].nodes[1].config.object
        textDyna.string = textDyna.string .. localize("poke_illusion")
        textDyna.config.string = {textDyna.string}
        textDyna.strings = {}
        textDyna:update_text(true)
      end
      card.children.center.atlas = G.ASSET_ATLAS[_o.atlas]
      card.children.center:set_sprite_pos(_o.pos)
      local poketype_list = {Grass = true, Fire = true, Water = true, Lightning = true, Psychic = true, Fighting = true, Colorless = true, Dark = true, Metal = true, Fairy = true, Dragon = true, Earth = true}
      for i = #info_queue, 1, -1 do
        if info_queue[i].set == "Other" and info_queue[i].key and poketype_list[info_queue[i].key] then
          table.remove(info_queue, i)
        end
      end
    else
      if not full_UI_table.name then
        full_UI_table.name = localize({ type = "name", set = _c.set, key = _c.key, nodes = full_UI_table.name })
      end
      card.ability.blueprint_compat_ui = card.ability.blueprint_compat_ui or ''
      card.ability.blueprint_compat_check = nil
      local main_end = (card.area and card.area == G.jokers) and {
        {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
          {n=G.UIT.C, config={ref_table = card, align = "m", colour = G.C.JOKER_GREY, r = 0.05, padding = 0.06, func = 'blueprint_compat'}, nodes={
            {n=G.UIT.T, config={ref_table = card.ability, ref_value = 'blueprint_compat_ui',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
          }}
        }}
      } or nil
      localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = {}}
      desc_nodes[#desc_nodes+1] = main_end
    end
  end,
  update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and card.area == G.jokers then
      local other_joker = G.jokers.cards[1]
      card.ability.blueprint_compat = ( other_joker and other_joker ~= card and not other_joker.debuff and other_joker.config.center.blueprint_compat and 'compatible') or 'incompatible'
      if card.ability.blueprint_compat == 'compatible' and not card.debuff and other_joker.children.center.atlas.px == 71 then
        card.children.center.atlas = other_joker.children.center.atlas
        card.children.center:set_sprite_pos(other_joker.children.center.sprite_pos)
        if other_joker.children.floating_sprite then
          card.children.floating_sprite.atlas = other_joker.children.floating_sprite.atlas
          card.children.floating_sprite:set_sprite_pos(other_joker.children.floating_sprite.sprite_pos)
          card.config.center.soul_pos.draw = other_joker.config.center.soul_pos.draw
        else
          card.children.floating_sprite.atlas = G.ASSET_ATLAS[self.atlas]
          card.children.floating_sprite:set_sprite_pos(self.soul_pos)
        end
      else
        card.children.center.atlas = G.ASSET_ATLAS[card.edition and card.edition.poke_shiny and "poke_AtlasJokersBasicGen05Shiny" or "poke_AtlasJokersBasicGen05"]
        card.children.center:set_sprite_pos(self.pos)
        card.children.floating_sprite.atlas = G.ASSET_ATLAS[card.edition and card.edition.poke_shiny and "poke_AtlasJokersBasicGen05Shiny" or "poke_AtlasJokersBasicGen05"]
        card.children.floating_sprite:set_sprite_pos(self.soul_pos)
      end
    elseif poke_is_in_collection(card) and card.children.center.sprite_pos ~= self.pos and card.children.center.atlas.name ~= self.atlas then
      self:set_ability(card)
    end
  end,
}

return {
  name = "Nacho's Hisuian Zorua Evo Line",
  enabled = nacho_config.hisuian_zorua or false,
  list = { hisuian_zorua, hisuian_zoroark }
}

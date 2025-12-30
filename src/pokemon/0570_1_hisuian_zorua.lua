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
    if other_joker and other_joker ~= card and card.ability.extra.active then
      local ret = SMODS.blueprint_effect(card, other_joker, context)
      if ret then
        ret.colour = G.C.BLACK
        return ret
      end
    end
    if context.after and G.jokers.cards[1] ~= card and card.ability.extra.active then
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
          card.ability.extra.active = false
          card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('poke_reveal_ex')})
          return true
        end }))
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
    G.E_MANAGER:add_event(Event({
      func = function()
        if card.area ~= G.jokers and not poke_is_in_collection(card) and not G.SETTINGS.paused then
          card.ability.extra.hidden_key = card.ability.extra.hidden_key or get_random_poke_key('zorua', nil, 1)
          local _o = G.P_CENTERS[card.ability.extra.hidden_key]
          card.children.center.atlas = G.ASSET_ATLAS[_o.atlas]
          card.children.center:set_sprite_pos(_o.pos)
        else
          card.children.center.atlas = G.ASSET_ATLAS[self.atlas]
          card.children.center:set_sprite_pos(self.pos)
        end
        return true
      end }))
  end,
  generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local _c = card and card.config.center or card
    local _o
    if card.ability and card.ability.extra then
      card.ability.extra.hidden_key = card.ability.extra.hidden_key or get_random_poke_key('zorua', nil, 1)
      _o = G.P_CENTERS[card.ability.extra.hidden_key]
    end
    if card.area ~= G.jokers and not poke_is_in_collection(card) and _o then
      -- Create the illusion joker's text boxes
      local temp_ability = card.ability -- temp_ability needed so we can use the illusion's config values during generate_ui
      card.ability = _o.config
      _o:generate_ui(info_queue, card, desc_nodes, specific_vars, full_UI_table)
      card.ability = temp_ability
      -- Adds the "...?" to the end of the name
      if next(full_UI_table.name[1].nodes) then
        local UIname_nodes = full_UI_table.name[1].nodes
        local textDyna = UIname_nodes[#UIname_nodes].nodes[1].config.object
        textDyna.string = textDyna.string .. localize("poke_illusion")
        textDyna.config.string = {textDyna.string}
        textDyna.strings = {}
        textDyna:update_text(true)
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
      }
      local rounds, active = 5, nil
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
        self:draw_illusion(card, other_joker)
      else
        card.children.center.atlas = G.ASSET_ATLAS["poke_AtlasJokersBasicGen05"..(card.edition and card.edition.poke_shiny and "Shiny" or "")]
        card.children.center:set_sprite_pos(self.pos)
        card.children.floating_sprite.atlas = G.ASSET_ATLAS["poke_AtlasJokersBasicGen05"..(card.edition and card.edition.poke_shiny and "Shiny" or "")]
        card.children.floating_sprite:set_sprite_pos(self.soul_pos)
        card.ability.blueprint_joker = nil
      end
    elseif poke_is_in_collection(card) and card.children.center.sprite_pos ~= self.pos and card.children.center.atlas.name ~= self.atlas then
      self:set_ability(card)
    end
  end,
  draw_illusion = function(self, card, other_joker)
    if other_joker and card.ability.blueprint_joker ~= other_joker.config.center_key then
      local _f1, _f2 = card.children.floating_sprite, nil
      card.children.center.atlas = other_joker.children.center.atlas
      card.children.center:set_sprite_pos(other_joker.children.center.sprite_pos)
      if other_joker.children.floating_sprite then
        _f2 = other_joker.children.floating_sprite
        _f1 = SMODS.create_sprite(card.T.x, card.T.y, card.T.w * (71 / _f2.atlas.px), card.T.h * (95 / _f2.atlas.py), _f2.atlas, _f2.sprite_pos)
        _f1.role.draw_major = card
        _f1.states.hover.can = false
        _f1.states.click.can = false
        card.config.center.soul_pos.draw = other_joker.config.center.soul_pos.draw
      else
        _f1:remove()
        _f1.atlas = G.ASSET_ATLAS[self.atlas]
        _f1:set_sprite_pos(self.soul_pos)
      end
      card.ability.blueprint_joker = other_joker.config.center_key
    end
  end
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
    if other_joker and other_joker ~= card and card.ability.extra.active then
      local ret = SMODS.blueprint_effect(card, other_joker, context)
      if ret then
        ret.colour = G.C.BLACK
        return ret
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
    G.E_MANAGER:add_event(Event({
      func = function()
        if card.area ~= G.jokers and not poke_is_in_collection(card) and not G.SETTINGS.paused then
          card.ability.extra.hidden_key = card.ability.extra.hidden_key or get_random_poke_key('zoroark', nil, 'poke_safari', nil, nil, {j_poke_zoroark = true})
          local _o = G.P_CENTERS[card.ability.extra.hidden_key]
          card.children.center.atlas = G.ASSET_ATLAS[_o.atlas]
          card.children.center:set_sprite_pos(_o.pos)
        else
          card.children.center.atlas = G.ASSET_ATLAS[self.atlas]
          card.children.center:set_sprite_pos(self.pos)
        end
        return true
      end }))
  end,
  generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local _c = card and card.config.center or card
    local _o
    if card.ability and card.ability.extra then
      card.ability.extra.hidden_key = card.ability.extra.hidden_key or get_random_poke_key('zoroark', nil, 'poke_safari', nil, nil, {j_poke_zoroark = true})
      _o = G.P_CENTERS[card.ability.extra.hidden_key]
    end
    if card.area ~= G.jokers and not poke_is_in_collection(card) and _o then
      -- Create the illusion joker's text boxes
      local temp_ability = card.ability -- temp_ability needed so we can use the illusion's config values during generate_ui
      card.ability = _o.config
      _o:generate_ui(info_queue, card, desc_nodes, specific_vars, full_UI_table)
      card.ability = temp_ability
      -- Adds the "...?" to the end of the name
      if next(full_UI_table.name[1].nodes) then
        local UIname_nodes = full_UI_table.name[1].nodes
        local textDyna = UIname_nodes[#UIname_nodes].nodes[1].config.object
        textDyna.string = textDyna.string .. localize("poke_illusion")
        textDyna.config.string = {textDyna.string}
        textDyna.strings = {}
        textDyna:update_text(true)
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
      }
      localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = {}}
      desc_nodes[#desc_nodes+1] = main_end
    end
  end,
  update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and card.area == G.jokers then
      local other_joker = G.jokers.cards[1]
      card.ability.blueprint_compat = ( other_joker and other_joker ~= card and not other_joker.debuff and other_joker.config.center.blueprint_compat and 'compatible') or 'incompatible'
      if card.ability.blueprint_compat == 'compatible' and not card.debuff and other_joker.children.center.atlas.px == 71 then
        self:draw_illusion(card, other_joker)
      else
        card.children.floating_sprite:remove()
        card.children.center.atlas = G.ASSET_ATLAS["poke_AtlasJokersBasicGen05"..(card.edition and card.edition.poke_shiny and "Shiny" or "")]
        card.children.center:set_sprite_pos(self.pos)
        card.children.floating_sprite.atlas = G.ASSET_ATLAS["poke_AtlasJokersBasicGen05"..(card.edition and card.edition.poke_shiny and "Shiny" or "")]
        card.children.floating_sprite:set_sprite_pos(self.soul_pos)
        card.ability.blueprint_joker = nil
      end
    elseif poke_is_in_collection(card) and card.children.center.sprite_pos ~= self.pos and card.children.center.atlas.name ~= self.atlas then
      self:set_ability(card)
    end
  end,
  draw_illusion = function(self, card, other_joker)
    if other_joker and card.ability.blueprint_joker ~= other_joker.config.center_key then
      local _f1, _f2 = card.children.floating_sprite, nil
      card.children.center.atlas = other_joker.children.center.atlas
      card.children.center:set_sprite_pos(other_joker.children.center.sprite_pos)
      if other_joker.children.floating_sprite then
        _f2 = other_joker.children.floating_sprite
        _f1 = SMODS.create_sprite(card.T.x, card.T.y, card.T.w * (71 / _f2.atlas.px), card.T.h * (95 / _f2.atlas.py), _f2.atlas, _f2.sprite_pos)
        _f1.role.draw_major = card
        _f1.states.hover.can = false
        _f1.states.click.can = false
        card.config.center.soul_pos.draw = other_joker.config.center.soul_pos.draw
      else
        _f1:remove()
        _f1.atlas = G.ASSET_ATLAS[self.atlas]
        _f1:set_sprite_pos(self.soul_pos)
      end
      card.ability.blueprint_joker = other_joker.config.center_key
    end
  end
}

return {
  config_key = "hisuian_zorua",
  list = { hisuian_zorua, hisuian_zoroark }
}

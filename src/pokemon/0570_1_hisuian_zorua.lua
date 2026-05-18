-- ILLUSION-RELATED FUNCTIONS
local function draw_illusion(card, other_joker)
  -- Set sprite atlas + position to other joker's
  card.children.center.atlas = other_joker.children.center.atlas
  card.children.center:set_sprite_pos(other_joker.children.center.sprite_pos)
  -- do the same for floating sprites if they exist
  if other_joker.children.floating_sprite then
    card.children.floating_sprite.atlas = other_joker.children.floating_sprite.atlas
    card.children.floating_sprite:set_sprite_pos(other_joker.children.floating_sprite.sprite_pos)
  else
    card.children.floating_sprite.atlas = SMODS.get_atlas(card.config.center.atlas)
    card.children.floating_sprite:set_sprite_pos(card.config.center.soul_pos)
  end
  -- save other joker's center key to loosely track position
  card.ability.blueprint_joker = other_joker.config.center_key
end

local function remove_illusion(card)
  card.children.floating_sprite:remove()
  -- Reset atlas + position
  card.children.center.atlas = G.ASSET_ATLAS["poke_AtlasJokersBasicGen05"..(card.edition and card.edition.poke_shiny and "Shiny" or "")]
  card.children.center:set_sprite_pos(card.config.center.pos)
  -- Reset floating sprite atlas + position
  card.children.floating_sprite.atlas = G.ASSET_ATLAS["poke_AtlasJokersBasicGen05"..(card.edition and card.edition.poke_shiny and "Shiny" or "")]
  card.children.floating_sprite:set_sprite_pos(card.config.center.soul_pos)
  -- Stop tracking targeted joker
  card.ability.blueprint_joker = nil
end

-- Illusion UIBox
local function illusion_uibox(other_center, info_queue, card, desc_nodes, specific_vars, full_UI_table)
  -- Create the illusion joker's text boxes
  local temp_ability = copy_table(card.ability) -- temp_ability needed so we can use the illusion's config values during generate_ui
  for k, v in pairs(other_center.config) do card.ability[k] = v end
  other_center:generate_ui(info_queue, card, desc_nodes, specific_vars, full_UI_table)
  card.ability = temp_ability
  -- Adds the "...?" to the end of the name
  if next(full_UI_table.name[1].nodes) then
    local UIname_nodes = full_UI_table.name[1].nodes
    local textDyna = UIname_nodes[#UIname_nodes].nodes[1].config.object
    textDyna:replace_text(textDyna.string .. localize("poke_illusion"))
  end
end


-- ACTUAL JOKERS
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
  loc_vars = function(self, info_queue, card)
    local a = card.ability.extra or self.config.extra
		return {vars = {a.rounds, colours = {not a.active and G.C.UI.TEXT_INACTIVE}}}
  end,
  calculate = function(self, card, context)
    local a, other_joker = card.ability.extra, G.jokers.cards[1]
    if other_joker and other_joker ~= card and a.active then
      local ret = SMODS.blueprint_effect(card, other_joker, context)
      if ret then
        ret.colour = G.C.BLACK
        return ret
      end
    end
    if context.after and G.jokers.cards[1] ~= card and a.active then
      PkmnDip.defer(function()
        a.active = false
        SMODS.calculate_effect({message = localize('poke_reveal_ex')}, card)
      end, 0.2)
    end
    if context.end_of_round and context.main_eval then
      a.active = true
      SMODS.calculate_effect({message = localize('k_reset')}, card)
    end
    return level_evo(self, card, context, "j_nacho_hisuian_zoroark")
  end,
  set_ability = function(self, card, initial, delay_sprites)
    if not type_sticker_applied(card) and not poke_is_in_collection(card) and not G.SETTINGS.paused then
      apply_type_sticker(card, "Colorless")
    end
    PkmnDip.defer(function()
      if card.area ~= G.jokers and not G.SETTINGS.paused then
        card.ability.extra.hidden_key = card.ability.extra.hidden_key or get_random_poke_key('zorua', nil, 1)
        local _o = G.P_CENTERS[card.ability.extra.hidden_key]
        card.children.center.atlas = SMODS.get_atlas(_o.atlas)
        card.children.center:set_sprite_pos(_o.pos)
      else
        card.children.center.atlas = SMODS.get_atlas(self.atlas)
        card.children.center:set_sprite_pos(self.pos)
      end
    end)
  end,
  generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local _c = card.config and card.config.center or card
    local _a = card.ability and card.ability.extra
    local _o
    if _a then
      _a.hidden_key = _a.hidden_key or get_random_poke_key('zorua', nil, 1)
      _o = G.P_CENTERS[_a.hidden_key]
    end
    -- Illusion UIBox
    if card.area ~= G.jokers and not poke_is_in_collection(card) and _o then
      illusion_uibox(_o, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    -- Regular UIBox
    else
      full_UI_table.name = localize({ type = "name", set = _c.set, key = _c.key, nodes = full_UI_table.name })
      localize{ type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes,
        vars = { rounds = _o and _a.rounds or 5, colours = { not (_a and _a.active) and G.C.UI.TEXT_INACTIVE } } }
      local main_end = (card.area and card.area == G.jokers) and poke_blueprint_compat_ui(G.jokers.cards[1] ~= card and G.jokers.cards[1])
      desc_nodes[#desc_nodes+1] = main_end
    end
  end,
  update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and card.area == G.jokers then
      if card.ability.extra.hidden_key then card.ability.extra.hidden_key = nil end
      local other_joker = G.jokers.cards[1]
      card.ability.blueprint_compat =
        (other_joker and other_joker ~= card and not other_joker.debuff and other_joker.config.center.blueprint_compat)
        and 'compatible'
        or 'incompatible'
      if card.ability.blueprint_compat == 'compatible' and not card.debuff and card.ability.extra.active then
        if other_joker and card.ability.blueprint_joker ~= other_joker.config.center_key then
          draw_illusion(card, other_joker)
        end
      else
        remove_illusion(card)
      end
    elseif poke_is_in_collection(card) and card.children.center.sprite_pos ~= self.pos and card.children.center.atlas.name ~= self.atlas then
      self:set_ability(card)
    end
  end,
  attributes = {"copying", "round_evo"},
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
    if G.jokers.cards[1] and G.jokers.cards[1] ~= card then
      local ret = SMODS.blueprint_effect(card, G.jokers.cards[1], context)
      if ret then
        ret.colour = G.C.BLACK
        return ret
      end
    end
  end,
  set_ability = function(self, card, initial, delay_sprites)
    if not type_sticker_applied(card) and not poke_is_in_collection(card) and not G.SETTINGS.paused then
      apply_type_sticker(card, "Colorless")
    end
    PkmnDip.defer(function()
      if card.area ~= G.jokers and not G.SETTINGS.paused then
        card.ability.extra.hidden_key = card.ability.extra.hidden_key
          or get_random_poke_key('zoroark', nil, 'poke_safari', nil, nil, {j_poke_zoroark = true, j_nacho_hisuian_zoroark = true})
        local _o = G.P_CENTERS[card.ability.extra.hidden_key]
        card.children.center.atlas = SMODS.get_atlas(_o.atlas)
        card.children.center:set_sprite_pos(_o.pos)
      else
        card.children.center.atlas = SMODS.get_atlas(self.atlas)
        card.children.center:set_sprite_pos(self.pos)
      end
    end)
  end,
  generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local _c = card.config and card.config.center or card
    local _a = card.ability and card.ability.extra
    local _o
    if _a then
      _a.hidden_key = _a.hidden_key or get_random_poke_key('zoroark', nil, 'poke_safari', nil, nil, {j_poke_zoroark = true, j_nacho_hisuian_zoroark = true})
      _o = G.P_CENTERS[card.ability.extra.hidden_key]
    end
    -- Illusion UI Box
    if card.area ~= G.jokers and not poke_is_in_collection(card) and _o then
      illusion_uibox(_o, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    -- Regular UI Box
    else
      full_UI_table.name = localize({ type = "name", set = _c.set, key = _c.key, nodes = full_UI_table.name })
      localize{ type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = {} }
      local main_end = (card.area and card.area == G.jokers) and poke_blueprint_compat_ui(G.jokers.cards[1] ~= card and G.jokers.cards[1])
      desc_nodes[#desc_nodes+1] = main_end
    end
  end,
  update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and card.area == G.jokers then
      if card.ability.extra.hidden_key then card.ability.extra.hidden_key = nil end
      local other_joker = G.jokers.cards[1]
      card.ability.blueprint_compat =
        (other_joker and other_joker ~= card and not other_joker.debuff and other_joker.config.center.blueprint_compat)
        and 'compatible'
        or 'incompatible'
      if card.ability.blueprint_compat == 'compatible' and not card.debuff then
        if other_joker and card.ability.blueprint_joker ~= other_joker.config.center_key then
          draw_illusion(card, other_joker)
        end
      else
        remove_illusion(card)
      end
    elseif poke_is_in_collection(card) and card.children.center.sprite_pos ~= self.pos and card.children.center.atlas.name ~= self.atlas then
      self:set_ability(card)
    end
  end,
  attributes = {"copying"},
}

return {
  config_key = "hisuian_zorua",
  list = { hisuian_zorua, hisuian_zoroark }
}

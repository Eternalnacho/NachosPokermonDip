-- Passimian 766
local passimian={
  name = "passimian",
  soul_pos = { x = 99, y = 99 },
  config = {extra = {}},
  rarity = 3,
  cost = 8,
  stage = "Basic",
  ptype = "Fighting",
  perishable_compat = false,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if not card.ability.received_card then
      if context.selling_card and not context.selling_self and context.card.area == G.jokers and context.card.config.center.key ~= 'j_nacho_passimian' and not context.blueprint then
        self:receive_card(card, context.card.config.center.key, context)
      elseif context.joker_type_destroyed and context.card.area == G.jokers and context.card.config.center.key ~= 'j_nacho_passimian' and not context.blueprint then
        self:receive_card(card, context.card.config.center.key, context)
      end
    elseif card.ability.received_card.calculate and (card.ability.received_card.blueprint_compat or not context.blueprint) then
      return card.ability.received_card:calculate(card, context)
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    return card.ability.received_card and card.ability.received_card.add_to_deck and card.ability.received_card:add_to_deck(card, from_debuff)
  end,
  remove_from_deck = function(self, card, from_debuff)
    if card.ability.extra.received_edition and not from_debuff then G.jokers.config.card_limit = G.jokers.config.card_limit - 1 end
    return card.ability.received_card and card.ability.received_card.remove_from_deck and card.ability.received_card:remove_from_deck(card, from_debuff)
  end,
  calc_dollar_bonus = function(self, card)
    return card.ability.received_card and card.ability.received_card.calc_dollar_bonus and card.ability.received_card:calc_dollar_bonus(card)
  end,
  receive_card = function(self, card, to_key, context)
    if to_key and G.P_CENTERS[to_key].stage then
      local _r = G.P_CENTERS[to_key]
      -- Keep relevant values stored
      local values_to_keep = {}
      if card.ability.received_card then
        values_to_keep = PkmnDip.keep_values(card)
      elseif context and context.card and context.card.ability then
        values_to_keep = PkmnDip.keep_values(context.card)
      end
      -- Set ability to received card's
      for k, v in pairs(_r.config) do
        card.ability[k] = type(v) == 'table' and copy_table(v) or v
      end
      card.ability.received_card = _r
      -- Re-add kept values and handle energy, type
      if next(values_to_keep) then PkmnDip.get_kept_values(card, values_to_keep) end
      if card.ability.extra.energy_count or card.ability.extra.c_energy_count then pokermon.energy.energize(card, nil, true, true) end
      card.ability.extra.ptype = "Fighting"
      -- Calls the add_to_deck function of the received card if it exists
      if _r.add_to_deck then _r:add_to_deck(card) end
      -- play the funny noises
      local edition = context and context.card and context.card.edition and not context.card.edition.negative and context.card.edition or card.edition
      local args = { message = localize('poke_receiver_ex'), colour = edition and G.C.DARK_EDITION }
      if edition then
        sound = G.P_CENTERS[edition.key].sound; sound.pitch = edition.type == 'poke_shiny' and 1 or 2
        for k, v in pairs(sound) do args[k] = v end
        card.ability.extra.received_edition = true
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
      end
      SMODS.calculate_effect(args, card)
    end
  end,
  load = function(self, card, table, other_card)
    table.ability.received_card = G.P_CENTERS[table.received_key]
  end,
  generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local _c = card and card.config.center
    full_UI_table.name = localize({ type = "name", set = _c.set, key = _c.key, nodes = full_UI_table.name })
    if card and card.ability and card.ability.received_card then
      local r_center = card.ability.received_card
      -- Info_queue for received card
      local v = {}; if r_center.loc_vars then v = r_center:loc_vars({}, card) or {} end
      local r_name = localize({type = "name_text", set = v.set or r_center.set, key = v.key or r_center.key})
      if r_name:match("#%d+#") and v.vars then
        r_name = r_name:gsub("#(%d+)#", "%1")
        r_name = v.vars[tonumber(r_name)]
      else
        r_name = r_name:gsub('(%l+)(%u)', '%1 %2') -- HisuianSneasel -> Hisuian Sneasel
      end
      info_queue[#info_queue + 1] = {set = 'Other', key = 'received_card', vars = {r_name}}
      -- Use generic generate_ui func with received center
      return SMODS.Center.generate_ui(r_center, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    else
      pokermon.type_tooltip(self, info_queue, card)
      localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes}
    end
  end,
  update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and card.area == G.jokers and (card.children.center.atlas ~= self.atlas or card.children.center.pos ~= self.pos) then
      card.children.center.atlas = SMODS.get_atlas(card.edition and card.edition.poke_shiny and "poke_AtlasJokersBasicNatdexShiny" or "poke_AtlasJokersBasicNatdex")
      card.children.center:set_sprite_pos(self.pos)
    end
  end,
  attributes = {"joker", "joker_slot", "copying"}
}

local init = function()
  -- Card.save hook to save received card key
  local save_card = Card.save
  Card.save = function (self)
    local saved_table = save_card(self)
    if self.config.center_key == 'j_nacho_passimian' and self.area == G.jokers and self.ability.received_card then
      saved_table.received_key = self.ability.received_card.key
    end
    return saved_table
  end

  -- find_card hooks
  local smods_fc = SMODS.find_card
  function SMODS.find_card(key, count_debuffed)
    local results = smods_fc(key, count_debuffed)
    if not G.jokers or not G.jokers.cards then return {} end
    for _, area in ipairs(SMODS.get_card_areas('jokers')) do
      if area.cards then
        for _, v in pairs(area.cards) do
          if v and type(v) == 'table' and v.ability
              and v.ability.received_card and v.ability.received_card.key == key
              and (count_debuffed or not v.debuff) then
            table.insert(results, v)
          end
        end
      end
    end
    return results
  end

  local poke_fc = pokermon.find_card
  function pokermon.find_card(key_or_function, use_highlighted)
    return poke_fc(function(joker)
        return joker.ability.received_card and (joker.ability.received_card == key_or_function
        or joker.ability.received_card.key == key_or_function) end, use_highlighted)
      or poke_fc(key_or_function, use_highlighted)
  end

  local poke_csp_ref = pokermon.can_set_sprite
  pokermon.can_set_sprite = function(card)
    if card.config.center_key == 'j_nacho_passimian' then return false end
    return poke_csp_ref(card)
  end

  -- pokermon.energy.energize hook
  local energize_ref = pokermon.energy.energize
  pokermon.energy.energize = function(card, etype, evolving, silent, amount, center)
    if card.config.center.key == 'j_nacho_passimian' and card.ability.received_card then
      center = card.ability.received_card
    end
    energize_ref(card, etype, evolving, silent, amount, center)
  end
end

return {
  config_key = "passimian",
  init = init,
  list = { passimian }
}
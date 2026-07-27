local keep_values = function(card)
  local names_to_keep = {"targets", "rank", "id", "cards_scored", "cards_drawn", "energy_count", "c_energy_count", "e_limit_up", "form"}
  if pokermon.type_sticker_applied(card) then table.insert(names_to_keep, "ptype") end
  local values_to_keep = pokermon.copy_scaled_values(card)
  if type(card.ability.extra) == "table" then
    for _, k in pairs(names_to_keep) do
      values_to_keep[k] = card.ability.extra[k]
    end
  end
  if card.config.center.poke_custom_values_to_keep then
    for _, v in pairs(card.config.center.poke_custom_values_to_keep) do
      values_to_keep[v] = card.ability.extra[v]
    end
  end
  return values_to_keep
end

local get_kept_values = function(card, kept_vals)
  for k, v in pairs(kept_vals) do
    card.ability[k] = type(v) == 'table' and copy_table(v) or v
    if type(card.ability.extra) == "table" and (card.ability.extra[k] or k == "energy_count" or k == "c_energy_count" or k == "e_limit_up")
        and (type(card.ability.extra[k]) ~= "number" or (type(v) == "number" and v > card.ability.extra[k])) then
      card.ability.extra[k] = v
    end
  end
end


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
    local received = card.ability.received_card
    if not received then
      if (context.selling_card and not context.selling_self) or context.joker_type_destroyed then
        local c = context.card
        if c.area == G.jokers and c.config.center_key ~= self.key and not context.blueprint then
          self:receive_card(card, c.config.center_key, context)
        end
      end
    elseif received.calculate and (received.blueprint_compat or not context.blueprint) then
      return received:calculate(card, context)
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    local received = card.ability.received_card
    return received and received.add_to_deck and received:add_to_deck(card, from_debuff)
  end,
  remove_from_deck = function(self, card, from_debuff)
    local received = card.ability.received_card
    if card.ability.extra.received_edition and not from_debuff then
      G.jokers.config.card_limit = G.jokers.config.card_limit - 1
    end
    return received and received.remove_from_deck and received:remove_from_deck(card, from_debuff)
  end,
  calc_dollar_bonus = function(self, card)
    local received = card.ability.received_card
    return received and received.calc_dollar_bonus and received:calc_dollar_bonus(card)
  end,
  receive_card = function(self, card, to_key, context)
    if to_key and G.P_CENTERS[to_key].stage then
      local _r = G.P_CENTERS[to_key]
      -- Keep relevant values stored
      local values_to_keep = {}
      if card.ability.received_card then
        values_to_keep = keep_values(card)
      elseif context and context.card and context.card.ability then
        values_to_keep = keep_values(context.card)
      end
      -- Set ability to received card's
      for k, v in pairs(_r.config) do
        card.ability[k] = type(v) == 'table' and copy_table(v) or v
      end
      card.ability.received_card = _r
      -- Re-add kept values and handle energy, type
      if next(values_to_keep) then get_kept_values(card, values_to_keep) end
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
      r_name = type(r_name) == 'string' and r_name or ''
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
      card.children.center.atlas = SMODS.get_atlas("poke_AtlasJokersBasicNatdex" .. (PkmnDip.con.is_shiny(card) and "Shiny" or ""))
      card.children.center:set_sprite_pos(self.pos)
    end
  end,
  attributes = {"joker", "joker_slot", "copying"}
}

local init = function()
  -- Card.save hook to save received card key
  PkmnDip.Hook("around", Card, 'save', function(orig, self) 
    local saved_table = orig(self)
    if self.config.center_key == 'j_nacho_passimian' and self.area == G.jokers and self.ability.received_card then
      saved_table.received_key = self.ability.received_card.key
    end
    return saved_table
  end)

  -- find_card hooks
  PkmnDip.Hook("around", SMODS, 'find_card', function(orig, key, count_debuffed, ...)
    local results = orig(key, count_debuffed)
    if G.jokers and type(results) == "table" then
      PkmnDip.utils.for_each(SMODS.get_card_areas('jokers'), function(area) 
        if area.cards then
          pokermon.table_append(results, PkmnDip.utils.filter(area.cards, function(card)
            return type(card) == "table" and card.ability
               and card.ability.received_card
               and card.ability.received_card.key == key
               and (count_debuffed or not card.debuff)
          end))
        end
      end)
    end
    return results
  end)

  PkmnDip.Hook("around", pokermon, 'find_card', function(orig, key_or_function, use_highlighted, ...)
    local ret = orig(function(joker) 
      return joker.ability.received_card and (joker.ability.received_card == key_or_function
          or joker.ability.received_card.key == key_or_function)
    end, use_highlighted, ...)
    return ret or orig(key_or_function, use_highlighted, ...)
  end)

  PkmnDip.Hook("around", pokermon, 'can_set_sprite', function(orig, card, ...)
    if card.config.center_key == 'j_nacho_passimian' then return false end
    return orig(card, ...)
  end)

  -- pokermon.evolve and pokermon.backend_evolve hooks for passimian's received card
  PkmnDip.Hook("around", pokermon, 'evolve', function(orig, card, to_key, immediate, evolve_message, transformation, energize_amount) 
    if card.config.center.key == 'j_nacho_passimian' and not transformation then
      card.ability.extra.pass_evolving = true
      immediate = true
    end
    return orig(card, to_key, immediate, evolve_message, transformation, energize_amount)
  end)

  PkmnDip.Hook("before", pokermon, 'backend_evolve', function(card, to_key, energize_amount) 
    if card.config.center.key == 'j_nacho_passimian' and card.ability.extra.pass_evolving then
      card.ability.extra.pass_evolving = nil
      card.config.center:receive_card(card, to_key)
      return true
    end
  end)
  
  -- pokermon.energy.energize hook
  PkmnDip.Hook("around", pokermon.energy, 'energize', function(orig, card, etype, evolving, silent, amount, center, ...) 
    if card.config.center.key == 'j_nacho_passimian' and card.ability.received_card then
      center = card.ability.received_card
    end
    return orig(card, etype, evolving, silent, amount, center, ...)
  end)
end

return {
  config_key = "passimian",
  init = init,
  list = { passimian }
}
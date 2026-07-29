local get_values_to_keep = function(card)
  local names_to_keep = {
    "targets", "rank", "id", "form",
    "cards_scored", "cards_drawn",
    "energy_count", "c_energy_count", "e_limit_up",
    pokermon.type_sticker_applied(card) and "ptype"
  }
  if card.config.center.poke_custom_values_to_keep then
    PkmnDip.utils.append(names_to_keep, card.config.center.poke_custom_values_to_keep)
  end
  local values_to_keep = pokermon.copy_scaled_values(card)
  if type(card.ability.extra) == "table" then
    local keep_value = function(val) values_to_keep[val] = card.ability.extra[val] end
    PkmnDip.utils.for_each(names_to_keep, keep_value)
  end
  return values_to_keep
end

local get_kept_values = function(card, kept_vals)
  for k, v in pairs(kept_vals) do
    card.ability[k] = type(v) == 'table' and copy_table(v) or v
    if type(card.ability.extra) == "table" 
        and (card.ability.extra[k] or k == "energy_count" or k == "c_energy_count" or k == "e_limit_up")
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
    local received = self:get_received(card)
    if not received and not context.blueprint then
      if (context.selling_card and not context.selling_self) or context.joker_type_destroyed then
        local c = context.card
        if c.area == G.jokers and c.config.center_key ~= self.key then
          self:receive_card(card, c.config.center_key, context)
        end
      end
    elseif received and received.calculate and (received.blueprint_compat or not context.blueprint) then
      return received:calculate(card, context)
    end
  end,
  receive_card = function(self, card, to_key, context)
    if to_key and G.P_CENTERS[to_key].stage then
      local _r = G.P_CENTERS[to_key]

      -- Keep relevant values stored
      local target = (card.ability.received_card and card) or (context and context.card)
      local values_to_keep = get_values_to_keep(target)

      -- Set ability to received card's
      for k, v in pairs(_r.config) do
        card.ability[k] = type(v) == 'table' and copy_table(v) or v
      end
      card.ability.received_card = _r.key

      -- Re-add kept values and handle energy, type
      if next(values_to_keep) then get_kept_values(card, values_to_keep) end
      if card.ability.extra.energy_count or card.ability.extra.c_energy_count then
        pokermon.energy.energize(card, nil, true, true)
      end
      card.ability.extra.ptype = "Fighting"

      -- Calls the add_to_deck function of the received card if it exists
      if _r.add_to_deck then _r:add_to_deck(card) end

      -- Update JokerDisplay definition if JokerDisplay is loaded
      if (SMODS.Mods["JokerDisplay"] or {}).can_load then
        PkmnDip.update_pass_joker_display(card)
        card:update_joker_display(false, true)
      end

      -- play the funny noises
      local edition = context and context.card and context.card.edition
      if edition then card:set_edition(edition.key) end
      SMODS.calculate_effect({ message = localize('poke_receiver_ex'), colour = edition and G.C.DARK_EDITION }, card)
    end
  end,
  get_received = function(self, card)
    return card and card.ability and card.ability.received_card and G.P_CENTERS[card.ability.received_card]
  end,
  generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local _c = card and card.config.center
    local received = self:get_received(card)
    full_UI_table.name = localize({ type = "name", set = _c.set, key = _c.key, nodes = full_UI_table.name })
    if received then
      -- Info_queue for received card
      local v = received.loc_vars and received:loc_vars({}, card) or {}
      local r_name = localize({ type = "name_text", set = v.set or received.set, key = v.key or received.key, vars = v.vars })
      r_name = type(r_name) == 'string' and r_name:gsub('(%l+)(%u)', '%1 %2') -- HisuianSneasel -> Hisuian Sneasel
      info_queue[#info_queue + 1] = { set = 'Other', key = 'received_card', vars = {r_name} }
      -- Use generic generate_ui func with received center
      return SMODS.Center.generate_ui(received, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    else
      localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes}
    end
  end,
  update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and card.area == G.jokers and (card.children.center.atlas ~= self.atlas or card.children.center.pos ~= self.pos) then
      card.children.center.atlas = SMODS.get_atlas("poke_AtlasJokersBasicNatdex" .. (PkmnDip.con.is_shiny(card) and "Shiny" or ""))
      card.children.center:set_sprite_pos(self.pos)
    end
  end,
  attributes = {"joker", "copying"}
}

for _, func in pairs({
  "add_to_deck",
  "remove_from_deck",
  "calc_dollar_bonus",
  "calc_scaling"
}) do
  passimian[func] = function(self, card, ...)
    local received = self:get_received(card)
    return received and received[func] and received[func](received, card, ...)
  end
end

passimian.loc_vars = function(self, info_queue, card)
  local received = self:get_received(card)
  if received then
    local vars = received.loc_vars and received:loc_vars(info_queue, card) or {}
    return { key = vars.key or received.key, vars = vars.vars } 
  end
end

local init = function()
  -- find_card hooks
  PkmnDip.Hook("around", SMODS, 'find_card', function(orig, key, count_debuffed, ...)
    local results = orig(key, count_debuffed)
    if G.jokers and type(results) == "table" then
      PkmnDip.utils.for_each(SMODS.get_card_areas('jokers'), function(area) 
        if area.cards then
          pokermon.table_append(results, PkmnDip.utils.filter(area.cards, function(card)
            return type(card) == "table" and card.ability
               and card.ability.received_card == key
               and (count_debuffed or not card.debuff)
          end))
        end
      end)
    end
    return results
  end)

  PkmnDip.Hook("around", pokermon, 'find_card', function(orig, key_or_function, use_highlighted, ...)
    local ret = orig(function(joker) return joker.ability.received_card == key_or_function end, use_highlighted, ...)
    return orig(key_or_function, use_highlighted, ...) or ret
  end)

  PkmnDip.Hook("around", pokermon, 'can_set_sprite', function(orig, card, ...)
    if card.config.center_key == 'j_nacho_passimian' then return false end
    return orig(card, ...)
  end)

  -- pokermon.evolve and pokermon.backend_evolve hooks for passimian's received card
  PkmnDip.Hook("around", pokermon, 'evolve', function(orig, card, to_key, immediate, evolve_message, transformation, energize_amount) 
    if card.config.center.key == 'j_nacho_passimian' and not transformation then
      card.pass_evolving = true
      immediate = true
    end
    return orig(card, to_key, immediate, evolve_message, transformation, energize_amount)
  end)

  PkmnDip.Hook("before", pokermon, 'backend_evolve', function(card, to_key, ...) 
    if card.config.center.key == 'j_nacho_passimian' and card.pass_evolving then
      card.pass_evolving = nil
      card.config.center:receive_card(card, to_key)
      return true
    end
  end)
  
  -- pokermon.energy.energize hook
  PkmnDip.Hook("around", pokermon.energy, 'energize', function(orig, card, etype, evolving, silent, amount, center, ...) 
    if card.config.center.key == 'j_nacho_passimian' and card.ability.received_card then
      center = card.config.center:get_received(card)
    end
    return orig(card, etype, evolving, silent, amount, center, ...)
  end)  
end

return {
  config_key = "passimian",
  init = init,
  list = { passimian }
}
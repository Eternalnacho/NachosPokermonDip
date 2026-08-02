-- Passimian 766
local passimian={
  name = "passimian",
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    local received = self:get_received(card)
    if received then
      local vars = received.loc_vars and received:loc_vars(info_queue, card) or {}
      return { key = vars.key or received.key, vars = vars.vars } 
    end
  end,
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
  get_received = function(self, card)
    return card and card.ability and card.ability.received_card and G.P_CENTERS[card.ability.received_card]
  end,
  generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local received = self:get_received(card)
    full_UI_table.name = localize({ type = "name", set = self.set, key = self.key, nodes = full_UI_table.name })
    -- Routing the generic SMODS.Center generate_ui through either self or received center
    if received then
      -- Info_queue for received card
      local v = received.loc_vars and received:loc_vars({}, card) or {}
      local r_name = localize({ type = "name_text", set = v.set or received.set, key = v.key or received.key, vars = v.vars })
      r_name = type(r_name) == 'string' and r_name:gsub('(%l+)(%u)', '%1 %2') or r_name -- HisuianSneasel -> Hisuian Sneasel
      info_queue[#info_queue + 1] = { set = 'Other', key = 'received_card', vars = {r_name} }

      return SMODS.Center.generate_ui(received, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    else
      return SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
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

passimian.receive_card = function(self, card, to_key, context)
  if to_key and G.P_CENTERS[to_key].stage then
    local _r = G.P_CENTERS[to_key]

    -- Keep relevant values stored
    local target = (card.ability.received_card and card) or (context and context.card)
    local values_to_keep, custom_values_to_keep = pokermon.get_values_to_keep(target)

    local old_center = (target == card and self:get_received(card)) or target.config.center
    if old_center.poke_custom_values_to_keep then
      custom_values_to_keep = custom_values_to_keep or {}
      local add_target_val = function(v) custom_values_to_keep[v] = target.ability.extra[v] end
      PkmnDip.utils.for_each(old_center.poke_custom_values_to_keep, add_target_val)
    end

    -- Set ability to received card's
    for k, v in pairs(_r.config) do
      card.ability[k] = type(v) == 'table' and copy_table(v) or v
    end
    card.ability.received_card = _r.key

    -- Hooks into the center's set_sprites func if it exists
    if type(_r.set_sprites) == 'function' and not _r.hooked_by_pass then
      PkmnDip.Hook("before", _r, 'set_sprites', function(_self, _card, _front)
        if _card.config.center_key == 'j_nacho_passimian' then return true end
      end)
      _r.hooked_by_pass = true
    end

    -- Re-add kept values and handle energy, type
    pokermon.apply_kept_values(card, _r, values_to_keep, custom_values_to_keep)
    if pokermon.type_sticker_applied(target) then pokermon.apply_type_sticker(card, pokermon.get_type(target)) end

    -- Calls the add_to_deck function of the received card if it exists
    if _r.add_to_deck then _r:add_to_deck(card, false) end
    
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
end

local init = function()
  -- find_card hooks
  PkmnDip.Hook("around", SMODS, 'find_card', function(orig, key, count_debuffed, ...)
    local results = orig(key, count_debuffed)
    if G.jokers and type(results) == "table" then
      local is_target = function(card)
        return type(card) == "table" and card.ability
           and card.ability.received_card == key
           and (count_debuffed or not card.debuff)
      end
      local get_targets = function(area) PkmnDip.utils.append(results, PkmnDip.utils.filter(area.cards, is_target)) end
      local areas = PkmnDip.utils.filter(SMODS.get_card_areas('jokers'), function(a) return a.cards end)
      PkmnDip.utils.for_each(areas, get_targets)
    end
    return results
  end)

  PkmnDip.Hook("around", pokermon, 'find_card', function(orig, key_or_function, use_highlighted, ...)
    local ret = orig(function(joker) return joker.ability.received_card == key_or_function end, use_highlighted, ...)
    return orig(key_or_function, use_highlighted, ...) or ret
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
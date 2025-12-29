-- Passimian 766
local passimian={
  name = "passimian",
  config = {extra = {kept_vals = {}}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {}}
  end,
  rarity = 3,
  cost = 8,
  stage = "Basic",
  ptype = "Fighting",
  perishable_compat = false,
  blueprint_compat = false,
  eternal_compat = true,
  calculate = function(self, card, context)
    if not card.ability.received_card then
      if context.selling_card and not context.selling_self and context.cardarea == G.jokers and not context.blueprint
          and not PkmnDip.utils.contains(self.banlist, context.card.config.center.key) then
        if context.card.area == G.jokers then self:receive_card(card, context.card.config.center.key, context) end
      end
      if context.joker_type_destroyed and context.cardarea == G.jokers and not context.blueprint
          and not PkmnDip.utils.contains(self.banlist, context.card.config.center.key) then
        self:receive_card(card, context.card.config.center.key, context)
      end
    elseif card.ability.received_card.calculate then
      local ret = card.ability.received_card:calculate(card, context)
      return ret
    end
  end,
  receive_card = function(self, card, to_key, context)
    if to_key then
      local _r = G.P_CENTERS[to_key]
      -- Keep relevant values stored
      local values_to_keep = {}
      if card.ability.received_card then
        values_to_keep = copy_scaled_values(card)
      elseif context and context.card and context.card.ability then
        -- Smeargle is annoying to make work
        if context.card.ability.extra and context.card.ability.extra.copy_joker then
          context.card.ability.extra.copy_joker = nil
        end
        -- I guess we have to make sure stickers *don't* get passed along
        local exceptions = {}
        for k, v in pairs(SMODS.Stickers) do
          if context.card.ability[v.key] then exceptions[#exceptions+1] = context.card.ability[v.key] end
        end
        -- and also the extra card limit on negatives apparently *sigh*
        if context.card.ability.card_limit then exceptions[#exceptions+1] = context.card.ability.card_limit end
        for k, v in pairs(context.card.ability) do
          if not PkmnDip.utils.contains(exceptions, v) then
            if type(v) == 'table' then
              values_to_keep[k] = copy_table(v)
            else
              values_to_keep[k] = v
            end
          end
        end
      end

      -- Set ability to received card's
      for k, v in pairs(_r.config) do
        card.ability[k] = type(v) == 'table' and copy_table(v) or v
      end
      card.ability.received_card = _r

      -- Re-add kept values
      if values_to_keep ~= {} then
        for k, v in pairs(values_to_keep) do
          card.ability[k] = type(v) == 'table' and copy_table(v) or v
        end
      end

      if type(card.ability.extra) == "table" and values_to_keep ~= {} then
        for k, v in pairs(values_to_keep) do
          if card.ability.extra[k] or k == "energy_count" or k == "c_energy_count" or k == "e_limit_up" then
            if type(card.ability.extra[k]) ~= "number" or (type(v) == "number" and v > card.ability.extra[k]) then
              card.ability.extra[k] = v
            end
          end
        end
      end

      -- Keep the fighting type, and re-check blueprint compatibility
      card.ability.extra.ptype = "Fighting"

      card.config.center.blueprint_compat = _r.blueprint_compat

      if _r.add_to_deck then _r:add_to_deck(card) end

      -- play the funny noises
      local edition = context and context.card and context.card.edition and not context.card.edition.negative and context.card.edition or card.edition
      if not edition then
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('poke_receiver_ex')})
      else
        local sound
        for _, v in pairs(G.P_CENTER_POOLS['Edition']) do
          if v.key == 'e_'..edition.type then
            sound = v.sound
            sound.pitch = edition.type == 'poke_shiny' and 1 or 2
          end
        end
        if not sound then sound = {sound = nil, per = nil, vol = nil, pitch = nil} end
        card:juice_up(1, 0.5)
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('poke_receiver_ex'), colour = G.C.DARK_EDITION,
          sound = sound.sound, per = sound.per, vol = sound.vol, pitch = sound.pitch})
        if context and context.card and context.card.edition then
          card.ability.extra.received_edition = true
          G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        end
      end
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    if card.ability.extra.received_edition and not from_debuff then
      G.jokers.config.card_limit = G.jokers.config.card_limit - 1
    end
    if card.ability.received_card and card.ability.received_card.remove_from_deck then
      card.ability.received_card:remove_from_deck(card)
    end
  end,
  calc_dollar_bonus = function(self, card)
    if card.ability.received_card and card.ability.received_card.calc_dollar_bonus then
      return card.ability.received_card:calc_dollar_bonus(card)
    end
  end,
  generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    type_tooltip(self, info_queue, card)
    local _c = card and card.config.center or card
    if card and card.ability and card.ability.received_card then
      local r_center = card.ability.received_card
      local r_config = copy_table(card.ability.received_card.config)
      -- get the local variables from received card's loc_vars function
      if type(r_center.loc_vars) == "function" then
        local other_queue = {}
        local other_vars = r_center:loc_vars(other_queue, card)
        if other_vars and other_vars.vars then
          r_config.loc_vars_replacement = other_vars.vars
        end
      end
      -- UI table should still have Passimian's name
      if not full_UI_table.name then
        full_UI_table.name = localize({ type = "name", set = _c.set, key = _c.key, nodes = full_UI_table.name })
      end
      -- Name formatting nonsense
      local r_name = localize({type = "name_text", set = r_center.set, key = r_center.key})
      if string.match(G.localization.descriptions.Joker[r_center.key].name, '{s:0.6}'..'%u%l+'..'{}') then -- {s:0.6}Hisuian{}Sneasel
        r_name = G.localization.descriptions.Joker[r_center.key].name
        r_name = string.gsub(r_name, '{}', ' '); r_name = string.sub(r_name, 8, -1) -- Hisuian Sneasel
      end
      -- These two don't have a loc_vars function and it's irritating
      if r_center.key == 'j_nacho_hisuian_zorua' or r_center.key == 'j_poke_zorua' then
        r_config.loc_vars_replacement = {card.ability.extra.rounds}
      end
      -- Finally getting around to generating descriptions and tooltips
      info_queue[#info_queue + 1] = {set = 'Other', key = 'received_card', vars = {r_name}}
      localize{type = 'descriptions', set = 'Joker', key = r_center.key, name = r_center.name, vars = r_config.loc_vars_replacement, nodes = desc_nodes}
      local new_queue = {}
      if r_center.generate_ui then r_center:generate_ui(new_queue, card, {}, specific_vars, full_UI_table) end
      -- Filter infoqueue for duplicate tooltips
      for i = 1, #new_queue do
        if new_queue[i].set == "Other" and new_queue[i].key and new_queue[i].key == 'energy' then
        else info_queue[#info_queue+1] = new_queue[i] end
      end
    else
      if not full_UI_table.name then
        full_UI_table.name = localize({ type = "name", set = _c.set, key = _c.key, nodes = full_UI_table.name })
      end
      localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes}
    end
  end,
  banlist = {'j_nacho_passimian'},
  load = function(self, card, card_table, other_card)
    if card_table.ability.received_card then
      card_table.ability.received_card = G.P_CENTERS[card_table.received_key]
    end
  end,
}

local init = function()
  remove = function(self, card, context, check_shiny, skip_joker_type_destroyed)
    if not skip_joker_type_destroyed then
      card.getting_sliced = true
      local flags = SMODS.calculate_context({ joker_type_destroyed = true, card = card })
      if flags.no_destroy then
        card.getting_sliced = nil
        return
      end
    end
    if check_shiny and card.edition and card.edition.poke_shiny then
      SMODS.change_booster_limit(-1)
    end
    play_sound('tarot1')
    card.T.r = -0.2
    card:juice_up(0.3, 0.4)
    card.states.drag.is = true
    card.children.center.pinch.x = true
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.3,
      blockable = false,
      func = function()
        G.jokers:remove_card(card)
        card:remove()
        card = nil
        return true
      end
    }))
    card.gone = true
    return true
  end

  local save_card = Card.save
  Card.save = function (self)
    local saved_table = save_card(self)
    if self.config.center_key == 'j_nacho_passimian' and self.area == G.jokers and self.ability.received_card then
      saved_table.received_key = self.ability.received_card.key
    end
    return saved_table
  end

  -- Passimian Find_Card Hook
  local find_card = SMODS.find_card
  function SMODS.find_card(key, count_debuffed)
    local results = find_card(key, count_debuffed)
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

  local poke_find_card_ref = poke_find_card
  function poke_find_card(key_or_function, use_highlighted)
    return poke_find_card_ref(function (joker)
        return joker.ability.received_card and (joker.ability.received_card == key_or_function
        or joker.ability.received_card.key == key_or_function) end, use_highlighted)
      or poke_find_card_ref(key_or_function, use_highlighted)
  end

  -- Passimian Energize Hook
  local energize_ref = energize
  energize = function(card, etype, evolving, silent, amount, center)
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
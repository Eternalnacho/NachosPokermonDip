PkmnDip.eff = {} -- Joker Effects

--#region [[ joker_as_card ]]

-- Assigns a scoring card to a joker
---@param card Card
---@param card_args table
PkmnDip.eff.joker_as_card = function(card, card_args)
  if not card_args then card_args = { area = G.play } end
  -- Stop the card from actually moving to an area
  PkmnDip.no_align = true
  -- Create a temporary card
  local temp_card = SMODS.add_card(card_args)
  temp_card.dip_scoring_for = card
  temp_card.states.visible = nil
  temp_card:set_base({
    value = card_args.rank,
    suit = card_args.suit
  })
  -- Set the scoring animation bit onto the target joker
  temp_card:set_role({ major = card, role_type = 'Glued', draw_major = card })
  temp_card.juice_up = function(self, ...) card:juice_up(...) end
  -- Remove the temporary card to save memory / screen real-estate
  PkmnDip.defer(function()
    temp_card:remove()
    PkmnDip.no_align = nil -- let cards align properly again lmao
  end, {trigger = 'immediate'})
end

-- Hook these two functions for joker_as_card to work properly
PkmnDip.Hook("before", CardArea, 'align_cards', function(self) if PkmnDip.no_align then return true end end)
PkmnDip.Hook("around", _G, 'card_eval_status_text', function(orig, card, eval_type, amt, percent, dir, extra, ...)
  if card.dip_scoring_for then
    if extra then extra.focus = card.dip_scoring_for
    else extra = { focus = card.dip_scoring_for } end
  end
  return orig(card, eval_type, amt, percent, dir, extra, ...)
end)

--#endregion [[ joker_as_card ]]


--#region [[ copy_playing_card ]]

---@param card Card
---@param modify table?
---@param to_hand boolean?
---@param message_card Card?
PkmnDip.eff.copy_playing_card = function(card, modify, to_hand, message_card)
  PkmnDip.defer(function()
    local copy = SMODS.copy_card(card, {area = G.deck})
    if modify then pokermon.convert_cards(copy, modify, true, true) end
    if to_hand then draw_card(G.deck, G.hand, nil, nil, nil, copy) end
    SMODS.calculate_context({playing_card_added = true, cards = {copy}})
  end)
  SMODS.calculate_effect({message = localize('k_copied_ex')}, message_card or card)
end

--#endregion [[ copy_playing_card ]]


--#region [[ faint ]]

-- Shorthand for the debuff/undebuff thing
---@param card Card
---@param undebuff boolean?
PkmnDip.eff.faint = function(card, undebuff)
  PkmnDip.defer(function()
    card:juice_up()
    card.ability.fainted = not undebuff and G.GAME.round
    card:set_debuff()
  end)
end

--#endregion [[ faint ]]


--#region [[ mod_booster ]]

---@param amount integer
PkmnDip.eff.mod_booster = function(amount)
  local choice_mod = G.GAME.modifiers.booster_choice_mod
  choice_mod = math.max(0, (choice_mod or 0) + amount)
  G.GAME.pack_choices = G.GAME.pack_choices + amount
  if G.GAME.pack_choices <= 0 then G.FUNCS.end_consumeable() end
end

--#endregion [[ mod_booster ]]


--#region [[ shuffle_cards ]]

---@param area CardArea
---@param seed string
---@param context table
PkmnDip.eff.switch_cards = function(area, seed, context)
  if not area then area = G.play end
  local t = pokermon.pseudorandom_multi({ array = area.cards, amt = 2, seed = seed })
  t = PkmnDip.utils.map_list(t, function(card) return card.rank end)
  area.cards[t[1]], area.cards[t[2]] = area.cards[t[2]], area.cards[t[1]]
  area:set_ranks()
  table.sort(context.scoring_hand, function(a, b)
    return get_index(area.cards, a) < get_index(area.cards, b)
  end)
end

---@param area CardArea
---@param seed string
---@param context table
---@param amount integer?
PkmnDip.eff.shuffle_cards = function(area, seed, context, amount)
  if not area then area = G.play end
  if not amount then area.cards:shuffle(seed)
  else
    local base, pos = {}, {}
    local targets = pokermon.pseudorandom_multi({ array = area.cards, amt = amount, seed = seed })
    PkmnDip.utils.for_each(targets, function(t)
      base[#base+1] = t.rank
      pos[#pos+1] = t.rank
      t = area.cards[t.rank]
    end)
    while PkmnDip.utils.compare(base, pos) do
      pseudoshuffle(targets, seed)
      for i, t in ipairs(targets) do pos[i] = t.rank end
    end
    for i = 1, #pos do area.cards[base[i]] = targets[i] end
    area:set_ranks()
  end
  table.sort(context.scoring_hand, function(a, b)
    return get_index(area.cards, a) < get_index(area.cards, b)
  end)
end

--#endregion [[ shuffle_cards ]]


--#region [[ create_joker ]]

---@param args table
---@param pre_call function
---@param post_call function
PkmnDip.eff.create_joker = function(args, pre_call, post_call)
  if type(args) == 'string' then args = { key = args } end
  if not args.set then args.set = "Joker" end
  if (#G.jokers.cards + G.GAME.joker_buffer) <= G.jokers.config.card_limit or args.edition == 'e_negative' then
    G.GAME.joker_buffer = G.GAME.joker_buffer + 1
    PkmnDip.defer(function()
      G.GAME.joker_buffer = 0
      if pre_call then pre_call(args) end
      local card = SMODS.add_card(args)
      if post_call then post_call(card) end
    end, 0.4)
  end
end

---@param card Card
---@param adj SMODS.Joker[]
---@param pre_call function
---@param post_call function
PkmnDip.eff.breed = function(card, adj, pre_call, post_call)
  if PkmnDip.utils.all(adj, PkmnDip.calc.daycare_compatible) then
    local parent = pseudorandom_element(adj, pseudoseed("daycare"))
    local lowest = pokermon.get_lowest_evo(parent)
    if lowest and type(lowest) == "string" then
      PkmnDip.eff.create_joker({key = 'j_poke_mystery_egg'}, pre_call, function(egg)
        egg.ability.extra.key = PkmnDip.calc.get_key(parent, lowest)
        if post_call then post_call(egg) end
      end)
    end
  end
end

--#endregion [[ create_joker ]]
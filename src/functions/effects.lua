PkmnDip.eff = {}

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


--#region [[ copy_playing_card ]]

PkmnDip.copy_playing_card = function(card, modify, to_hand)
  PkmnDip.defer(function()
    local copy = SMODS.copy_card(card, {area = G.deck})
    if modify then pokermon.convert_cards(copy, modify, true, true) end
    if to_hand then draw_card(G.deck, G.hand, nil, nil, nil, copy) end
    SMODS.calculate_context({playing_card_added = true, cards = {copy}})
  end)
end

--#endregion [[ end copy_playing_card ]]



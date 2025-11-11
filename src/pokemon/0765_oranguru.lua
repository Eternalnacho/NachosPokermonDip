-- Oranguru 765
local oranguru={
  name = "oranguru",
  config = {extra = {raised = false}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    common_ranks_tooltip(self, info_queue)
    return {vars = {}}
  end,
  designer = "Eternalnacho",
  rarity = 3,
  cost = 8,
  stage = "Basic",
  ptype = "Colorless",
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.open_booster and not context.blueprint then
      if context.card.ability.name:find('Standard') then
        -- set booster_choice_mod if not raised
        if not card.ability.extra.raised then
          if G.GAME.modifiers.booster_choice_mod then G.GAME.modifiers.booster_choice_mod = G.GAME.modifiers.booster_choice_mod + 1
          else G.GAME.modifiers.booster_choice_mod = 1 end
          -- set booster choices
          G.GAME.pack_choices =
            math.min((context.card.ability.choose or context.card.config.center.config.choose or 1) + (G.GAME.modifiers.booster_choice_mod or 0),
            context.card.ability.extra and math.max(1, context.card.ability.extra + (G.GAME.modifiers.booster_size_mod or 0)) or
            context.card.config.center.extra and math.max(1, context.card.config.center.extra + (G.GAME.modifiers.booster_size_mod or 0)) or 1)
          -- set raised to true
          card.ability.extra.raised = true
        end
      elseif card.ability.extra.raised then
        -- lower booster_choice_mod if raised, else do nothing
        if G.GAME.modifiers.booster_choice_mod then G.GAME.modifiers.booster_choice_mod = G.GAME.modifiers.booster_choice_mod - 1
        else G.GAME.modifiers.booster_choice_mod = 0 end
        G.GAME.pack_choices =
            math.min((context.card.ability.choose or context.card.config.center.config.choose or 1) + (G.GAME.modifiers.booster_choice_mod or 0),
            context.card.ability.extra and math.max(1, context.card.ability.extra + (G.GAME.modifiers.booster_size_mod or 0)) or
            context.card.config.center.extra and math.max(1, context.card.config.center.extra + (G.GAME.modifiers.booster_size_mod or 0)) or 1)
        card.ability.extra.raised = false
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.ability.name:find('Standard') or G.STATE == G.STATES.STANDARD_PACK) then
      if not card.ability.extra.raised then
        if G.GAME.modifiers.booster_choice_mod then
          G.GAME.modifiers.booster_choice_mod = G.GAME.modifiers.booster_choice_mod + 1
        else
          G.GAME.modifiers.booster_choice_mod = 1
        end
        G.GAME.pack_choices =
            math.min((context.card.ability.choose or context.card.config.center.config.choose or 1) + (G.GAME.modifiers.booster_choice_mod or 0),
            context.card.ability.extra and math.max(1, context.card.ability.extra + (G.GAME.modifiers.booster_size_mod or 0)) or
            context.card.config.center.extra and math.max(1, context.card.config.center.extra + (G.GAME.modifiers.booster_size_mod or 0)) or 1)
        card.ability.extra.raised = true
      end
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    if card.ability.extra.raised then
      if G.GAME.modifiers.booster_choice_mod then
        G.GAME.modifiers.booster_choice_mod = G.GAME.modifiers.booster_choice_mod - 1
      else
        G.GAME.modifiers.booster_choice_mod = 0
      end
      if (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.ability.name:find('Standard') or G.STATE == G.STATES.STANDARD_PACK) then
        G.GAME.pack_choices =
            math.min((context.card.ability.choose or context.card.config.center.config.choose or 1) + (G.GAME.modifiers.booster_choice_mod or 0),
            context.card.ability.extra and math.max(1, context.card.ability.extra + (G.GAME.modifiers.booster_size_mod or 0)) or
            context.card.config.center.extra and math.max(1, context.card.config.center.extra + (G.GAME.modifiers.booster_size_mod or 0)) or 1)
      end
      card.ability.extra.raised = false
    end
  end,
}

local init = function()
  -- Booster Functionality for Oranguru (and maybe smth else...)
  SMODS.Booster:take_ownership_by_kind('Standard', {
          create_card = function(self, card)
              local _card
              local _edition = poll_edition('standard_edition'..G.GAME.round_resets.ante, 2, true)
              local _seal = SMODS.poll_seal({ mod = 10 })
              local _rank
              local _suit

              if next(SMODS.find_card('j_nacho_oranguru')) then
                local _ranks, _tally = {}, 0
                -- Get most common rank(s)
                for x, y in pairs(SMODS.Ranks) do
                  local count = 0
                  for k, v in pairs(G.playing_cards) do
                    if v:get_id() == y.id and not SMODS.has_no_rank(v) then count = count + 1 end
                  end
                  if count > _tally then
                    if #_ranks > 0 then for i = 1, #_ranks do table.remove(_ranks) end end
                    table.insert(_ranks, y.card_key)
                    _tally = count
                  elseif count == _tally then
                    table.insert(_ranks, y.card_key)
                  end
                end
                _rank = pseudorandom_element(_ranks, pseudoseed("staranks"..G.GAME.round_resets.ante))
              end

              if _rank or _suit then
                if not _rank then _rank = pseudorandom_element(SMODS.Ranks, pseudoseed("staranks"..G.GAME.round_resets.ante)).card_key end
                if not _suit then _suit = pseudorandom_element(SMODS.Suits, pseudoseed("stasuits"..G.GAME.round_resets.ante)).card_key end
                _card = {
                  set = (pseudorandom(pseudoseed('stdset'..G.GAME.round_resets.ante)) > 0.6) and "Enhanced" or "Base",
                  front = _suit.."_".._rank,
                  edition = _edition,
                  seal = _seal,
                  area = G.pack_cards,
                  skip_materialize = true,
                  soulable = true,
                }
              else
                local _edition = poll_edition('standard_edition' .. G.GAME.round_resets.ante, 2, true)
                local _seal = SMODS.poll_seal({ mod = 10 })
                _card = {
                  set = (pseudorandom(pseudoseed('stdset'..G.GAME.round_resets.ante)) > 0.6) and "Enhanced" or "Base",
                  edition = _edition,
                  seal = _seal,
                  area = G.pack_cards,
                  skip_materialize = true,
                  soulable = true,
                  key_append = "sta"
                }
              end
              return _card
          end,
          loc_vars = function(self, info_queue, card)
              local cfg = (card and card.ability) or self.config
              return {
                  vars = { cfg.choose, cfg.extra },
                  key = self.key:sub(1, -3), -- This uses the description key of the booster without the number at the end
              }
          end,
      },
      true
  )
end

return {
  name = "Nacho's Oranguru",
  enabled = nacho_config.oranguru or false,
  init = init,
  list = { oranguru }
}

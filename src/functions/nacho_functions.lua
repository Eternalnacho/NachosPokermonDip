function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

-- Deck Rank Evo conditions
deck_rank_evo = function(self, card, context, forced_key, rank, percentage, flat)
  if can_evolve(self, card, context, forced_key) then
    local high_count = 0
    for k, v in pairs(G.playing_cards) do
      if v.base.nominal >= rank then high_count = high_count + 1 end
    end
    if percentage and (high_count/#G.playing_cards >= percentage) then
      return {
        message = poke_evolve(card, forced_key)
      }
    elseif flat and (_count >= flat) then
      return {
        message = poke_evolve(card, forced_key)
      }
    end
  end
end


-- POKEMON SPECIFIC FUNCTIONS/OVERRIDES --

-- mega gallade card debuffing/un-debuffing function
local parse_highlighted = CardArea.parse_highlighted
CardArea.parse_highlighted = function(self)
  for _, card in ipairs(self.highlighted) do
    if card.debuff then card:set_debuff(false) end
  end
  local text, _, _ = G.FUNCS.get_poker_hand_info(self.highlighted)
  for _, card in ipairs(self.cards) do
    SMODS.recalc_debuff(card)
  end
  if text == calc_most_played_hand() and next(SMODS.find_card('j_nacho_mega_gallade')) then
    for _, card in ipairs(self.highlighted) do
      if card.debuff then card:set_debuff(false) end
    end
  end
  parse_highlighted(self)
end

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


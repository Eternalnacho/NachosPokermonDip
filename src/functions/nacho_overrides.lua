-- TAKING OWNERSHIP / OVERRIDES FOR MULTIPLE JOKERS

-- Booster Functionality for Oranguru (and maybe smth else...)
SMODS.Booster:take_ownership_by_kind('Standard',
{
  create_card = function(self, card)
      local _card, _rank, _suit
      local _edition = poll_edition('standard_edition'..G.GAME.round_resets.ante, 2, true)
      local _seal = SMODS.poll_seal({ mod = 10 })

      if next(SMODS.find_card('j_nacho_oranguru')) then
        local _ranks = get_common_ranks(G.playing_cards)
        _rank = pseudorandom_element(_ranks, pseudoseed("staranks"..G.GAME.round_resets.ante)).card_key
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
}, true)
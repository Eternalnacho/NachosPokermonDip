-- Deck Rank Evo conditions
deck_rank_evo = function(self, card, context, forced_key, rank, percentage, flat)
  if can_evolve(self, card, context, forced_key) then
    local count = 0
    for k, v in pairs(G.playing_cards) do
      if v.base.nominal >= rank then count = count + 1 end
    end
    if percentage and (count/#G.playing_cards >= percentage) then
      return {
        message = poke_evolve(card, forced_key)
      }
    elseif flat and (count >= flat) then
      return {
        message = poke_evolve(card, forced_key)
      }
    end
  end
end

-- Edition Evo conditions
edition_evo = function(self, card, context, forced_key, edition, percentage, flat)
  if can_evolve(self, card, context, forced_key) then
    local count = 0
    for k, v in pairs(G.playing_cards) do
      if v.edition and v.edition[edition] then count = count + 1 end
    end
    if percentage and (count/#G.playing_cards >= percentage) then
      return {
        message = poke_evolve(card, forced_key)
      }
    elseif flat and (count >= flat) then
      return {
        message = poke_evolve(card, forced_key)
      }
    end
  end
end

-- Get card's total mult (parallels poke_total_chips)
poke_total_mult = function(card)
  local total_mult = (card.ability.mult) + (card.ability.perma_mult or 0)
  if card.edition then
    total_mult = total_mult + (card.edition.mult or 0)
  end
  return total_mult
end

-- poke_family_present hook
local poke_family_present_ref = poke_family_present
poke_family_present = function(center)
  if next(find_joker("Showman")) or next(find_joker("pokedex")) then return false end
  local family_list = poke_get_family_list(center.name)
  local prefix = center.poke_custom_prefix
  local ret = poke_family_present_ref(center)

  if prefix then for _, fam in pairs(family_list) do
      if G.GAME.used_jokers["j_"..prefix.."_"..((type(fam) == "table" and fam.key) or fam)] then
        ret = true
      end
    end
  end
  
  return ret
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

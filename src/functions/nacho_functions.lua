---@diagnostic disable: param-type-mismatch
-- Describe all the logic for debuffing or undebuffing
-- return values: true, false, or 'prevent_debuff'
SMODS.current_mod.set_debuff = function(card)
  -- prevent debuffs
  if card.ability.name == "mega_gallade" then return 'prevent_debuff' end
  if card:get_id() == 9 and next(SMODS.find_card("j_poke_mega_altaria")) then return 'prevent_debuff' end
  return false
end

SMODS.current_mod.calculate = function(self, context)
  if G.GAME.modifiers.sinnoh_adv and context.starting_shop then
    for _, starter in ipairs { 'turtwig', 'chimchar', 'piplup' } do
      local shop_card = SMODS.create_card({set = 'Joker', key = 'j_nacho_'..starter, area = G.shop_jokers})
      G.shop_jokers:emplace(shop_card)
      create_shop_card_ui(shop_card)
    end
    G.GAME.modifiers.sinnoh_adv = nil
  end
end

-- Deck Rank Evo conditions
pokermon.deck_rank_evo = function(self, card, context, forced_key, rank, percentage, flat)
  if pokermon.can_evolve(self, card, context, forced_key) then
    local count = #PkmnDip.utils.filter(G.playing_cards, function(v) return v.base.nominal >= rank end)
    if percentage and (count/#G.playing_cards >= percentage) then
      return { message = pokermon.evolve(card, forced_key) }
    elseif flat and (count >= flat) then
      return { message = pokermon.evolve(card, forced_key) }
    end
  end
end

-- Edition Evo conditions
pokermon.edition_evo = function(self, card, context, forced_key, edition, percentage, flat)
  if pokermon.can_evolve(self, card, context, forced_key) then
    local count = #PkmnDip.utils.filter(G.playing_cards, PkmnDip.con['is_'..edition])
    if percentage and (count/#G.playing_cards >= percentage) then
      return { message = pokermon.evolve(card, forced_key) }
    elseif flat and (count >= flat) then
      return { message = pokermon.evolve(card, forced_key) }
    end
  end
end

-- Create tooltip for common ranks (Oranguru)
PkmnDip.common_ranks_tooltip = function()
  if not G.playing_cards and G.STAGE == G.STAGES.RUN then return end
  local ranks = {}
  local r = PkmnDip.calc.get_common_ranks(G.playing_cards)
  -- sort in descending order if multiple
  if #r > 1 then table.sort(r, function(a, b) return a.id > b.id end) end
  -- get card key for each rank because it's a single character
  for i = 1, #r do
    ranks[i] = #r > 3 and r[i].card_key or r[i].key
    if ranks[i] == 'T' then ranks[i] = '10' end
  end
  -- Organize into even lists (max 3)
  local rank_lists = {}
  local rows = math.min(3, math.ceil(#ranks / 4))
  if rows == 1 then
    rank_lists[1] = table.concat(ranks, ", ")
  else
    local mod = math.ceil(#ranks / rows)
    for i = 1, rows do
      rank_lists[i] = table.concat(ranks, ", ", 1 + (i - 1) * mod, math.min(#ranks, i * mod))
    end
  end
  local text = PkmnDip.utils.map_list(rank_lists, function(l) return '{C:attention}'..l..'{}' end)
  local text_parsed = PkmnDip.utils.map_list(text, loc_parse_string)
  G.localization.descriptions.Other['pkmndip_rank_lists'].text = text
  G.localization.descriptions.Other['pkmndip_rank_lists'].text_parsed = text_parsed
  return {
    set = 'Other',
    key = 'pkmndip_rank_lists'
  }
end

PkmnDip.keep_values = function(card)
  local names_to_keep = {"targets", "rank", "id", "cards_scored", "cards_drawn", "energy_count", "c_energy_count", "e_limit_up", "form"}
  if pokermon.type_sticker_applied(card) then
    table.insert(names_to_keep, "ptype")
  end
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

PkmnDip.get_kept_values = function(card, kept_vals)
  for k, v in pairs(kept_vals) do
    card.ability[k] = type(v) == 'table' and copy_table(v) or v
    if type(card.ability.extra) == "table" and (card.ability.extra[k] or k == "energy_count" or k == "c_energy_count" or k == "e_limit_up")
        and (type(card.ability.extra[k]) ~= "number" or (type(v) == "number" and v > card.ability.extra[k])) then
      card.ability.extra[k] = v
    end
  end
end

PkmnDip.get_lowest_hand_level = function()
  local lowest_level
  for _, v in pairs(G.GAME.hands) do
    local hand_level = (SMODS.Mods["Talisman"] or {}).can_load and (to_number(v.level)) or (v.level)
    if lowest_level then
      lowest_level = hand_level < lowest_level and hand_level or lowest_level
    else
      lowest_level = hand_level
    end
  end
  return lowest_level
end

function Card:poke_get_prefix()
  return self.config.center.poke_custom_prefix or 'poke'
end

PkmnDip.create_full_poke_key = function(card, name)
  return 'j_'..card:poke_get_prefix().."_"..(name or card.config.center.name)
end

PkmnDip.attach_mega = function(center, target)
  SMODS.Joker:take_ownership(target, {
    megas = PkmnDip.config[center.name] and { center.name } or nil,
    discovered = true,
  }, true)
  pokermon.add_to_family(target:sub(6, -1), center.name)
end
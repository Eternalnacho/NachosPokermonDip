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

PkmnDip.attach_mega = function(center, target)
  SMODS.Joker:take_ownership(target, {
    megas = PkmnDip.config[center.name] and { center.name } or nil,
    discovered = true,
  }, true)
  pokermon.add_to_family(target:sub(6, -1), center.name)
end
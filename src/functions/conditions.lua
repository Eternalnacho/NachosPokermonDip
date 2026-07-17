PkmnDip.con = {}

PkmnDip.con.has_repeat_effect = function(context)
  return context.repetition and (next(context.card_effects[1]) or #context.card_effects > 1)
end

PkmnDip.con.played_or_held = function(context)
  return (context.cardarea == G.hand or G.play)
end

-- There's an argument to be made that these aren't actually helpful
-- But we're doing it anyway
for _, enh in pairs { 'glass', 'steel', 'wild', 'gold', 'lucky' } do
  PkmnDip.con['is_'..enh] = function(card)
    return SMODS.has_enhancement(card, 'm_'..enh)
  end
end

for _, edi in pairs { 'foil', 'holo', 'polychrome' } do
  PkmnDip.con['is_'..edi] = function(card)
    return card.edition and card.edition[edi]
  end
end

PkmnDip.con.in_booster = function(name)
  return G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.ability.name:find(name)
end
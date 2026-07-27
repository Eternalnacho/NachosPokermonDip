--#region [[ zorua ]]

SMODS.Shader({ key = 'hisuian_zorua', path = 'hisuian_zorua.fs' })

SMODS.DrawStep({
  key = 'hisuian_zorua_shadow',
  order = 69,
  func = function(card, layer)
    if card.debuff or pokermon.is_in_collection(card) or card.is_display_card or not card.ability then return end
    if not ((card.config.center.key == 'j_nacho_hisuian_zorua' and card.ability.extra.active) or card.config.center.key == 'j_nacho_hisuian_zoroark') then return end
    if card.area and card.area == G.jokers then
      local other_joker = G.jokers.cards[1]
      if other_joker == card or not other_joker.config.center.blueprint_compat then return end
    end

    local center = card.ability.received_card or card.config.center
    local dip_shared_key = 'shared_' .. card.ability.name

    G[dip_shared_key] = G[dip_shared_key] or SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H, center.atlas, center.pos)
    G[dip_shared_key].role.draw_major = card
    G[dip_shared_key]:draw_shader('nacho_hisuian_zorua', nil, card.ARGS.send_to_shader, nil, card.children.center)
  end,
  conditions = { vortex = false, facing = 'front' },
})


--#endregion [[ zorua ]]


--#region [[ localization ]]

-- Create tooltip for common ranks (Oranguru)
PkmnDip.calc.common_ranks_tooltip = function()
  if not (G.playing_cards and G.STAGE == G.STAGES.RUN) then return end
  local ranks = PkmnDip.calc.get_common_ranks()
  if #ranks > 1 then
    table.sort(ranks, function(a, b) return a.id > b.id end)
  end
  ranks = PkmnDip.utils.map_list(ranks, function(r)
    return #ranks > 3 and r.shorthand or r.key
  end)
  -- Organize into even lists (max 3)
  local rows = math.min(3, math.ceil(#ranks / 4))
  local rank_lists = {}
  local start_index = function(x) return 1 + (x - 1) * math.ceil(#ranks / rows) end
  local end_index = function(x) return x * math.ceil(#ranks / rows) end
  for i = 1, rows do
    rank_lists[i] = table.concat(ranks, ", ", 
      rows > 1 and start_index(i) or nil,
      rows > 1 and math.min(#ranks, end_index(i)) or nil
    )
  end
  -- Map lists to localization text and update entry
  local text = PkmnDip.utils.map_list(rank_lists, function(l) return '{C:attention}'..l..'{}' end)
  local text_parsed = PkmnDip.utils.map_list(text, loc_parse_string)
  G.localization.descriptions.Other['pkmndip_rank_lists'].text = text
  G.localization.descriptions.Other['pkmndip_rank_lists'].text_parsed = text_parsed
  return { set = 'Other', key = 'pkmndip_rank_lists' }
end

--#endregion [[ localization ]]


--#region [[ stellar colours ]]

-- Rainbow Gradients for Stellar Type
local stellar_colours = {HEX('cb4c44'), HEX('cc7b00'), HEX('c4af36'), HEX('43b645'), HEX('2ea4b6'), HEX('515fea'), HEX('9849d3'), HEX('cf3aa6')}
for i = 1, #stellar_colours do
  local index_cols = {}
  for j = 1, #stellar_colours do table.insert(index_cols, stellar_colours[(i + j) % #stellar_colours]) end
  SMODS.Gradient{
    key = 'sg'..i,
    colours = index_cols,
    cycle = 5
  }
end
SMODS.Gradient{
   key = 'stellar',
   colours = {G.C.RED, G.C.FILTER, HEX('f5db43'), HEX('54e456'), HEX('39cde4'), HEX('515fea'), HEX('a951ea'), HEX('e640b8')},
   cycle = 5,
}
pokermon.colours['stellar'] = SMODS.Gradients['nacho_stellar']

--#endregion [[ stellar colours ]]
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
  if not next(ranks) then return end
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

PkmnDip.revised_fossil_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
  SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
  full_UI_table.main.poke_custom_desc = true
  full_UI_table.main.poke_box_minh = 0.2
  full_UI_table.main.align = "bm"
  full_UI_table.box_colours[1] = G.C.CLEAR
  local is_ability = function(v) return v[2] and v[2].config.text and string.find(v[2].config.text, ":") end
  for _, box in ipairs(full_UI_table.multi_box) do
    for _, node in ipairs(box) do
      box.poke_custom_desc = true
      if is_ability(node) then
        box.align = "cl"
        box.padding = 0.1
        box.poke_box_minh = 0.5
      else
        box.poke_box_minh = 0.5
      end
    end
  end
end

PkmnDip.revised_fossil_ui_but_boring = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
  SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
  desc_nodes.poke_custom_desc = true
  desc_nodes.padding = 0.04
  desc_nodes.align = "cm"
  local is_ability = function(v) return v and v[2] and v[2].config.text and string.find(v[2].config.text, ":") end
  for i, node in ipairs(desc_nodes) do
    if i > 1 then
      node.align = "cl"
    else
      node.align = "cm"
    end
    if is_ability(desc_nodes[i+1]) and (node[1] and node[1].config.text or node[2] and node[2].config.text) then
      table.insert(desc_nodes, i + 1, {{n = G.UIT.R, config = {minh = 0.1, colour = G.C.CLEAR}, is_spacer = true}})
    end
  end
end

PkmnDip.Hook("around", _G, 'desc_from_rows', function(orig, desc_nodes, empty, maxw)
  local ret
  if desc_nodes.poke_custom_desc then
    ret = {}
    local t = {}
    for _, v in ipairs(desc_nodes) do
      t[#t + 1] = { n = G.UIT.R, config = { align = v.align or desc_nodes.align or "cm", maxw = maxw }, nodes = v }
    end
    ret = {
      n = G.UIT.R,
      config = {
        align = desc_nodes.align or "cm",
        colour = desc_nodes.background_colour or empty and G.C.CLEAR or G.C.UI.BACKGROUND_WHITE,
        r = 0.1,
        padding = desc_nodes.padding or -0.03,
        minw = desc_nodes.poke_box_minw or 2,
        minh = desc_nodes.poke_box_minh or 0.8,
        emboss = not empty and 0.05 or nil,
        filler = true,
        main_box_flag = desc_nodes.main_box_flag and true or nil
      },
      nodes = {
        {
          n = G.UIT.R,
          config = {
            align = desc_nodes.align or "cm",
            padding = 0.04,
          },
          nodes = t
        }
      }
    }
  else
    ret = orig(desc_nodes, empty, maxw)
  end
  return ret
end)

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
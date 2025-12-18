SMODS.Shader({ key = 'hisuian_zorua', path = 'hisuian_zorua.fs' }):register()

SMODS.DrawStep({
   key = 'hisuian_zorua_shadow',
   order = 69,
   func = function(card, layer)
      if not card or not card.ability or not card.children.center or (card.ability.name ~= 'hisuian_zorua' and card.ability.name ~= 'hisuian_zoroark') then return end
      if card.debuff or (card.ability.name == 'hisuian_zorua' and not card.ability.extra.active) or poke_is_in_collection(card) then return end
      if G.jokers and card.area == G.jokers then
         local other_joker = G.jokers.cards[1]
         if other_joker == card or other_joker.debuff or not other_joker.config.center.blueprint_compat then return end
      end
      local center = card.config.center
      local prev_atlas = card.children.center.atlas
      local prev_pos = card.children.center.sprite_pos
      local new_atlas = (card.edition and card.edition.poke_shiny) and "poke_AtlasJokersBasicGen05Shiny" or "poke_AtlasJokersBasicGen05"

      if card.ability.received_card then
        new_atlas = (card.edition and card.edition.poke_shiny) and "poke_AtlasJokersBasicNatdexShiny" or "poke_AtlasJokersBasicNatdex"
      end

      card.children.center.atlas = G.ASSET_ATLAS[new_atlas]
      card.children.center:set_sprite_pos(center.pos)

      card.children.center:draw_shader('nacho_hisuian_zorua', nil, card.ARGS.send_to_shader)

      card.children.center.atlas = prev_atlas
      card.children.center:set_sprite_pos(prev_pos)
   end,
   conditions = { vortex = false, facing = 'front' },
})


-- Rainbow Gradient for Stellar Type

SMODS.Gradient{
   key = 'sgbadge',
   colours = {G.C.RED, G.C.FILTER, HEX('f5db43'), HEX('54e456'), HEX('39cde4'), HEX('515fea'), HEX('a951ea'), HEX('e640b8')},
   cycle = 5,
}
SMODS.Gradient{
   key = 'sg1',
   colours = {HEX('cb4c44'), HEX('cc7b00'), HEX('c4af36'), HEX('43b645'), HEX('2ea4b6'), HEX('515fea'), HEX('9849d3'), HEX('cf3aa6')},
   cycle = 5,
}
SMODS.Gradient{
   key = 'sg2',
   colours = {HEX('cc7b00'), HEX('c4af36'), HEX('43b645'), HEX('2ea4b6'), HEX('515fea'), HEX('9849d3'), HEX('cf3aa6'), HEX('cb4c44')},
   cycle = 5,
}
SMODS.Gradient{
   key = 'sg3',
   colours = {HEX('c4af36'), HEX('43b645'), HEX('2ea4b6'), HEX('515fea'), HEX('9849d3'), HEX('cf3aa6'), HEX('cb4c44'), HEX('cc7b00')},
   cycle = 5,
}
SMODS.Gradient{
   key = 'sg4',
   colours = {HEX('43b645'), HEX('2ea4b6'), HEX('515fea'), HEX('9849d3'), HEX('cf3aa6'), HEX('cb4c44'), HEX('cc7b00'), HEX('c4af36')},
   cycle = 5,
}
SMODS.Gradient{
   key = 'sg5',
   colours = {HEX('2ea4b6'), HEX('515fea'), HEX('9849d3'), HEX('cf3aa6'), HEX('cb4c44'), HEX('cc7b00'), HEX('c4af36'), HEX('43b645')},
   cycle = 5,
}
SMODS.Gradient{
   key = 'sg6',
   colours = {HEX('515fea'), HEX('9849d3'), HEX('cf3aa6'), HEX('cb4c44'), HEX('cc7b00'), HEX('c4af36'), HEX('43b645'), HEX('2ea4b6')},
   cycle = 5,
}
SMODS.Gradient{
   key = 'sg7',
   colours = {HEX('9849d3'), HEX('cf3aa6'), HEX('cb4c44'), HEX('cc7b00'), HEX('c4af36'), HEX('43b645'), HEX('2ea4b6'), HEX('515fea')},
   cycle = 5,
}
SMODS.Gradient{
   key = 'sg8',
   colours = {HEX('cf3aa6'), HEX('cb4c44'), HEX('cc7b00'), HEX('c4af36'), HEX('43b645'), HEX('2ea4b6'), HEX('515fea'), HEX('9849d3')},
   cycle = 5,
}
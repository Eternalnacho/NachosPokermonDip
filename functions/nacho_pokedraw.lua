SMODS.Shader({ key = 'zorua', path = 'zorua.fs' }):register()

SMODS.DrawStep({
   key = 'zorua_shadow',
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
      local new_atlas = (card.edition and card.edition.poke_shiny) and 'poke_Regionals' or 'poke_ShinyRegionals'

      card.children.center.atlas = G.ASSET_ATLAS[new_atlas]
      card.children.center:set_sprite_pos(center.pos)

      card.children.center:draw_shader('poke_zorua', nil, card.ARGS.send_to_shader)

      card.children.center.atlas = prev_atlas
      card.children.center:set_sprite_pos(prev_pos)
   end,
   conditions = { vortex = false, facing = 'front' },
})
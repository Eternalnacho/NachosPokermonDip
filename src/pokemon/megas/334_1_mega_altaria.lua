-- Mega Altaria 334-1
local mega_altaria = {
  name = "mega_altaria",
  nacho_inject_prefix = "poke",
  pos = { x = 2, y = 6 },
  soul_pos = { x = 3, y = 6 },
  config = { extra = {chips = 0, chips_mod = 0, money_mod = 2} },
  loc_txt = {
    name = "Mega Altaria",
    text = {
      "{C:chips}+#1#{} Chips,",
      "{C:attention}9s can't{} be debuffed",
      "{br:2.5}ERROR - CONTACT STEAK",
      "{C:attention}9s{} drawn during the",
      "{C:attention}Blind{} become {C:dark_edition}Polychrome{}",
      "and earn {C:money}$#2#{}",
    }
  },
  loc_vars = function(self, info_queue, center)
    pokermon.type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      if not center.edition or (center.edition and not center.edition.polychrome) then
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
      end
    end
    return {vars = {center.ability.extra.chips, center.ability.extra.money_mod}}
  end,
  rarity = "poke_mega",
  cost = 12,
  gen = 3,
  stage = "Mega",
  ptype = "Fairy",
  blueprint_compat = true,
  perishable_compat = false,
  calculate = function(self, card, context)
    -- Drawing 9s converts them to polychrome and earns $2
    if context.hand_drawn and SMODS.drawn_cards then
      PkmnDip.utils.for_each(SMODS.drawn_cards, function(pcard)
        if pcard:get_id() == 9 then
          -- Make drawn 9s polychrome
          PkmnDip.defer(function() pcard:set_edition('e_polychrome', true) end, 0.4)
          -- Earn $2 per drawn 9
          local earned = pokermon.ease_poke_dollars(card, "mega_altaria", card.ability.extra.money_mod)
          G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + earned
          PkmnDip.defer(function() G.GAME.dollar_buffer = 0 end)
        end
      end)
    end

    -- Chips in main scoring
    if context.joker_main then return { chips = card.ability.extra.chips } end
  end,
}

local function init()
  SMODS.Joker:take_ownership('poke_altaria', { megas = { 'mega_altaria' } }, true)
  pokermon.add_to_family("altaria", "mega_altaria")
end

return {
  can_load = nacho_config.other_megas,
  init = init,
  list = { mega_altaria }
}
-- Mega Altaria 334-1
local mega_altaria = {
  name = "mega_altaria",
  nacho_inject_prefix = "poke",
  pos = { x = 2, y = 6 },
  soul_pos = { x = 3, y = 6 },
  config = { extra = {chips = 0, threshold = 3, drawn = 0, money_mod = 2} },
  loc_txt = {
    name = "Mega Altaria",
    text = {
      "{C:chips}+#1#{} Chips,",
      "{C:attention}9s can't{} be debuffed",
      "{br:2.5}ERROR - CONTACT STEAK",
      "Every third {C:inactive}#2#{C:attention}9{}",
      "drawn during the {C:attention}Blind{}",
      "becomes {C:dark_edition}Polychrome{}",
      "{br:2.5}ERROR - CONTACT STEAK",
      "{C:attention}Editioned{} cards drawn",
      "during the {C:attention}Blind{} earn {C:money}$#3#{}",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      if not center.edition or (center.edition and not center.edition.polychrome) then
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
      end
    end
    local draw_count = G.playing_cards and G.STAGE == G.STAGES.RUN and '['..center.ability.extra.drawn..'/'..center.ability.extra.threshold..'] ' or ''
    return {vars = {center.ability.extra.chips, draw_count, center.ability.extra.money_mod}}
  end,
  rarity = "poke_mega",
  cost = 12,
  gen = 3,
  stage = "Mega",
  ptype = "Dragon",
  perishable_compat = true,
  blueprint_compat = false,
  eternal_compat = true,
  calculate = function(self, card, context)
    -- Convert every third 9 drawn to polychrome
    if context.hand_drawn and SMODS.drawn_cards and not context.blueprint then
      PkmnDip.utils.for_each(SMODS.drawn_cards, function(pcard)
        if pcard.edition then
          local earned = ease_poke_dollars(card, "mega_altaria", card.ability.extra.money_mod)
          G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + earned
          G.E_MANAGER:add_event(Event({
              func = function()
                  G.GAME.dollar_buffer = 0
                  return true
              end
          }))
        end

        if pcard:get_id() == 9 then
          card.ability.extra.drawn = card.ability.extra.drawn + 1
          if card.ability.extra.drawn == card.ability.extra.threshold then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
              pcard:set_edition('e_polychrome', true)
            return true end }))
            card.ability.extra.drawn = 0
          end
        end
      end)
    end

    -- Chips in main scoring
    if context.joker_main then
      return {
        chips = card.ability.extra.chips
      }
    end
  end,
}

local function init()
  SMODS.Joker:take_ownership('poke_altaria', { megas = { 'mega_altaria' } }, true)
  poke_add_to_family("altaria", "mega_altaria")
end

return {
  can_load = nacho_config.other_megas,
  init = init,
  list = { mega_altaria }
}
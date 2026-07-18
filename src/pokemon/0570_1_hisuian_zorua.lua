-- Hisuian Zorua 570-1
local hisuian_zorua = {
  name = "hisuian_zorua",
  pos = { x = 0, y = 9 },
  soul_pos = { x = 99, y = 99 },
  config = {extra = {hidden_key = nil, rounds = 5, active = true}},
  loc_vars = function(self, info_queue, card)
    local a = card.ability.extra or card.config.center.config.extra
    local main_end
    if card.area and card.area == G.jokers then
      local other_joker = G.jokers.cards[1]
      main_end = pokermon.ui.blueprint_compat(card ~= other_joker and other_joker)
    end
    return {vars = {a.rounds, colours = {not a.active and G.C.UI.TEXT_INACTIVE}}, main_end = main_end}
  end,
  designer = "ESN64",
  rarity = 3,
  cost = 8,
  stage = "Basic",
  ptype = "Colorless",
  gen = 5,
  blueprint_compat = true,
  rental_compat = false,
  get_illusion = function(self, card)
    if card.ability and card.ability.extra
        and card.area ~= G.jokers
        and not pokermon.is_in_collection(card) then
      return G.P_CENTERS[card.ability.extra.hidden_key]
    end
  end,
  calculate = function(self, card, context)
    local a, other_joker = card.ability.extra, G.jokers.cards[1]
    if a.active and other_joker and other_joker ~= card then
      local ret = SMODS.blueprint_effect(card, other_joker, context)
      if ret then
        ret.colour = G.C.BLACK
        return ret
      end
    end
    if context.after then
      PkmnDip.defer(function()
        a.active = false
        SMODS.calculate_effect({message = localize('poke_reveal_ex')}, card)
      end, {delay = 0.2})
    end
    if context.end_of_round and context.game_over == false and context.main_eval and not a.active then
      a.active = true
      return { message = localize('k_reset') }
    end
    return pokermon.level_evo(self, card, context, "j_nacho_hisuian_zoroark")
  end,
  set_card_type_badge = function(self, card, badges)
    pokermon.ui.set_card_type_badge(card, badges, self:get_illusion(card))
  end,
  set_sprites = function(self, card, front)
    local center = self:get_illusion(card)
    if center then
      card:set_sprites(center)
    end
  end,
  set_ability = function(self, card, initial, delay_sprites)
    if card.area ~= G.jokers and not pokermon.is_in_collection(card) then
      -- Initialize the Illusion
      if not pokermon.type_sticker_applied(card) then pokermon.apply_type_sticker(card, "Colorless") end
      card.ability.extra.hidden_key = card.ability.extra.hidden_key or pokermon.get_random_poke_key_options {
        key_append = 'zorua_h',
        rarity = 'Common',
        exclude_types = 'Colorless',
      }
      self:set_sprites(card)
    end
  end,
  generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local center = self:get_illusion(card)
    if center then
      return pokermon.ui.generate_illusion(center, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    end
    return SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
  end,
  update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and card.area and card.area == G.jokers then
      local other_joker = G.jokers.cards[1]
      if card.ability.extra.active and not card.debuff
          and other_joker and other_joker ~= card
          -- and other_joker.children.center.atlas.px == 71 -- Disables Unown Swarm drawing, because I just couldn't be bothered today.
          and other_joker.config.center.blueprint_compat then
        pokermon.copy_joker_sprites(card, other_joker)
      else
        pokermon.reset_sprite(card)
      end
    end
  end,
  attributes = {"copying", "round_evo"},
}

-- Hisuian Zoroark 571-1
local hisuian_zoroark = {
  name = "hisuian_zoroark",
  pos = { x = 2, y = 9 },
  soul_pos = { x = 99, y = 99 },
  config = {extra = {hidden_key = nil}},
  loc_vars = function(self, info_queue, card)
    local main_end
    if card.area and card.area == G.jokers then
      local other_joker = G.jokers.cards[1]
      main_end = pokermon.ui.blueprint_compat(card ~= other_joker and other_joker)
    end
    return {main_end = main_end}
  end,
  designer = "ESN64",
  rarity = "poke_safari",
  cost = 12,
  stage = "One",
  ptype = "Colorless",
  gen = 5,
  blueprint_compat = true,
  get_illusion = function(self, card)
    if card.ability and card.ability.extra
        and card.area ~= G.jokers
        and not pokermon.is_in_collection(card) then
      return G.P_CENTERS[card.ability.extra.hidden_key]
    end
  end,
  calculate = function(self, card, context)
    if G.jokers.cards[1] and G.jokers.cards[1] ~= card then
      local ret = SMODS.blueprint_effect(card, G.jokers.cards[1], context)
      if ret then
        ret.colour = G.C.BLACK
        return ret
      end
    end
  end,
  set_sprites = function(self, card, front)
    local center = self:get_illusion(card)
    if center then
      card:set_sprites(center)
    end
  end,
  set_ability = function(self, card, initial, delay_sprites)
    if card.area ~= G.jokers and not pokermon.is_in_collection(card) then
      -- Initialize the Illusion
      if not pokermon.type_sticker_applied(card) then pokermon.apply_type_sticker(card, "Colorless") end
      if not card.ability.extra.hidden_key then
        card.ability.extra.hidden_key = pokermon.get_random_poke_key_options {
          key_append = 'zoroark_h',
          rarity = 'poke_safari',
          exclude_types = 'Colorless',
        }
      end
      self:set_sprites(card)
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    card.ability.extra.hidden_key = nil
    pokermon.reset_sprite(card)
  end,
  generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local center = self:get_illusion(card)
    if center then
      return pokermon.ui.generate_illusion(center, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    end
    return SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
  end,
  update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and card.area and card.area == G.jokers then
      local other_joker = G.jokers.cards[1]
      if not card.debuff
          and other_joker and other_joker ~= card
          -- and other_joker.children.center.atlas.px == 71 -- Disables Unown Swarm drawing, because I just couldn't be bothered today.
          and other_joker.config.center.blueprint_compat then
        pokermon.copy_joker_sprites(card, other_joker)
      else
        pokermon.reset_sprite(card)
      end
    end
  end,
  attributes = {"copying"},
}

return {
  config_key = "hisuian_zorua",
  list = { hisuian_zorua, hisuian_zoroark }
}

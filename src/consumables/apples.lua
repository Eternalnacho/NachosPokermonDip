-- Tart Apple
local tartapple = {
  name = "tartapple",
  key = "tartapple",
  set = "Item",
  config = {max_highlighted = 2, min_highlighted = 2, mult_mod = 1},
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue+1] = {set = 'Other', key = 'eitem'}
    return {vars = {self.config.max_highlighted}}
  end,
  pos = { x = 0, y = 0 },
  atlas = "nacho_consumables",
  cost = 3,
  evo_item = true,
  unlocked = true,
  discovered = true,
  can_use = function(self, card)
    if G.jokers.highlighted and #G.jokers.highlighted == 1 and is_evo_item_for(self, G.jokers.highlighted[1]) then
      return true
    end
    if G.hand.highlighted and #G.hand.highlighted == 2 then
      return true
    end
    return false
  end,
  use = function(self, card, area, copier)
    set_spoon_item(card)
    if G.hand.highlighted and #G.hand.highlighted == 2 then
      local target = G.hand.highlighted[2]
      local rightmost = G.hand.highlighted[1]
      for i = 1, #G.hand.highlighted do
        if G.hand.highlighted[i].T.x > rightmost.T.x then
          rightmost = G.hand.highlighted[i]
        else
          target = G.hand.highlighted[i]
        end
      end
      --left card gains +1 mult, double if wild
      target.ability.perma_mult = target.ability.perma_mult or 0
      target.ability.perma_mult = target.ability.perma_mult + self.config.mult_mod * (SMODS.has_enhancement(target, 'm_wild') and 2 or 1)
      --right card gets destroyed
      poke_remove_card(rightmost, card)
      evo_item_use_total(self, card, area, copier)
    else
      highlighted_evo_item(self, card, area, copier)
    end
  end,
  in_pool = function(self)
    return true
  end
}

-- Sweet Apple
local sweetapple = {
  name = "sweetapple",
  key = "sweetapple",
  set = "Item",
  config = {max_highlighted = 2, min_highlighted = 2, money = 2},
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue+1] = {set = 'Other', key = 'eitem'}
    return {vars = {self.config.max_highlighted}}
  end,
  pos = { x = 1, y = 0 },
  atlas = "nacho_consumables",
  cost = 3,
  evo_item = true,
  unlocked = true,
  discovered = true,
  can_use = function(self, card)
    if G.jokers.highlighted and #G.jokers.highlighted == 1 and is_evo_item_for(self, G.jokers.highlighted[1]) then
      return true
    end
    if G.hand.highlighted and #G.hand.highlighted == 2 then
      return true
    end
    return false
  end,
  use = function(self, card, area, copier)
    set_spoon_item(card)
    if G.hand.highlighted and #G.hand.highlighted == 2 then
      local target = G.hand.highlighted[2]
      local rightmost = G.hand.highlighted[1]
      for i = 1, #G.hand.highlighted do
        if G.hand.highlighted[i].T.x > rightmost.T.x then
          rightmost = G.hand.highlighted[i]
        else
          target = G.hand.highlighted[i]
        end
      end
      --left card earns $2, becomes wild - double $ if wild
      ease_poke_dollars(target, 'sweetapple', self.config.money * (SMODS.has_enhancement(target, 'm_wild') and 2 or 1))
      --right card gets destroyed
      poke_remove_card(rightmost, card)
      evo_item_use_total(self, card, area, copier)
    else
      highlighted_evo_item(self, card, area, copier)
    end
  end,
  in_pool = function(self)
    return true
  end
}

-- Syrupy Apple
local syrupyapple = {
  name = "syrupyapple",
  key = "syrupyapple",
  set = "Item",
  config = {max_highlighted = 1, converted = 2},
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue+1] = {set = 'Other', key = 'eitem'}
    return {vars = {self.config.max_highlighted, self.config.converted}}
  end,
  pos = { x = 2, y = 0 },
  atlas = "nacho_consumables",
  cost = 3,
  evo_item = true,
  unlocked = true,
  discovered = true,
  can_use = function(self, card)
    if G.jokers.highlighted and #G.jokers.highlighted == 1 and is_evo_item_for(self, G.jokers.highlighted[1]) then
      return true
    end
    if G.hand.highlighted and #G.hand.highlighted == 1 then
      return true
    end
    return false
  end,
  use = function(self, card, area, copier)
    set_spoon_item(card)
    if G.hand.highlighted and #G.hand.highlighted == 1 then
      local selected = G.hand.highlighted[1]
      poke_convert_cards_to(selected, {mod_conv = 'm_wild'}, true)

      -- convert up to 2 other cards to wild
      local cards_held = PkmnDip.utils.filter(G.hand.cards, function(v) return v ~= selected end)
      pseudoshuffle(cards_held, pseudoseed('syrup'))
      for i = 1, math.min(#cards_held, self.config.converted) do
        poke_convert_cards_to(cards_held[i], {mod_conv = 'm_wild'}, true)
      end

      -- destroy a random non-wild card remaining
      local viable_targets = PkmnDip.utils.filter(cards_held, function(v) return not SMODS.has_enhancement(v, 'm_wild') end)
      pseudoshuffle(viable_targets, pseudoseed('syrup'))
      poke_remove_card(viable_targets[1], card)
      
      evo_item_use_total(self, card, area, copier)
    else
      highlighted_evo_item(self, card, area, copier)
    end
  end,
  in_pool = function(self)
    return true
  end
}

return {
  name = "Nacho's Apples",
  enabled = nacho_config.applin or false,
  list = { tartapple, sweetapple, syrupyapple }
}

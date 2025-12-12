-- Swablu 333
local swablu={
  name = "swablu",
  config = {extra = {money = 1, rounds = 4}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local nine_tally = G.playing_cards and #PkmnDip.utils.filter(G.playing_cards, function(v) return v:get_id() == 9 end) or 0
    return {vars = {card.ability.extra.money, card.ability.extra.money * nine_tally, card.ability.extra.rounds}}
  end,
  designer = "roxie",
  rarity = 2,
  cost = 7,
  stage = "Basic",
  ptype = "Colorless",
  gen = 3,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    return level_evo(self, card, context, "j_nacho_altaria")
  end,
  calc_dollar_bonus = function(self, card)
    local nine_tally = G.playing_cards and #PkmnDip.utils.filter(G.playing_cards, function(v) return v:get_id() == 9 end) or 0
    return ease_poke_dollars(card, "swablu", card.ability.extra.money * nine_tally, true)
	end
}

-- Altaria 334
local altaria={
  name = "altaria",
  config = {extra = {money = 1}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local nine_tally = 0
    if G.playing_cards then
      local nines = PkmnDip.utils.filter(G.playing_cards, function(v) return v:get_id() == 9 end); nine_tally = #nines
      PkmnDip.utils.for_each(nines, function(v) if v.config.center ~= G.P_CENTERS.c_base then nine_tally = nine_tally + 1 end end)
    end
    return {vars = {card.ability.extra.money, card.ability.extra.money * 2, card.ability.extra.money * nine_tally}}
  end,
  designer = "roxie",
  rarity = "poke_safari",
  cost = 10,
  stage = "One",
  ptype = "Dragon",
  gen = 3,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calc_dollar_bonus = function(self, card)
    local nine_tally = 0
    local nines = PkmnDip.utils.filter(G.playing_cards, function(v) return v:get_id() == 9 end); nine_tally = #nines
    PkmnDip.utils.for_each(nines, function(v) if v.config.center ~= G.P_CENTERS.c_base then nine_tally = nine_tally + 1 end end)
    return ease_poke_dollars(card, "altaria", card.ability.extra.money * nine_tally, true)
	end,
  megas = {"mega_altaria"},
}

-- Mega Altaria 334-1
local mega_altaria={
  name = "mega_altaria",
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {vars = {}}
  end,
  designer = "Eternalnacho",
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Dragon",
  gen = 3,
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and not context.blueprint then
      for _, v in pairs(G.play.cards) do
        if v:get_id() == 9 and not v.edition then
          local edition = poll_edition('aura', nil, true, true)
          v:set_edition(edition, true, true)
          v:juice_up(0.3, 0.5)
        end
      end
    end
  end,
}

return {
  config_key = "swablu",
  list = { swablu, altaria, mega_altaria }
}

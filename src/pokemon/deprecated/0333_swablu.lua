-- Swablu 333
local swablu={
  name = "swablu",
  config = {extra = {money = 1, rounds = 4}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local nine_tally = G.playing_cards and #PkmnDip.utils.filter(G.playing_cards, function(v) return v:get_id() == 9 end) or 0
    return {vars = {card.ability.extra.money, card.ability.extra.money * nine_tally, card.ability.extra.rounds}}
  end,
  loc_txt = {
    name = "Swablu",
    text = {
      "Earn {C:money}$#1#{} for each",
      "{C:attention}9{} in your {C:attention}full deck{}",
      "at end of round",
      "{C:inactive}(Currently {C:money}$#2#{}{C:inactive})",
      "{C:inactive,s:0.8}(Evolves after {C:attention,s:0.8}#3#{C:inactive,s:0.8} rounds)",
    }
  },
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
  loc_txt = {
    name = "Altaria",
    text = {
      "Earn {C:money}$#1#{} for each {C:attention}unenhanced 9{}",
      "and {C:money}$#2#{} for each {C:attention}enhanced 9{}",
      "in your {C:attention}full deck{} at end of round",
      "{br:2}ERROR - CONTACT STEAK",
      "{C:attention}9s can't{} be debuffed",
      "{C:inactive}(Currently {C:money}$#3#{}{C:inactive})",
    }
  },
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
  loc_txt = {
    name = "Mega Altaria",
    text = {
      "Adds {C:dark_edition}Foil{}, {C:dark_edition}Holographic{},",
      "or {C:dark_edition}Polychrome{} to each",
      "played {C:attention}9{} without",
      "an {C:attention}edition{}",
    }
  },
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
  can_load = false,
  config_key = "swablu",
  list = { swablu, altaria, mega_altaria }
}
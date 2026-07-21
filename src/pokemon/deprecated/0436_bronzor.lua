local filter = PkmnDip.utils.filter
local get_adj = pokermon.get_adjacent_jokers

-- Bronzor 436
local bronzor = {
  name = "bronzor",
  config = {extra = { triggered = 0 }, evo_rqmt = 20},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
		return {vars = {math.max(card.ability.evo_rqmt - card.ability.extra.triggered, 0)}}
  end,
  loc_txt = {
    name = "Bronzor",
    text = {
      "This Joker scores",
      "as a {C:attention}held Steel{} card",
      "{C:inactive,s:0.8}(Evolves after triggering {C:attention,s:0.8}#1#{C:inactive,s:0.8} times)",
    }
  },
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Metal",
  gen = 4,
  perishable_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.before then
      PkmnDip.eff.joker_as_card(card, {
        area = G.hand,
        enhancement = 'm_steel',
      })
    end
    if context.individual and context.cardarea == G.hand and context.other_card.scoring_for == card then
      card.ability.extra.triggered = card.ability.extra.triggered + 1
    end
    return pokermon.scaling_evo(self, card, context, "j_nacho_bronzong", card.ability.extra.triggered, self.config.evo_rqmt)
  end,
  attributes = {"enhancements", "trigger_evo"},
}

-- Bronzong 437
local bronzong = {
  name = "bronzong",
  config = { extra = {} },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
		return {vars = {}}
  end,
  loc_txt = {
    name = "Bronzong",
    text = {
      "This Joker and adjacent {X:poke_metal,C:white}Metal{}",
      "Jokers score as {C:attention}held Steel{} cards",
    }
  },
  rarity = "poke_safari",
  cost = 10,
  stage = "One",
  ptype = "Metal",
  gen = 4,
  perishable_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.before then
      local metal_adj = filter(get_adj(card), PkmnDip.con.is_metal)
      PkmnDip.utils.for_each(metal_adj, function(joker)
        PkmnDip.eff.joker_as_card(joker, {
          area = G.hand,
          enhancement = 'm_steel',
        })
      end)
    end
  end,
  attributes = {"enhancements", "joker", "types"},
}

return {
  can_load = false,
  config_key = "bronzor",
  list = { bronzor, bronzong }
}
local cranidos = {
  name = "cranidos",
  config = { extra = { rank = "5", mult = 5, Xmult_mod = 0.1, third_times = 0 }, evo_rqmt = 5 },
  loc_vars = function(self, info_queue, card)
    local a = card.ability.extra or self.config.extra
    local rank = localize(a.rank, 'ranks')
    local evo_req = math.max(self.config.evo_rqmt - a.third_times, 0)
    info_queue[#info_queue+1] = { set = 'Other', key = 'ancient', vars = {rank} }
    return { vars = { rank, a.mult, 1 + a.Xmult_mod, evo_req } }
  end,
  rarity = 2,
  cost = 5,
  stage = "Basic",
  ptype = "Earth",
  gen = 4,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.press_play and not context.blueprint then
      pokermon.get_ancient_amount(G.hand.highlighted, 5, card)
      for _, v in ipairs(G.hand.highlighted) do
        if v:get_id() == 5 then a.first_five = v; break end
      end
    end
    -- 1: 3:
    if context.individual and context.cardarea == G.play and context.other_card:get_id() == 5 and context.other_card == a.first_five then
      local eff = { card = context.other_card }
      -- 1: Played 5s give +5 mult
      if a.ancient_count >= 1 then eff.mult = a.mult end
      -- 3: Played 5s give X1.1 mult
      if a.ancient_count >= 3 then eff.xmult = a.Xmult_mod end
      return eff
    end
    -- 2: Destroy first unscored card
    if context.destroy_card and not context.blueprint and context.cardarea == 'unscored' then
      local not_in_scoring = function(c) return not SMODS.in_scoring(c, context.scoring_hand) end
      local first_unscored = PkmnDip.calc.find_playing_card(not_in_scoring, context.full_hand, 1)
      if a.ancient_count >= 2 and context.destroy_card == first_unscored then
        return { remove = true }
      end
    end

    if context.after then
      if a.ancient_count >= 3 then a.third_times = a.third_times + 1 end
      a.first_five = nil
      a.ancient_count = 0
    end
    return pokermon.scaling_evo(self, card, context, "j_nacho_rampardos", card.ability.extra.third_times, self.config.evo_rqmt)
  end,
  generate_ui = pokermon.fossil_generate_ui,
  attributes = {"ancient", "rank", "five", "enhancements", "trigger_evo"},
}

local rampardos = {
  name = "rampardos",
  config = { extra = { rank = "5", mult = 5, Xmult_mod = 0.1, retriggers = 1 } },
  loc_vars = function(self, info_queue, card)
    local a = card.ability.extra or self.config.extra
    local rank = localize(a.rank, 'ranks')
    info_queue[#info_queue+1] = { set = 'Other', key = 'ancient', vars = {rank} }
    return { vars = { rank, a.mult, a.Xmult_mod, a.retriggers } }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Earth",
  gen = 4,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.press_play and not context.blueprint then
      pokermon.get_ancient_amount(G.hand.highlighted, 5, card)
      for _, v in ipairs(G.hand.highlighted) do
        if v:get_id() == 5 then a.first_five = v; break end
      end
    end
    -- 1: 3:
    if context.individual and context.cardarea == G.play and context.other_card:get_id() == 5 and context.other_card == a.first_five then
      local fives = #PkmnDip.utils.filter(context.full_hand, function(c) return c:get_id() == 5 end)
      local eff = { card = context.other_card }
      -- 1: Played 5s give +5 mult
      if a.ancient_count >= 1 then eff.mult = a.mult * fives end
      -- 3: Played 5s give X1.1 mult
      if a.ancient_count >= 3 then eff.xmult = 1 + a.Xmult_mod * fives end
      return eff
    end
    -- 2: Destroy first unscored card
    if context.destroy_card and not context.blueprint and context.cardarea == 'unscored' then
      local not_in_scoring = function(c) return not SMODS.in_scoring(c, context.scoring_hand) end
      local first_unscored = PkmnDip.calc.find_playing_card(not_in_scoring, context.full_hand, 1)
      if a.ancient_count >= 2 and context.destroy_card == first_unscored then
        return { remove = true }
      end
    end
    -- 4: Remove all but the first 5 from scoring, retrigger first 5 once per card removed
    if context.modify_scoring_hand and context.in_scoring and not (context.other_card == a.first_five) then
      if context.other_card:get_id() == 5 and a.ancient_count >= 4 then return { remove_from_hand = true } end
    end
    if PkmnDip.con.has_repeat_effect(context) and context.cardarea == G.play and context.other_card:get_id() == 5 and a.ancient_count >= 4 then
      return { repetitions = a.retriggers * a.ancient_count - 1 }
    end

    if context.after then
      a.first_five = nil
      a.ancient_count = 0
    end
  end,
  generate_ui = pokermon.fossil_generate_ui,
  attributes = {"ancient", "rank", "five", "enhancements"},
}

return {
  config_key = "cranidos",
  list = { cranidos, rampardos }
}
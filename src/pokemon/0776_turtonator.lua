-- Turtonator 776
local turtonator={
  name = "turtonator",
  config = {extra = { Xmult_multi = 1.5, trapped = false }},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'shell_trap'}
    local active = card.ability.extra.trapped and "Active!" or "Inactive"
    return {vars = {card.ability.extra.Xmult_multi, active}}
  end,
  rarity = 2,
  cost = 7,
  stage = "Basic",
  ptype = "Dragon",
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    -- Setting Blind juice function
    if context.setting_blind and a.trapped then
      local eval = function() return a.trapped and G.GAME.in_blind end
      juice_card_until(card, eval, true)
    end
    -- Triggering Shell Trap
    if (context.debuffed_hand or context.shell_trap) and not a.trapped then
      local eval = function() return a.trapped and G.GAME.in_blind end
      juice_card_until(card, eval, true)
      return { message = localize('k_active_ex'), func = function() a.trapped = true end }
    end

    if context.after then
      PkmnDip.defer(function()
        if a.trapped then a.trapped = nil end
        local debuffed = PkmnDip.utils.any(context.scoring_hand, function(c) return c.debuff end)
        if debuffed then SMODS.calculate_context({ shell_trap = true }) end
      end)
    end

    -- Scoring Bit
    if context.before and context.main_eval and a.trapped then
      return { message = localize('poke_shell_trap_ex'), colour = G.C.XMULT }
    end
    if context.individual and context.cardarea == G.play and a.trapped then
      return { xmult = card.ability.extra.Xmult_multi }
    end
  end,
  attributes = {"xmult"}
}

init = function()
  PkmnDip.Hook("after", Card, 'set_debuff', function(self, should_debuff)
    if (self.debuff or should_debuff) and (self.area == G.jokers or self.playing_card) 
        and next(SMODS.find_card('j_nacho_turtonator')) then
      SMODS.calculate_context({ shell_trap = true })
    end
  end)
end

return {
  config_key = "turtonator",
  init = init,
  list = { turtonator }
}
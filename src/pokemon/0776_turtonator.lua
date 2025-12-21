-- Turtonator 776
local turtonator={
  name = "turtonator",
  config = {extra = {Xmult_mod = 1.3, trapped = false}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local active = card.ability.extra.trapped and "Active!" or "Inactive"
    return {vars = {card.ability.extra.Xmult_mod, active}}
  end,
  rarity = 2,
  cost = 8,
  stage = "Basic",
  ptype = "Dragon",
  perishable_compat = true,
  blueprint_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    -- Calculating debuffs
    if context.debuffed_hand then
      a.trapped = true
    end
    if context.joker_main then
      if not a.trapped then
        local debuffed
        PkmnDip.utils.for_each(context.scoring_hand, function(v) if v.debuff then debuffed = true; return end end)
        PkmnDip.utils.for_each(G.jokers.cards, function(v) if v.debuff then debuffed = true; return end end)
        if debuffed then a.trapped = true end
      else
        a.trapped = false
      end
    end

    -- Scoring Bit
    if context.before and context.main_eval and a.trapped then
      return{
        message = localize('poke_shell_trap_ex'),
        colour = G.C.XMULT,
        card = card,
      }
    end
    if context.individual and context.cardarea == G.play and a.trapped then
      return{
        xmult = card.ability.extra.Xmult_mod,
        colour = G.C.XMULT,
      }
    end
  end,
}

return {
  config_key = "turtonator",
  list = { turtonator }
}
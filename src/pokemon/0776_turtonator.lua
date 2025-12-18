-- Turtonator 776
local turtonator={
  name = "turtonator",
  config = {extra = {Xmult_mod = 1.5, trapped = false, set_off = false, boss_trigger = false}},
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local active = nil
    if card.ability.extra.trapped then active = "Active!"
    else active = "Inactive" end
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
    -- Calculate boss trigger
    if calc_boss_trigger(context) and not card.ability.extra.trapped then
      card.ability.extra.trapped = true
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('poke_shell_trap_ex')})
    end

    -- Scoring Bit Here
    if context.before and context.main_eval and card.ability.extra.trapped then
      return{
        message = localize('poke_shell_trap_ex'),
        colour = G.C.XMULT,
        card = card,
      }
    end
    if context.individual and context.cardarea == G.play and context.scoring_hand then 
      if card.ability.extra.trapped then
        card.ability.extra.set_off = true
        return{
          xmult = card.ability.extra.Xmult_mod,
          colour = G.C.XMULT,
        }
      end
    end

    -- Shell Trap on/off switch
    if (context.joker_main or context.debuffed_hand) and card.ability.extra.trapped and card.ability.extra.set_off then
      card.ability.extra.trapped = false
      card.ability.extra.set_off = false
    end
  end,
}

return {
  config_key = "turtonator",
  list = { turtonator }
}

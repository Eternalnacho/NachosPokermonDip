-- 777 Togedemaru
local togedemaru = {
  name = "togedemaru",
  config = { extra = { Xmult_multi = 1.3, money_mod = 3 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_multi, card.ability.extra.money_mod } }
  end,
  designer = "One Punch Idiot",
  nacho_from_bfp = true,
  rarity = 3,
  cost = 7,
  stage = "Basic",
  ptype = "Metal",
  gen = 7,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.other_joker and PkmnDip.con.is_lightning(context.other_joker) then
      return { Xmult = a.Xmult_multi, card = context.other_joker }
    end
    if context.end_of_round and context.main_eval and not context.game_over then
      for _, v in ipairs(PkmnDip.utils.filter(G.jokers.cards, PkmnDip.con.is_metal)) do
        local earned = pokermon.ease_poke_dollars(v, "togedemaru", a.money_mod, true)
        SMODS.calculate_effect({ dollars = earned }, v)
      end
    end
  end
}

return {
  config_key = 'togedemaru',
  list = { togedemaru }
}

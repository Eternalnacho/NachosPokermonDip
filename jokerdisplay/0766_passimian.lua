local jd_def = JokerDisplay.Definitions
local jd_global_def = JokerDisplay.Global_Definitions

jd_def["j_nacho_passimian"] = {
  calc_function = function(card)
    local received = card and card.ability and card.ability.received_card
    local calc = jd_def[received] and jd_def[received].calc_function
    return type(calc) == 'function' and calc(card)
  end,
}

PkmnDip.update_pass_joker_display = function(card)
  local received = card and card.ability and card.ability.received_card
  if not received then return end
  jd_global_def.Replace["j_nacho_passimian"] = {
    priority = 1,
    replace_text = received,
    replace_reminder = received,
    replace_extra = received,
    replace_modifiers = {},
    is_replaced_func = function (_card, custom_parent)
      return _card and _card.ability and _card.ability.received_card
    end
  }
end
-- Fossil Excavator
local excavator = {
  name = "excavator",
  pos = {x = 0, y = 0},
  config = { extra = { boss_req = 2, bosses_beat = 0 } },
  loc_vars = function(self, info_queue, card)
    local a = card.ability.extra or self.config.extra
    local active = a.boss_beat and "Active!" or "Inactive"
    return { vars = { a.boss_req, a.bosses_beat } }
  end,
  rarity = 1,
  cost = 5,
  stage = "Other",
  atlas = "nacho_excavator",
  eternal_compat = false,
  calculate = function(self, card, context)
    local a = card.ability.extra
    if context.selling_self and (a.bosses_beat >= a.boss_req) and not context.blueprint then
      PkmnDip.defer(function() 
        add_tag(Tag('tag_nacho_fossil_tag'))
        play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
        play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
      end)
    end
    if context.end_of_round and context.beat_boss and not context.game_over and context.main_eval and not context.blueprint then
      a.bosses_beat = a.bosses_beat + 1
      if a.bosses_beat >= a.boss_req then
        local eval = function(c) return not c.REMOVED end
        juice_card_until(card, eval, true)
      end
      return { message = (a.bosses_beat < a.boss_req) and (a.bosses_beat .. '/' .. a.boss_req) or localize('k_active_ex') }
    end
  end,
  attributes = {"tag", "generation", "on_sell"}
}

return {
  config_key = "excavator",
  list = { excavator }
}
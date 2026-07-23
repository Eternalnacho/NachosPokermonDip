-- Finizen 963
local finizen = {
  name = "finizen",
  config = { extra = { chips = 40, rounds = 3 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.rounds } }
  end,
  designer = "One Punch Idiot",
  nacho_from_bfp = true,
  rarity = 1,
  cost = 4,
  stage = "Basic",
  ptype = "Water",
  gen = 9,
  blueprint_compat = true,
  eternal_compat = false,
  calculate = function(self, card, context)
    if context.before then
      local c = PkmnDip.eff.joker_as_card(card, {
        area = G.play,
        enhancement = 'm_bonus'
      })
      table.remove(G.play.cards, #G.play.cards)
      table.insert(G.play.cards, 1, c)
      table.insert(context.scoring_hand, 1, c)
    end
    return pokermon.level_evo(self, card, context, 'j_nacho_palafin')
  end
}

-- Palafin 964
local palafin = {
  name = "palafin",
  config = { extra = { chips = 70, rounds = 4 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.rounds } }
  end,
  designer = "One Punch Idiot",
  nacho_from_bfp = true,
  rarity = 'poke_safari',
  cost = 6,
  stage = "One",
  ptype = "Water",
  gen = 9,
  blueprint_compat = true,
  eternal_compat = false,
  calculate = function(self, card, context)
    if context.joker_main then
      return { chips = card.ability.extra.chips }
    end
  end
}

-- Palafin Hero 964-1
local palafin_hero = {
  name = "palafin_hero",
  pos = { x = 8, y = 1 },
  config = { extra = { chips = 100, Xmult_multi = 0.1, chip_mod = 10 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.chip_mod, card.ability.extra.Xmult_multi } }
  end,
  designer = "One Punch Idiot",
  nacho_from_bfp = true,
  rarity = 'poke_safari',
  cost = 6,
  stage = "One",
  ptype = "Water",
  gen = 9,
  blueprint_compat = true,
  eternal_compat = false,
  atlas = "AtlasJokersBasicGen09",
  calculate = function(self, card, context)
    if context.joker_main then
      return { chips = card.ability.extra.chips }
    end
    if context.individual and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
      local other = context.other_card
      other.ability.perma_bonus = other.ability.perma_bonus or 0
      other.ability.perma_bonus = other.ability.perma_bonus + card.ability.extra.chip_mod
      if SMODS.has_enhancement(other, "m_bonus") then
        other.ability.perma_x_mult = other.ability.perma_x_mult or 1
        other.ability.perma_x_mult = other.ability.perma_x_mult + card.ability.extra.Xmult_multi
      end
    end
  end
}
return {
  config_key = "finizen",
  list = { finizen, palafin, palafin_hero }
}

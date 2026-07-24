-- Finizen 963
local finizen = {
  name = "finizen",
  config = { extra = { chips = 30, rounds = 4 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.rounds } }
  end,
  designer = "One Punch Idiot",
  nacho_from_bfp = true,
  rarity = 1,
  cost = 5,
  stage = "Basic",
  ptype = "Water",
  gen = 9,
  blueprint_compat = true,
  eternal_compat = false,
  calculate = function(self, card, context)
    if context.joker_main then
      return { chips = card.ability.extra.chips }
    end
    return pokermon.level_evo(self, card, context, 'j_nacho_palafin')
  end
}

-- Palafin 964
local palafin = {
  name = "palafin",
  config = { extra = { chips = 50 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips } }
  end,
  designer = "One Punch Idiot",
  nacho_from_bfp = true,
  rarity = 'poke_safari',
  cost = 8,
  stage = "One",
  ptype = "Water",
  gen = 9,
  auto_sticker = true,
  blueprint_compat = true,
  eternal_compat = false,
  calculate = function(self, card, context)
    if context.joker_main then
      if not context.blueprint then
        PkmnDip.palafin = card
        PkmnDip.defer(function()
          SMODS.calculate_effect({ message = localize('poke_flipturn_ex') }, card)
          SMODS.destroy_cards(card, nil, nil, true)
        end)
      end
      return { chips = card.ability.extra.chips }
    end
  end
}

-- Palafin Hero 964-1
local palafin_hero = {
  name = "palafin_hero",
  pos = { x = 8, y = 1 },
  config = { extra = { chips1 = 100, chip_mod = 10, Xmult_multi = 0.1 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips1, card.ability.extra.chip_mod, card.ability.extra.Xmult_multi } }
  end,
  designer = "One Punch Idiot",
  nacho_from_bfp = true,
  rarity = 'poke_safari',
  cost = 8,
  stage = "One",
  ptype = "Water",
  gen = 9,
  aux_poke = true,
  auto_sticker = true,
  no_collection = true,
  blueprint_compat = true,
  eternal_compat = false,
  atlas = "AtlasJokersBasicGen09",
  calculate = function(self, card, context)
    if context.joker_main then
      return { chips = card.ability.extra.chips1 }
    end
    if context.individual and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
      local other = context.other_card
      other.ability.perma_bonus = other.ability.perma_bonus or 0
      other.ability.perma_bonus = other.ability.perma_bonus + card.ability.extra.chip_mod
      if SMODS.has_enhancement(other, "m_bonus") then
        other.ability.perma_x_mult = other.ability.perma_x_mult or 1
        other.ability.perma_x_mult = other.ability.perma_x_mult + card.ability.extra.Xmult_multi
        SMODS.calculate_effect({ message = localize('poke_jetpunch_ex'), colour = G.C.CHIPS }, card)
      else
        SMODS.calculate_effect({ message = localize('poke_aquajet_ex'), colour = G.C.CHIPS }, card)
      end
    end
    if context.beat_boss and not context.blueprint then
      return {
        message = pokermon.evolve(card, 'j_nacho_palafin', true),
        func = function() SMODS.calculate_effect({ message = localize('poke_devolve_success'), colour = G.C.CHIPS }, card) end
      }
    end
  end
}

return {
  config_key = "finizen",
  list = { finizen, palafin, palafin_hero }
}

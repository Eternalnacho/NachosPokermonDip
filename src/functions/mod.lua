-- Mod Object Functions and Mod-Facing Functions

SMODS.current_mod.set_debuff = function(card)
  -- prevent debuffs
  if card.ability.name == "mega_gallade" then return 'prevent_debuff' end
  if card.ability.name == "tsareena" and PkmnDip.con.all_grass then return 'prevent_debuff' end
  if card:get_id() == 9 and next(SMODS.find_card("j_poke_mega_altaria")) then return 'prevent_debuff' end
  return false
end

SMODS.current_mod.calculate = function(self, context)
  if G.GAME.modifiers.sinnoh_adv and context.starting_shop then
    for _, starter in ipairs { 'turtwig', 'chimchar', 'piplup' } do
      local shop_card = SMODS.create_card({set = 'Joker', key = 'j_nacho_'..starter, area = G.shop_jokers})
      G.shop_jokers:emplace(shop_card)
      create_shop_card_ui(shop_card)
    end
    G.GAME.modifiers.sinnoh_adv = nil
  end

  -- Palafin Transformation Sequence lmaooooooo
  if context.end_of_round and PkmnDip.palafin then
    local new_card = SMODS.copy_card(PkmnDip.palafin)
    PkmnDip.palafin = nil
    SMODS.calculate_effect({ message = localize('poke_transform_success'), colour = G.C.CHIPS }, new_card)
    return { message = pokermon.evolve(new_card, 'j_nacho_palafin_hero', true) }
  end
end

SMODS.current_mod.reset_game_globals = function(run_start)
  if run_start then PkmnDip.utils.for_each(G.P_CENTERS, function(center) 
    if center.nacho_config_key and not PkmnDip.config[center.nacho_config_key] then
      G.GAME.banned_keys[center.key] = true
    end
  end) end
end

PkmnDip.attach_mega = function(center, target, config_key)
  SMODS.Joker:take_ownership(target, {
    megas = PkmnDip.config[(config_key or center.name)] and { center.name } or nil,
    discovered = true,
  }, true)
  pokermon.add_to_family(target:sub(6, -1), center.name)
end

PkmnDip.attach_gmax = function(center, target, config_key)
  SMODS.Joker:take_ownership(target, {
    gmax = PkmnDip.config[(config_key or center.name)] and { center.name } or nil,
    discovered = true,
  }, true)
  pokermon.add_to_family(target:sub(6, -1), center.name)
end

PkmnDip.Hook('around', SMODS, 'create_mod_badges', function(orig, obj, badges)
  if obj and obj.nacho_from_bfp then
    obj.mod = {
      id = "BarelyFunctioningPokermon",
      display_name = "Dip+BFP",
      author = "Onepunchidiot",
      prefix = "bfp",
      badge_colour = HEX("F0B6AF"),
      badge_text_colour = HEX("FFFFFF"),
    }
    orig(obj, badges)
    obj.mod = SMODS.Mods['NachosPokermonDip']
  else
    orig(obj, badges)
  end
end)

-- Talisman compat shorthand (still recommend just using Amulet atp but eh)
to_number = to_number or function(x) return x end
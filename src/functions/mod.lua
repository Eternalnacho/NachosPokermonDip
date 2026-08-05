-- Mod Object Functions and Mod-Facing Functions

SMODS.current_mod.set_debuff = function(card)
  -- prevent debuffs
  if card.ability.name == "mega_gallade" then return 'prevent_debuff' end
  if card.ability.name == "tsareena" and PkmnDip.con.all_grass() then return 'prevent_debuff' end
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
    for _, c in pairs(PkmnDip.palafin) do
      PkmnDip.defer(function()
        local new_card = SMODS.copy_card(c)
        SMODS.calculate_effect({ message = pokermon.evolve(new_card, 'j_nacho_palafin_hero', true) }, new_card)
        SMODS.calculate_effect({ message = localize('poke_transform_success'), colour = G.C.CHIPS }, new_card)
      end, { blockable = true, delay = 0.2 })
    end
    PkmnDip.defer(PkmnDip.eff.release_reserved_slots, { blockable = true } )
    PkmnDip.palafin = nil
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

PkmnDip.use_better_fossil_ui = function()
  if (SMODS.Mods["ToxicStall"] or {}).can_load then
    SMODS.add_attribute("ancient", {
      'j_stall_arctozolt',
      'j_stall_arctovish',
      'j_stall_dracozolt',
      'j_stall_dracovish'
    })
  end

  for _, center in pairs(SMODS.get_attribute_pool("ancient")) do
    local loc_text = { name = G.localization.descriptions.Joker[center].name, text = {} }
    local text_parsed = {}
    for i, line in ipairs(G.localization.descriptions.Joker[center].text) do
      if line:find("%d%+") or line:find("Trigger") or i < 2 then
        if line:find("Ancient") and PkmnDip.config.use_better_fossil_ui then
          line = line:gsub('(C:%w+)', '%1,s:1.1')
        end
        loc_text.text[#loc_text.text+1] = {line}
        text_parsed[#text_parsed+1] = {loc_parse_string(line)}
      else
        table.insert(loc_text.text[#loc_text.text], '     ' .. line)
        table.insert(text_parsed[#text_parsed], loc_parse_string('     ' .. line))
      end
    end
    SMODS.process_loc_text(G.localization.descriptions.Joker, center .. '_bf', loc_text)
    G.localization.descriptions.Joker[center .. '_bf'].text_parsed = text_parsed
    local center_loc_vars = G.P_CENTERS[center].loc_vars
    local prefix = G.P_CENTERS[center].poke_custom_prefix or "poke"
    SMODS.Joker:take_ownership(prefix..'_'..G.P_CENTERS[center].name, {
      loc_vars = function(self, info_queue, card)
        local ret = center_loc_vars(self, info_queue, card)
        if PkmnDip.config.use_better_fossil_ui then ret.key = self.key .. "_bf" end
        return ret
      end,
      generate_ui = PkmnDip.config.use_better_fossil_ui and PkmnDip.revised_fossil_ui or pokermon.fossil_generate_ui,
      discovered = true,
    }, true)
  end
end

-- Talisman compat shorthand (still recommend just using Amulet atp but eh)
to_number = to_number or function(x) return x end
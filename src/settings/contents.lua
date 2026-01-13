local pages = {
  {
    title = function() return localize("nacho_pokemon1") end,
    tiles = {
      { list = { 'j_nacho_turtwig', 'j_nacho_grotle', 'j_nacho_torterra' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_turtwig" } end, config_key = "turtwig" },
      { list = { 'j_nacho_chimchar', 'j_nacho_monferno', 'j_nacho_infernape'  }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_chimchar" } end, config_key = "chimchar" },
      { list = { 'j_nacho_piplup', 'j_nacho_prinplup', 'j_nacho_empoleon'  }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_piplup" } end, config_key = "piplup" },
      { list = { 'j_nacho_ralts', 'j_nacho_kirlia', 'j_nacho_gardevoir', 'j_nacho_mega_gardevoir', 'j_nacho_gallade', 'j_nacho_mega_gallade' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_ralts" } end, config_key = "ralts" },
      { list = { 'j_nacho_swablu', 'j_nacho_altaria', 'j_nacho_mega_altaria' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_swablu" } end, config_key = "swablu" },
      { list = { 'j_nacho_shieldon', 'j_nacho_bastiodon' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_shieldon" } end, config_key = "shieldon" },
    }
  },
  {
    title = function() return localize("nacho_pokemon2") end,
    tiles = {
      { list = { 'j_nacho_bronzor', 'j_nacho_bronzong' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_bronzor" } end, config_key = "bronzor" },
      { list = { 'j_nacho_snover', 'j_nacho_abomasnow', 'j_nacho_mega_abomasnow' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_snover" } end, config_key = "snover" },
      { list = { 'j_nacho_victini' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_victini" } end, config_key = "victini" },
      { list = { 'j_nacho_audino', 'j_nacho_mega_audino' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_audino" } end, config_key = "audino" },
      { list = { 'j_nacho_hisuian_zorua', 'j_nacho_hisuian_zoroark' }, label = function() return "Hisuian Zorua" end, config_key = "hisuian_zorua" },
      { list = { 'j_nacho_solosis', 'j_nacho_duosion', 'j_nacho_reuniclus' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_solosis" } end, config_key = "solosis" },
    }
  },
  {
    title = function() return localize("nacho_pokemon3") end,
    tiles = {
      { list = { 'j_nacho_clauncher', 'j_nacho_clawitzer' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_clauncher" } end, config_key = "clauncher" },
      { list = { 'j_nacho_dedenne' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_dedenne" } end, config_key = "dedenne" },
      { list = { 'j_nacho_carbink' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_carbink" } end, config_key = "carbink" },
      { list = { 'j_nacho_goomy', 'j_nacho_sliggoo', 'j_nacho_goodra', 'j_nacho_hisuian_sliggoo', 'j_nacho_hisuian_goodra' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_goomy" } end, config_key = "goomy" },
      { list = { 'j_nacho_oranguru' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_oranguru" } end, config_key = "oranguru" },
      { list = { 'j_nacho_passimian' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_passimian" } end, config_key = "passimian" },
      
    }
  },
  {
    title = function() return localize("nacho_pokemon4") end,
    tiles = {
      { list = { 'j_nacho_turtonator' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_turtonator" } end, config_key = "turtonator" },
      { list = { 'j_nacho_skwovet', 'j_nacho_greedent' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_skwovet" } end, config_key = "skwovet" },
      { list = { 'j_nacho_applin', 'j_nacho_flapple', 'j_nacho_appletun', 'j_nacho_dipplin', 'j_nacho_hydrapple' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_applin" } end, config_key = "applin" },
      { list = { 'j_nacho_galarian_meowth', 'j_nacho_perrserker' }, label = function() return "Galarian Meowth" end, config_key = "galarian_meowth" },
      { list = { 'j_nacho_smoliv', 'j_nacho_dolliv', 'j_nacho_arboliva' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_smoliv" } end, config_key = "smoliv" },
      { list = { 'j_nacho_frigibax', 'j_nacho_arctibax', 'j_nacho_baxcalibur' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_frigibax" } end, config_key = "frigibax" },
    }
  },
  {
    title = function() return localize("nacho_pokemon5") end,
    tiles = {
      { list = { 'j_nacho_terapagos', 'j_nacho_terapagos_terastal', 'j_nacho_terapagos_stellar' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_terapagos" } end, config_key = "terapagos" },
    }
  },
}

-- Adding in the Cross-Mod joker pages
pages[#pages+1] = { title = function() return localize("nacho_crossMod") end, tiles = {} }

pages[#pages].tiles[#pages[#pages].tiles+1] =
  { list = { 'j_nacho_hisuian_sneasel', 'j_nacho_sneasler' }, label = function() return "Hisuian Sneasel" end,
    config_key = "hisuian_sneasel", condition = (SMODS.Mods["ToxicStall"] or {}).can_load or false, mod_tVal = "The Toxic Stall" }
pages[#pages].tiles[#pages[#pages].tiles+1] =
  { list = { 'j_nacho_okidogi', 'j_nacho_munkidori', 'j_nacho_fezandipiti' }, label = function() return "Loyal Three" end,
      config_key = "loyal_three", condition = (SMODS.Mods["ToxicStall"] or {}).can_load or false, mod_tVal = "The Toxic Stall" }
pages[#pages].tiles[#pages[#pages].tiles+1] =
  { list = { 'j_nacho_pecharunt' }, label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_pecharunt" } end,
    config_key = "pecharunt", condition = (SMODS.Mods["ToxicStall"] or {}).can_load or false, mod_tVal = "The Toxic Stall" }

-- Legacy content page (which is really just bagon lmao)
pages[#pages+1] = { title = function() return "Legacy Content" end, tiles = {} }

pages[#pages].tiles[#pages[#pages].tiles+1] =
  { list = { 'j_nacho_bagon', 'j_nacho_shelgon', 'j_nacho_salamence', 'j_nacho_mega_salamence' },
    label = function() return localize { type = "name_text", set = "Joker", key = "j_nacho_bagon" } end,
    config_key = "bagon", condition = pokermon_config.pokemon_legacy, mod_tVal = "Pokermon (Legacy Content)" }

return {
  pages = pages
}

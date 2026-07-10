-- list of all joker keys with a config tile
local list = PkmnDip.list
local pages = {}
local pageOpts = math.ceil(#list / 6)
local startIndex = 0

local function parse_name(str)
  return str:gsub('(%l)(%u)', '%1 %2')
end

local joker_name_wrapper = function(name)
  local func = function() 
    return parse_name(localize({ type = "name_text", set = "Joker", key = name }))
  end
  return func
end

for i = 1, pageOpts do
  SMODS.process_loc_text(G.localization.misc.dictionary, 'nacho_pokemon'..i, "Pokemon "..i.."/"..pageOpts)
  local page = {
    title = function() return localize('nacho_pokemon'..i) end,
    tiles = {}
  }
  for j = 1, 6 do
    local index = startIndex + j
    if not list[index] then break end
    local config_name = list[index].list[1]
    table.insert(page.tiles,
      {
        label = joker_name_wrapper(config_name),
        list = list[index].list,
        config_key = list[index].config_key
      }
    )
  end
  startIndex = startIndex + 6
  pages[#pages+1] = page
end

-- Adding the Mega joker page(s)
local mega = {
  title = function() return localize("nacho_pokemonMega") end,
  tiles = {}
}

mega.tiles[#mega.tiles+1] = {
  label = function() return "Other Megas" end,
  list = { 'j_poke_mega_gardevoir', 'j_poke_mega_gallade', 'j_poke_mega_altaria' },
  config_key = "other_megas"
}

pages[#pages+1] = mega

-- Adding in the Cross-Mod joker page(s)
local crossMod = {
  title = function() return localize("nacho_crossMod") end,
  tiles = {}
}

crossMod.tiles[#crossMod.tiles + 1] = {
  label = joker_name_wrapper('j_nacho_hisuian_sneasel'),
  list = { 'j_nacho_hisuian_sneasel', 'j_nacho_sneasler' },
  config_key = "hisuian_sneasel",
  condition = (SMODS.Mods["ToxicStall"] or {}).can_load or false,
  mod_tVal = "The Toxic Stall"
}
crossMod.tiles[#crossMod.tiles + 1] = {
  label = function() return "Loyal Three" end,
  list = { 'j_nacho_okidogi', 'j_nacho_munkidori', 'j_nacho_fezandipiti' },
  config_key = "loyal_three",
  condition = (SMODS.Mods["ToxicStall"] or {}).can_load or false,
  mod_tVal = "The Toxic Stall"
}
crossMod.tiles[#crossMod.tiles + 1] = {
  label = joker_name_wrapper('j_nacho_pecharunt'),
  list = { 'j_nacho_pecharunt' },
  config_key = "pecharunt",
  condition = (SMODS.Mods["ToxicStall"] or {}).can_load or false,
  mod_tVal = "The Toxic Stall"
}

pages[#pages+1] = crossMod

return {
  pages = pages
}

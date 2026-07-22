PkmnDip = {
  config = SMODS.current_mod.config,
  config_list = { main = {}}
}

SMODS.current_mod.optional_features = { retrigger_joker = true, quantum_enhancements = true }
if (SMODS.Mods["Pokermon"] or {}).can_load then
  pokermon_config = SMODS.Mods["Pokermon"].config
end

--Load atlases
assert(SMODS.load_file("src/atlases.lua"))()

-- Load functions
local load_directory, item_loader = assert(SMODS.load_file("src/loader.lua"))()

load_directory("src/functions")

--Load pokemon
load_directory("src/pokemon", item_loader.load_pokemon, {
  pre_load = item_loader.prep_config,
  post_load = item_loader.load_pokemon_family
})

-- Load consumables
load_directory("src/consumables", SMODS.Consumable)

--Load packs
load_directory("src/boosters", SMODS.Booster)

--Load tags
load_directory("src/tags", SMODS.Tag)

--Load stickers
load_directory("src/stickers", SMODS.Sticker)

--Load config files
assert(SMODS.load_file("src/settings.lua"))()

--Load challenges files
load_directory("src/challenges", function(a)
  a.button_colour = HEX("E9B800")
  SMODS.Challenge(a)
end)

--Load Joker Display if the mod is enabled
if (SMODS.Mods["JokerDisplay"] or {}).can_load then
  load_directory("jokerdisplay")
end
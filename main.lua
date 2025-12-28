nacho_config = SMODS.current_mod.config
SMODS.current_mod.optional_features = { retrigger_joker = true, quantum_enhancements = true }
if (SMODS.Mods["Pokermon"] or {}).can_load then
    pokermon_config = SMODS.Mods["Pokermon"].config
end

--Load atlases
assert(SMODS.load_file("src/atlases.lua"))()

PkmnDip = {}

-- Load functions
local load_directory, item_loader = assert(SMODS.load_file("src/loader.lua"))()

load_directory("src/functions")

--Load pokemon
load_directory("src/pokemon", item_loader.load_pokemon, { post_load = item_loader.load_pokemon_family })

-- Load consumables
load_directory("src/consumables", function(a) SMODS.Consumable(a) end)

--Load stakes
load_directory("src/stakes", function(a) SMODS.Stake(a) end)

--Load stickers
load_directory("src/stickers", function(a) SMODS.Sticker(a) end)

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

PkmnDip.utils.hook_before_function(SMODS.current_mod, 'reset_game_globals', function(run_start)
  if run_start then
    for _, center in pairs(G.P_CENTERS) do
      if center.nacho_config_key and not nacho_config[center.nacho_config_key] then
        G.GAME.banned_keys[center.key] = true
      end
    end
  end
end)
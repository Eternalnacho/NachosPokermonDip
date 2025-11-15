nacho_config = SMODS.current_mod.config
SMODS.current_mod.optional_features = { retrigger_joker = true, quantum_enhancements = true, post_trigger = true }
nacho_mod_dir = ''..SMODS.current_mod.path
if (SMODS.Mods["Pokermon"] or {}).can_load then
    pokermon_config = SMODS.Mods["Pokermon"].config
end

--Load Joker Display if the mod is enabled
if (SMODS.Mods["JokerDisplay"] or {}).can_load then
  local jokerdisplays = NFS.getDirectoryItems(nacho_mod_dir.."jokerdisplay")

  for _, file in ipairs(jokerdisplays) do
    sendDebugMessage ("The file is: "..file)
    local helper, load_error = SMODS.load_file("jokerdisplay/"..file)
    if load_error then
      sendDebugMessage ("The error is: "..load_error)
    else
      helper()
    end
  end
end

-- This is here for the Dex Order config
PkmnDip = {}
PkmnDip.dex_order_groups = {}

-- Load functions
assert(SMODS.load_file("src/functions.lua"))()

--Load atlases
assert(SMODS.load_file("src/atlases.lua"))()

--Load pokemon setup file
assert(SMODS.load_file("src/pokemon.lua"))()

-- Load consumables
assert(SMODS.load_file("src/consumables.lua"))()

--Load config tab setup file
assert(SMODS.load_file("src/settings.lua"))()

--Load stakes setup file
assert(SMODS.load_file("src/stakes.lua"))()

--Load stickers setup file
assert(SMODS.load_file("src/stickers.lua"))()

--Load challenges file
assert(SMODS.load_file("src/challenges.lua"))()
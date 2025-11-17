-- Name relevant sprite locations

PokemonSprites["hisuian_sneasel"] = { base = { pos = { x = 4, y = 5 } }, gen_atlas = 2 }
PokemonSprites["mega_gardevoir"] = { base = { pos = { x = 6, y = 4 }, soul_pos = { x = 7, y = 4 } }, gen_atlas = 3 }
PokemonSprites["mega_altaria"] = { base = { pos = { x = 2, y = 6 }, soul_pos = { x = 3, y = 6 } }, gen_atlas = 3 }
PokemonSprites["mega_salamence"] = { base = { pos = { x = 8, y = 6 }, soul_pos = { x = 9, y = 6 } }, gen_atlas = 3 }
PokemonSprites["mega_abomasnow"] = { base = { pos = { x = 10, y = 6 }, soul_pos = { x = 11, y = 6 } }, gen_atlas = 4 }
PokemonSprites["mega_gallade"] = { base = { pos = { x = 0, y = 7 }, soul_pos = { x = 1, y = 7 } }, gen_atlas = 4 }
PokemonSprites["mega_audino"] = { base = { pos = { x = 6, y = 7 }, soul_pos = { x = 7, y = 7 } }, gen_atlas = 5 }
PokemonSprites["galarian_meowth"] = { base = { pos = { x = 8, y = 4 } }, gen_atlas = 1 }
PokemonSprites["hisuian_zorua"] = { base = { pos = { x = 0, y = 9 }, soul_pos = { x = 99, y = 99 } }, gen_atlas = 5 }
PokemonSprites["hisuian_zoroark"] = { base = { pos = { x = 2, y = 9 }, soul_pos = { x = 99, y = 99 } }, gen_atlas = 5 }
PokemonSprites["hisuian_sliggoo"] = { base = { pos = { x = 0, y = 12 } }, gen_atlas = 6 }
PokemonSprites["hisuian_goodra"] = { base = { pos = { x = 2, y = 12 } }, gen_atlas = 6 }
PokemonSprites["terapagos"] = { base = { pos = { x = 0, y = 6 }, soul_pos = { x = 1, y = 6 } }, gen_atlas = 9 }
PokemonSprites["terapagos_terastal"] = { base = { pos = { x = 2, y = 6 }, soul_pos = { x = 3, y = 6 } }, gen_atlas = 9 }

-- load pokemon folder

local subdir = "src/pokemon/"

local function load_pokemon(item)
  local custom_atlas = item.atlas and string.find(item.atlas, "nacho")

  if not item.atlas then
    poke_load_atlas(item)
    poke_load_sprites(item)
  end

  pokermon.Pokemon(item, "nacho", custom_atlas)
end

local function load_pokemon_folder(folder)
  local files = NFS.getDirectoryItems(SMODS.current_mod.path .. folder)

  for _, filename in ipairs(files) do
    local file_path = SMODS.current_mod.path .. folder .. filename
    local file_type = NFS.getInfo(file_path).type

    if file_type ~= "directory" and file_type ~= "symlink" then
      local poke = assert(SMODS.load_file(folder .. filename))()

      -- init contains functions for disabling conflicts from other mods et al so we skip when loading shells
      if poke.init and poke.enabled then
        poke:init()
      end

      local family = {}
      local orderlist = {}

      if poke.list and #poke.list > 0 then
        for _, item in ipairs(poke.list) do
          family[#family + 1] = item.name
          orderlist[#orderlist+1] = item.name

          if poke.enabled then
            load_pokemon(item)
          end
        end
      end

      if #family > 1 then
        pokermon.add_family(family)
      end
      
      if #orderlist > 0 then
        PkmnDip.dex_order_groups[#PkmnDip.dex_order_groups+1] = orderlist
      end
    end
  end
end

load_pokemon_folder(subdir)

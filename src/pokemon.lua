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

      if #family > 1 and not poke.find_family then
        pokermon.add_family(family)
      end
      
      if #orderlist > 0 then
        PkmnDip.dex_order_groups[#PkmnDip.dex_order_groups+1] = orderlist
      end
    end
  end
end

load_pokemon_folder(subdir)

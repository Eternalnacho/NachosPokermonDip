local function load_file(file, load_item)
  if file.init then
    file.init()
  end
  if file.list then
    for _, item in ipairs(file.list) do
      if file.config_key then
        item.nacho_config_key = file.config_key
        if not PkmnDip.config[item.nacho_config_key] then
          item.no_collection = true
        end
      end
      load_item(item)
    end
  end
end

local function load_directory(path, load_item, options)
  options = options or {}
  local files = NFS.getDirectoryItems(SMODS.current_mod.path .. path)

  for _, file_path in ipairs(files) do
    local file_type = NFS.getInfo(SMODS.current_mod.path .. path .. '/' .. file_path).type

    if file_type == "directory" then
      load_directory(path .. '/' .. file_path, load_item, options)
    elseif file_type ~= "symlink" then
      local file = assert(SMODS.load_file(path .. '/' .. file_path))()

      if type(file) == 'table' then
        if file.can_load ~= false then
          if options.pre_load then options.pre_load(file) end
          load_file(file, load_item)
          if options.post_load then options.post_load(file) end
        end
      end
    end
  end
end

local function load_sleeves(file)
  if (SMODS.Mods['CardSleeves'] or {}).can_load and CardSleeves
      and file.sleeves and #file.sleeves > 0 then
    for _, sleeve in ipairs(file.sleeves) do
      CardSleeves.Sleeve(sleeve)
    end
  end
end

local function load_pokemon(item)
  local custom_prefix = item.nacho_inject_prefix or "nacho"
  local custom_atlas = item.atlas and string.find(item.atlas, "nacho")
  if not item.atlas then
    pokermon.sprites.load_atlas(item)
    pokermon.sprites.load_sprites(item)
  end
  if item.nacho_starter then item.starter = PkmnDip.config[item.name] end
  if item.nacho_pseudol then item.pseudol = PkmnDip.config[item.name] end
  pokermon.Pokemon(item, custom_prefix, custom_atlas)
end

local load_pokemon_ref = pokermon.load_pokemon
function pokermon.load_pokemon(item)
  if item.nacho_inject_prefix then
    item.key = item.nacho_inject_prefix .. '_' .. item.name
    item.prefix_config = item.prefix_config or {}
    item.prefix_config.key = { mod = false }
  end
  return load_pokemon_ref(item)
end

local function load_pokemon_family(file)
  local names = PkmnDip.utils.map_list(file.list, function(a) return a.name end)
  if file.family and #file.family > 1 then
    pokermon.add_family(file.family)
  elseif #names > 1 then
    pokermon.add_family(names)
  end
end

local function prep_config(file)
  if file.list then
    local list = PkmnDip.utils.map_list(file.list, function(item)
      local custom_prefix = item.nacho_inject_prefix or "nacho"
      return 'j_' .. custom_prefix .. '_' .. (item.key or item.name)
    end)
    if file.misc_config then
      PkmnDip.config_list[file.misc_config] = PkmnDip.config_list[file.misc_config] or {}
      if file.misc_config.misc_config == 'megas' then
      elseif file.misc_config.misc_config == 'gmax' then
        file.mod_req = 'Agarmons'
      else
        file.mod_req = file.misc_config
      end
    end
    table.insert(PkmnDip.config_list[(file.misc_config or "main")], {
      list = list,
      label = file.label,
      config_key = file.config_key,
      mod_req = file.mod_req
    })
  end
end

return load_directory, {
  load_sleeves = load_sleeves,
  load_pokemon = load_pokemon,
  load_pokemon_family = load_pokemon_family,
  prep_config = prep_config,
}

local pages = {}

local function parse_name(str)
  return str:gsub('(%l)(%u)', '%1 %2')
end

local joker_name_wrapper = function(name)
  local func = function()
    local loc_entry = localize({ type = "name_text", set = "Joker", key = name })
    return parse_name(loc_entry)
  end
  return func
end

local populate_pages = function(list, loc_entry, header)
  local pageOpts = math.ceil(#list / 6)
  local startIndex = 0
  for i = 1, pageOpts do
    SMODS.process_loc_text(G.localization.misc.dictionary, loc_entry..i, header.." "..i.."/"..pageOpts)
    local page = {
      title = function() return localize(loc_entry..i) end,
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
          config_key = list[index].config_key,
          mod_req = list[index].mod_req
        }
      )
    end
    startIndex = startIndex + 6
    pages[#pages+1] = page
  end
end

-- Adding the regular joker pages
local main_list = PkmnDip.config_list.main
populate_pages(main_list, 'nacho_pokemon', "Pokemon")

-- Adding the Mega joker page(s)
local mega_list = PkmnDip.config_list.megas
populate_pages(mega_list, 'nacho_pokemon_mega', "Mega Pokemon")

-- Adding the Gmax joker page(s)
if next(SMODS.find_mod("Agarmons")) then
  SMODS.process_loc_text(G.localization.misc.dictionary, 'nacho_pokemon_gmax'..'1', "Gigantamax Pokemon")
  pages[#pages+1] = {
    title = function() return localize('nacho_pokemon_gmax'..'1') end,
    tiles = {
      {
        label = function() return "Apples" end,
        list = {'j_nacho_gmax_flapple', 'j_nacho_gmax_appletun'},
        config_key = 'gmax_apples',
        mod_req = 'Agarmons'
      }
    }
  }
end

-- Adding in the Cross-Mod joker page(s)
local cross_list = {}
for k, v in pairs(PkmnDip.config_list) do
  if k ~= "main" and k ~= "megas" and k ~= "gmax" then
    PkmnDip.utils.append(cross_list, v)
  end
end
populate_pages(cross_list, 'nacho_crossmod', "Cross-Mod Pokemon")

return {
  pages = pages
}

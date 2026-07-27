local tile_colour_enabled = G.C.GREY
local tile_colour_disabled = mix_colours(G.C.GREY, G.C.UI.BACKGROUND_INACTIVE, 0.3)
local text_colour_enabled = G.C.WHITE
local text_colour_disabled = G.C.UI.TEXT_INACTIVE
local backdrop_colour_enabled = mix_colours(G.C.GREY, G.C.BLACK, 0.3)
local backdrop_colour_disabled = mix_colours(G.C.UI.BACKGROUND_INACTIVE, G.C.BLACK, 0.3)
local outline_colour_enabled = mix_colours(tile_colour_enabled, G.C.BLACK, 0.5)
local outline_colour_disabled = mix_colours(tile_colour_disabled, G.C.BLACK, 0.5)

--

local templates = assert(SMODS.load_file("src/settings/load_templates.lua"))()
local SettingsComponent = PokeDisplayCardComponent:extend()
function SettingsComponent:apply(args)
  for k, v in pairs(args.properties or {}) do
    self.display_card.properties[k] = v
  end
  self.display_card.properties.generate_ui = SMODS.Center.generate_ui
  self.display_card.no_ui = nil
end

--

local function update_centers(config_key, enable)
  for _, center in pairs(G.P_CENTERS) do
    if center.nacho_config_key == config_key then
      center.no_collection = not enable
      if center.nacho_pseudol then center.pseudol = enable end
      if center.nacho_starter then center.starter = enable end
      if center.attach_mega then center:attach_mega() end
      if center.attach_gmax then center:attach_gmax() end
    end
  end
end

function G.FUNCS.toggle_nacho_settings_tile(e)
  e.config.ref_table[e.config.ref_value] = not e.config.ref_table[e.config.ref_value]
  if e.config.condition == false then e.config.ref_table[e.config.ref_value] = false end
  local enabled = e.config.ref_table[e.config.ref_value]

  update_centers(e.config.ref_value, enabled)
  if e.config.callback then e.config.callback(enabled) end

  e.config.colour = enabled and backdrop_colour_enabled or backdrop_colour_disabled
  e.config.outline_colour = enabled and outline_colour_enabled or outline_colour_disabled

  -- change CardArea tile colour
  e.children[1].config.colour = enabled and tile_colour_enabled or tile_colour_disabled

  -- change text colour
  e.children[2].children[1].children[1].config.colour = enabled and text_colour_enabled or text_colour_disabled
end

--

local DipTile = Object:extend()

function DipTile:init(args)
  self.label = args.label or ''
  self.ref_value = args.ref_value
  self.ref_table = args.ref_table
  self.callback = args.callback
  self.mod_req = args.mod_req
  self.display_cards = args.display_cards or {}
  self.cardarea = CardArea(0, 0, G.CARD_W * (2 - 1 / #self.display_cards), G.CARD_H,
    { card_limit = #self.display_cards, type = 'title' })
  for _, key in ipairs(self.display_cards) do
    local template = templates[key]
    local _args = {
      properties = template,
      components = { SettingsComponent() }
    }
    local card = PokeDisplayCard(_args, 0, 0, G.CARD_W, G.CARD_H, { bypass_discovery_center = true })
    card.sticker_run = 'NONE'
    self.cardarea:emplace(card)
  end

  local mod = args.mod_req and SMODS.Mods[self.mod_req]
  if mod then
    self.condition = mod.can_load and not mod.disabled
  end
end

function DipTile:render()
  local enabled = self.ref_table[self.ref_value]
  local mod = self.mod_req and SMODS.Mods[self.mod_req]
  if self.condition == false then enabled = false end

  return {
    n = G.UIT.C,
    config = {
      r = 0.1,
      padding = 0.025,
      emboss = 0.05,
      colour = enabled and backdrop_colour_enabled or backdrop_colour_disabled,
      outline = 1,
      outline_colour = enabled and outline_colour_enabled or outline_colour_disabled,
      button = "toggle_nacho_settings_tile",
      ref_table = self.ref_table,
      ref_value = self.ref_value,
      condition = self.condition,
      callback = self.callback,
      detailed_tooltip = mod and {set = 'Other', key = 'modname_tooltip', vars = { mod.name }},
      hover = true,
    },
    nodes = {
      {
        n = G.UIT.R,
        config = {
          align = "cm",
          r = 0.1,
          minw = G.CARD_W * 2,
          padding = 0.1,
          emboss = 0.1,
          colour = enabled and tile_colour_enabled or tile_colour_disabled,
        },
        nodes = {
          { n = G.UIT.O, config = { object = self.cardarea } },
        }
      },
      {
        n = G.UIT.R,
        config = { align = "cm" },
        nodes = {
          {
            n = G.UIT.C,
            nodes = {
              { n = G.UIT.T, config = { text = self.label, colour = enabled and text_colour_enabled or text_colour_disabled, scale = 0.4, } }
            }
          },
        }
      }
    }
  }
end

return DipTile

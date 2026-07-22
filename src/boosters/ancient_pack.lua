-- Fossil Pack Thingy
local ancient_pack = {
  name = "Ancient Pack",
  key = "ancient_pack",
  group_key = "k_nacho_ancient_pack",
  kind = "Spectral",
  atlas = "nacho_boosters",
  artist = { name = { "Currently a placeholder" } },
  pos = { x = 0, y = 0 },
  config = { extra = 3, choose = 1 },
  cost = 6,
  order = 5,
  weight = 0,
  draw_hand = false,
  ease_background_colour = function(self)
    ease_background_colour{new_colour = HEX('B88F8D'), contrast = 3}
  end,
  create_card = function(self, card)
    return {
      key = SMODS.poll_object({ attributes = {"ancient"} }),
      area = G.pack_cards,
      no_edition = true,
      skip_materialize = true,
    }
  end,
  in_pool = function(self)
    return false
  end,
}

return {
  list = { ancient_pack }
}

-- Wide Gallery Settings
local joker_collection_box = create_UIBox_your_collection_jokers
if nacho_config.gallery_width then
  create_UIBox_your_collection_jokers = function()
    local w = nacho_config.gallery_width * 10 % 10 < 5 and math.floor(nacho_config.gallery_width) or math.ceil(nacho_config.gallery_width)
    return SMODS.card_collection_UIBox(G.P_CENTER_POOLS.Joker, {w,w,w}, {
        no_materialize = true, 
        modify_card = function(card, center) card.sticker = get_joker_win_sticker(center) end,
        h_mod = 0.95,
    })
  end
else
  create_UIBox_your_collection_jokers = joker_collection_box
end

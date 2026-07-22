local fossil_tag = {
	object_type = "Tag",
	name = "fossil_tag",
  atlas = "nacho_tags",
  artist = "Maelmc",
	order = 29,
	pos = { x = 0, y = 0 },
	config = { type = "new_blind_choice" },
	key = "fossil_tag",
  discovered = true,
  min_ante = 2,
	loc_vars = function(self, info_queue)
		info_queue[#info_queue + 1] = { set = "Other", key = "p_nacho_ancient_pack", specific_vars = {1, 3} }
	end,
	apply = function(self, tag, context)
		if context and context.type == "new_blind_choice" then
			tag:yep("+", G.C.SECONDARY_SET.Spectral, function()
				local key = "p_nacho_ancient_pack"
				local card = Card(
					G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
					G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
					G.CARD_W * 1.27,
					G.CARD_H * 1.27,
					G.P_CARDS.empty,
					G.P_CENTERS[key],
					{ bypass_discovery_center = true, bypass_discovery_ui = true }
				)
				card.cost = 0
				card.from_tag = true
				G.FUNCS.use_card({ config = { ref_table = card } })
				card:start_materialize()
				return true
			end)
			tag.triggered = true
			return true
		end
	end,
  in_pool = function(self)
    for _, v in pairs(SMODS.get_attribute_pool("ancient")) do
      if G.GAME.used_jokers[v] then return false end
    end
    return true
  end
}

return {
  list = { fossil_tag }
}
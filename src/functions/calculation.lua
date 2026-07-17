-- calculate most played hand
PkmnDip.calc_most_played_hand = function()
  local hands = PkmnDip.utils.map_list(G.handlist, function(v) return G.GAME.hands[v].visible end)
  local tally = hands[1].played
  table.sort(hands, function(a, b) return G.GAME.hands[a].played > G.GAME.hands[b].played end)
  local ret = {}
  for _, v in ipairs(hands) do 
    if G.GAME.hands[v].played == tally then table.insert(ret, v)
    else break end
  end
  return #hands == 1 and hands[1] or pseudorandom_element(hands, 'handcalc')
end

-- Get most common rank(s) in a list of cards
PkmnDip.get_common_ranks = function(cards)
  local is_rank = function(card, id) return card:get_id() == id and not SMODS.has_no_rank(card) end
  local get_count = function(rank) return #PkmnDip.utils.filter(cards, function(c) return is_rank(c, rank.id) end) end
  local ranks = PkmnDip.utils.map_list(SMODS.Ranks, function(rank) return { rank = rank, count = get_count(rank) } end)
  table.sort(ranks, function(a, b) return a.count > b.count end)
  local ret, tally = {}, ranks[1].count
  for _, v in ipairs(ranks) do
    if v.count == tally then table.insert(ret, v.rank)
    else break end
  end
  return ret
end
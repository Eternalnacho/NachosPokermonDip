PkmnDip.con = {}

PkmnDip.con.has_repeat_effect = function(context)
  return context.repetition and (next(context.card_effects[1]) or #context.card_effects > 1)
end

PkmnDip.con.played_or_held = function(context)
  return (context.cardarea == G.hand or G.play)
end
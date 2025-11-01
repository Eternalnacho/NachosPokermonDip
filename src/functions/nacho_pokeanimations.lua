-- Animation logic stolen completely from https://github.com/MathIsFun0/Aura

NachosAnimatedPokemon = {
   j_nacho_terapagos_stellar = {native = true, frames_per_row = 7, frames = 13, fps = 12, soul = true, soul_size = {x = 108, y = 145}}
}

for k, tbl in pairs(NachosAnimatedPokemon) do
   if not tbl.atlas and tbl.native then
      tbl.atlas = true
      SMODS.Atlas({
         key = k,
         path = k .. ".png",
         px = tbl.size and tbl.size.x or 71,
         py = tbl.size and tbl.size.y or 95,
      })
      SMODS.Atlas({
         key = "shiny_" .. k,
         path = "shiny_" .. k .. ".png",
         px = tbl.size and tbl.size.x or 71,
         py = tbl.size and tbl.size.y or 95,
      })
   end
   if tbl.soul and not tbl.soul_atlas then
      tbl.soul_atlas = true
      SMODS.Atlas({
         key = k .. "_soul",
         path = k .. "_soul.png",
         px = tbl.soul_size and tbl.soul_size.x or tbl.size and tbl.size.x or 71,
         py = tbl.soul_size and tbl.soul_size.y or tbl.size and tbl.size.y or 95,
      })
      SMODS.Atlas({
         key = "shiny_" .. k .. "_soul",
         path = "shiny_" .. k .. "_soul.png",
         px = tbl.soul_size and tbl.soul_size.x or tbl.size and tbl.size.x or 71,
         py = tbl.soul_size and tbl.soul_size.y or tbl.size and tbl.size.y or 95,
      })
   end

   AnimatedPokemon[k] = tbl
end
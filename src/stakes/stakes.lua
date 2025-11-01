local elite = { -- Elite Stake
    key = 'elite_stake',
    applied_stakes = (SMODS.Mods["SonfivesPokermonPlus"] or {}).can_load and {'sonfive_lilac_stake'} or {'gold'},
    above_stake = (SMODS.Mods["SonfivesPokermonPlus"] or {}).can_load and 'sonfive_lilac_stake' or 'gold',
    prefix_config = {
      above_stake = {mod = false},
      applied_stakes = {mod = false}
    },

    modifiers = function()
        G.GAME.win_ante = (G.GAME.win_ante + 2)
        G.GAME.modifiers.elite4 = true
    end,

    pos = {x = 0, y = 0},
    sticker_pos = {x = 0, y = 0},
    atlas = 'stakes',
    sticker_atlas = 'stake_stickers',
    colour = HEX("ba8514"),
    shiny = true
}


list = {}
if nacho_config.customStakes then list[#list+1] = elite end
return {name = "Stakes", list = list}
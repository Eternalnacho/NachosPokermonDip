local sinnoh_adv = {
    object_type = "Challenge",
    key = "sinnoh_adv",
    rules = {
        custom = {
            { id = 'sinnoh_adv' },
        },
    },
    vouchers = {
        {id = "v_overstock_norm"},
    }
}

local hibernation = {
    object_type = "Challenge",
    key = "hibernation",
    jokers = {
        {id = "j_nacho_skwovet", eternal = true},
        {id = "j_poke_munchlax", eternal = true},
    },
    restrictions = {
        banned_cards = {
            { id = 'j_perkeo' },
        }
    },
}

local gems = {
    object_type = "Challenge",
    key = "gems",
    jokers = {
        {id = "j_nacho_carbink", eternal = true},
        {id = "j_poke_goldeen", eternal = true},
        {id = "j_poke_roggenrola"},
        {id = "j_poke_tarountula"},
    },
    rules = {
        custom = {
            { id = 'no_reward' },
            { id = 'no_interest' },
        },
        modifiers = {
            { id = 'dollars',  value = 0 },
        },
    },
}

local goomygoomy = {
    object_type = "Challenge",
    key = "goomygoomy",
    jokers = {
        {id = "j_nacho_goomy", eternal = true},
    },
    consumeables = {
        { id = 'c_poke_metalcoat' },
        { id = 'c_poke_metalcoat' },
    },
    deck = {
        cards = {
            { s = 'S', r = 'A' },
            { s = 'S', r = 'A' },
            { s = 'H', r = 'A' },
            { s = 'H', r = 'A' },
            { s = 'S', r = 'K' },
            { s = 'S', r = 'K' },
            { s = 'H', r = 'K' },
            { s = 'H', r = 'K' },
            { s = 'S', r = 'Q' },
            { s = 'S', r = 'Q' },
            { s = 'H', r = 'Q' },
            { s = 'H', r = 'Q' },
            { s = 'S', r = 'J' },
            { s = 'S', r = 'J' },
            { s = 'H', r = 'J' },
            { s = 'H', r = 'J' },
            { s = 'S', r = 'T' },
            { s = 'S', r = 'T' },
            { s = 'H', r = 'T' },
            { s = 'H', r = 'T' },
            { s = 'S', r = '9' },
            { s = 'S', r = '9' },
            { s = 'H', r = '9' },
            { s = 'H', r = '9' },
            { s = 'S', r = '8' },
            { s = 'S', r = '8' },
            { s = 'H', r = '8' },
            { s = 'H', r = '8' },
            { s = 'S', r = '7' },
            { s = 'S', r = '7' },
            { s = 'H', r = '7' },
            { s = 'H', r = '7' },
            { s = 'S', r = '6' },
            { s = 'S', r = '6' },
            { s = 'H', r = '6' },
            { s = 'H', r = '6' },
            { s = 'S', r = '5' },
            { s = 'S', r = '5' },
            { s = 'H', r = '5' },
            { s = 'H', r = '5' },
            { s = 'S', r = '4' },
            { s = 'S', r = '4' },
            { s = 'H', r = '4' },
            { s = 'H', r = '4' },
            { s = 'S', r = '3' },
            { s = 'S', r = '3' },
            { s = 'H', r = '3' },
            { s = 'H', r = '3' },
            { s = 'S', r = '2' },
            { s = 'S', r = '2' },
            { s = 'H', r = '2' },
            { s = 'H', r = '2' },
        }
    }
}

local list = {}
if nacho_config.piplup and nacho_config.chimchar and nacho_config.turtwig then list[#list+1] = sinnoh_adv end
if nacho_config.skwovet then list[#list+1] = hibernation end
if nacho_config.carbink then list[#list+1] = gems end
if nacho_config.goomy then list[#list+1] = goomygoomy end

return {name = "Challenges",
    list = list
}
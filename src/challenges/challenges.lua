local sinnoh_adv = {
  object_type = "Challenge",
  key = "sinnoh_adv",
  rules = {
    custom = { { id = 'sinnoh_adv' } },
  },
  vouchers = {
    { id = "v_overstock_norm" },
  },
}

local hibernation = {
  object_type = "Challenge",
  key = "hibernation",
  jokers = {
    { id = "j_nacho_skwovet", eternal = true },
    { id = "j_poke_munchlax", eternal = true },
  },
  restrictions = {
    banned_cards = { { id = 'j_perkeo' } },
    banned_tags = {}
  },
}

local gems = {
  object_type = "Challenge",
  key = "gems",
  jokers = {
    { id = "j_nacho_carbink",  eternal = true },
    { id = "j_poke_goldeen",   eternal = true },
    { id = "j_poke_roggenrola" },
    { id = "j_poke_tarountula" },
  },
  rules = {
    custom = {
      { id = 'no_reward' },
      { id = 'no_interest' },
    },
    modifiers = {
      { id = 'dollars', value = 0 },
    },
  },
}

local goomygoomy = {
  key = "goomygoomy",
  jokers = {
    { id = "j_nacho_goomy", eternal = true },
  },
  consumeables = {
    { id = 'c_poke_metalcoat' },
    { id = 'c_poke_metalcoat' },
  },
  deck = {
    cards = {}
  },
}
for _ = 1, 2 do
  for _, val in ipairs { '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A' } do
    goomygoomy.deck.cards[#goomygoomy.deck.cards + 1] = { s = 'S', r = val }
    goomygoomy.deck.cards[#goomygoomy.deck.cards + 1] = { s = 'H', r = val }
  end
end

local list = {}
if PkmnDip.config.piplup and PkmnDip.config.chimchar and PkmnDip.config.turtwig then list[#list + 1] = sinnoh_adv end
if PkmnDip.config.skwovet then list[#list + 1] = hibernation end
if PkmnDip.config.carbink then list[#list + 1] = gems end
if PkmnDip.config.goomy then list[#list + 1] = goomygoomy end

return {
  name = "Challenges",
  list = list
}

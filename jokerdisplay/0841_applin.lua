local jd_def = JokerDisplay.Definitions

-- Flapple
jd_def["j_nacho_flapple"] = {
  text = {
    {
      border_nodes = {
          { text = "X" },
          { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "exp" },
      },
    },
  },
}

-- Appletun
jd_def["j_nacho_appletun"] = {
  text = {
    { text = "+$" },
    { ref_table = "card.ability.extra", ref_value = "money", retrigger_type = "mult" },
  },
  text_config = { colour = G.C.GOLD },
}

-- Hydrapple
jd_def["j_nacho_hydrapple"] = {
  text = {
    {
      border_nodes = {
          { text = "X" },
          { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "exp" },
      },
    },
  },
}
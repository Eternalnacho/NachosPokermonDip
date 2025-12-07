local jd_def = JokerDisplay.Definitions

-- Victini
jd_def["j_nacho_victini"] = {
  text = {
    {
      border_nodes = {
          { text = "X" },
          { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "exp" },
      },
    },
  },
}
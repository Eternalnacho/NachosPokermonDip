local subdir = "src/challenges/"

local pchallenges = NFS.getDirectoryItems(nacho_mod_dir..subdir)
for _, file in ipairs(pchallenges) do
  local challenge, load_error = SMODS.load_file(subdir..file)
  if load_error then
    sendDebugMessage ("The error is: "..load_error)
  else
    local curr_challenge = challenge()
    if curr_challenge.init then curr_challenge:init() end
    
    for i, item in ipairs(curr_challenge.list) do
      item.button_colour = HEX('E9B800')
      SMODS.Challenge(item)
    end
  end
end
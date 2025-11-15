local subdir = "src/stakes/"

local stakes = NFS.getDirectoryItems(nacho_mod_dir..subdir)
for _, file in ipairs(stakes) do
    sendDebugMessage ("The file is: "..file)
    local stakes, load_error = SMODS.load_file(subdir..file)
    if load_error then
        sendDebugMessage ("The error is: "..load_error)
    else
        local curr_stake = stakes()
        if curr_stake.init then curr_stake:init() end

        for i, item in ipairs(curr_stake.list) do
            SMODS.Stake(item)
        end
    end
end
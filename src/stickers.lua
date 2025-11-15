local subdir = "src/stickers/"

local stickers = NFS.getDirectoryItems(nacho_mod_dir..subdir)
for _, file in ipairs(stickers) do
    sendDebugMessage ("The file is: "..file)
    local sticker, load_error = SMODS.load_file(subdir..file)
    if load_error then
        sendDebugMessage ("The error is: "..load_error)
    else
        local curr_sticker = sticker()
        if curr_sticker.init then curr_sticker:init() end
        
        for i, item in ipairs(curr_sticker.list) do
            item.hide_badge = true
            SMODS.Sticker(item)
        end
    end
end
local subdir = "src/consumables/"
local files = NFS.getDirectoryItems(nacho_mod_dir .. subdir)

for _, file in ipairs(files) do
  local consumable = assert(SMODS.load_file(subdir .. file))()

  if consumable.enabled then
    if consumable.list and #consumable.list > 0 then
      for _, item in pairs(consumable.list) do
        SMODS.Consumable(item)
      end
    end
  end
end
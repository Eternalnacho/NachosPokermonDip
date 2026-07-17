-- Event Helper function
function PkmnDip.defer(func, args) 
  if not args then args = {} end
  G.E_MANAGER:add_event(Event({
    trigger = args.trigger or args.delay and 'after',
    delay = args.delay,
    func = function()
      func()
      return true
    end,
    blocking = args.blocking or true,
    blockable = args.blockable or false,
  }))
end

-- Hook Helper functions
local hooks = {
  before = function (table, funcname, hook)
    local orig = table[funcname] or function(...) end
    table[funcname] = function(...) return hook(...) or orig(...) end
  end,
  after = function (table, funcname, hook, prevent_run)
    local orig = table[funcname] or function(...) end
    table[funcname] = function(...)
      local ret = orig(...)
      local h_ret = (not prevent_run or ret) and hook(...)
      return ret or h_ret
    end
  end,
  around = function (table, funcname, hook)
    local orig = table[funcname] or function(...) end
    table[funcname] = function(...) return hook(orig, ...) end
  end,
}
---@alias hook_type
---| "before" # Pre-Call processing
---| "after"  # Post-Call processing
---| "around" # Pre-or-Post-Call processing (requires orig in hook)
---@param hook_type hook_type
---@param table any
---@param funcname string
---@param hook function
---@param prevent_run boolean?
-- Hook Helper function
function PkmnDip.Hook(hook_type, table, funcname, hook, prevent_run)
  if not hook then return end
  if hooks[hook_type] then hooks[hook_type](table, funcname, hook, hook_type == 'after' and prevent_run) end
end
-- Lua filetype settings (overrides options.lua)
-- Spell: ]s/[s (next/prev), z= (suggest), zg (add to dict)
local set = vim.opt_local

set.spell = true
set.shiftwidth = 2  -- Lua convention (matches stylua)

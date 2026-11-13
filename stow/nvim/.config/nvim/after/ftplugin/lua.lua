-- Lua filetype settings (override options.lua; run after Neovim's
-- ftplugin/lua.vim)

local set = vim.opt_local

-- Spell: ]s/[s (next/prev), z= (suggest), zg (add to dict)
set.spell = true

-- formatoptions: ftplugin/lua.vim sets `croql` (no `t`); the FileType autocmd
-- in core/autocmds.lua strips `r`, `o` and `c`, so comments are neither
-- continued nor auto-wrapped. Lua lines here have no length limit (see
-- .stylua.toml) and trailing comments routinely pass 'textwidth'.

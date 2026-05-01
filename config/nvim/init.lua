-- =====================================================================
--  Neovim Init (Clean + Modular)
--  Loads options, keymaps, snippets, and plugin modules from lua/
-- =====================================================================

-- Leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Disable netrw (required for Oil)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Detect nerd font if you use one
vim.g.have_nerd_font = true

-- =====================================================================
--  Core Settings (moved to lua/config/options.lua)
-- =====================================================================
require 'config.options'

-- =====================================================================
--  Keymaps (moved to lua/config/keymaps.lua)
-- =====================================================================
require 'config.keymaps'

-- =====================================================================
--  Snippets (your custom snippets)
-- =====================================================================
require 'config.snippets'

-- =====================================================================
--  Setup lazy.nvim plugin manager
-- =====================================================================
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end

vim.opt.rtp:prepend(lazypath)

-- =====================================================================
--  Load plugins from lua/plugins/*
-- =====================================================================
require('lazy').setup('plugins', {
  change_detection = { notify = false },

  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤',
    },
  },
})

-- ============================================================
-- Transparency
-- ============================================================
local function highlight_transparent()
local groups = { 
    "Normal", "NormalNC", "LineNr", "Folded", "NonText", 
    "SpecialKey", "VertSplit", "SignColumn", "EndOfBuffer",
    "TabLine", "TabLineFill", "StatusLine", "StatusLineNC",
    "WinSeparator", "CursorLineNr" 
}
    for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
    end
end

highlight_transparent()
-- =====================================================================
--  Autocommands (optional: add your own in lua/config/autocmds.lua)
-- =====================================================================
local group = vim.api.nvim_create_augroup('HighlightYank', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  desc = 'Highlight text after yanking',
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Simple, high-performance statusline
function MyStatusLine()
  local parts = {
    "%#StatusLineMode# ",
    vim.fn.mode():upper(), -- Current Mode (NORMAL, INSERT, etc)
    " %#StatusLine# ",
    "%f",                  -- Path to the file
    "%m",                  -- Modified flag [+]
    "%r",                  -- Read-only flag [RO]
    "%=",                  -- Alignment separator (Left | Right)
    "%#StatusLineLSP# ",
    -- Simple LSP Diagnostic count (if LSP is attached)
    (function()
      local count = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR})
      return count > 0 and ("E:" .. count .. " ") or ""
    end)(),
    "%#StatusLine# ",
    "%l:%c ",              -- Line:Column
    "%p%% ",               -- Percentage through file
  }
  return table.concat(parts)
end
-- =====================================================================
--  Modeline
-- =====================================================================
-- vim: ts=2 sts=2 sw=2 et

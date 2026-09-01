-- ==================== Basic Neovim + Lua setup (macOS) ====================

-- 1. Leader key (spacebar will be your shortcut prefix)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2. Basic settings
local o = vim.opt
o.number = true
o.relativenumber = true
o.mouse = "a"
o.clipboard = "unnamedplus" -- macOS system clipboard
o.ignorecase = true
o.smartcase = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.termguicolors = true
o.splitright = true
o.splitbelow = true
o.updatetime = 250

-- 3. Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank({ timeout = 120 }) end,
})

-- 4. Bootstrap plugin manager (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 5. Plugins
require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "Mofiqul/dracula.nvim", name = "dracula", priority = 1000 },
  { "folke/tokyonight.nvim", name = "tokyonight", priority = 1000 },
  { "nvim-lualine/lualine.nvim" },
  { "numToStr/Comment.nvim", opts = {} },
  { "lewis6991/gitsigns.nvim", opts = {} },
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim", tag = "0.1.6", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "neovim/nvim-lspconfig" },

}, {
  ui = { border = "rounded" },
})

-- 6. Colorscheme
pcall(vim.cmd.colorscheme, "catppuccin")

-- 7. Plugin configs
require("lualine").setup({ options = { theme = "auto" } })
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "vim", "bash", "json", "markdown" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- 8. LSP

vim.lsp.enable("gopls")

-- Format Go code when leaving Insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- 9. Keymaps
local map = vim.keymap.set
local opts = { silent = true, noremap = true }

map("n", "<leader>e", ":Ex<CR>", opts) -- open file explorer
map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, opts)
map("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, opts)
map("n", "<leader>fb", function() require("telescope.builtin").buffers() end, opts)
map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, opts)
map("n", "<leader>ww", ":w<CR>", opts)   -- save file
map("n", "<leader>qq", ":qa!<CR>", opts) -- quit all
map({ "n", "v" }, "<leader>y", '"+y', opts)
map("n", "<leader>p", '"+p', opts)


  ----------------------
--- Nvim4humans    ---
----------------------
-- Under Nain license

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.runtimepath:prepend(lazypath)

-- Set leader key
vim.g.mapleader = ' '

require("lazy").setup({
    -- Colorscheme
    { "catppuccin/nvim", name = "catppuccin" },
    -- Status line
    { "nvim-lualine/lualine.nvim", config = function() require("lualine").setup {} end },
    -- File explorer
    { "preservim/nerdtree" },
    -- Mason for managing LSP servers
    { "williamboman/mason.nvim", config = function() require("mason").setup() end },
    -- LSP configuration
    { "neovim/nvim-lspconfig" }, -- Add this line for lspconfig
    -- Git integration
    { "tpope/vim-fugitive" },
    -- Prettier for formatting
    { "sbdchd/neoformat" },
    -- Trouble for diagnostics
    { "folke/trouble.nvim", config = function()
        require("trouble").setup {
            signs = {
                error = "✖",
                warning = "⚠",
                hint = "💡",
                information = "ℹ",
            },
            auto_close = true,
            use_lsp_diagnostic_signs = true,
        }
    end },
})

-- Colorscheme setup
vim.cmd[[colorscheme catppuccin]]
-- Lualine configuration
require('lualine').setup {
    options = { theme = 'catppuccin' }
}

-- Keybindings for Trouble
vim.api.nvim_set_keymap('n', '<leader>xx', ':TroubleToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>xw', ':TroubleNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>xp', ':TroublePrevious<CR>', { noremap = true, silent = true })
-- Keybinding for NERDTree
vim.api.nvim_set_keymap('n', '<leader>e', ':NERDTreeToggle<CR>', { noremap = true, silent = true })

-- Set options
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.showmode = false

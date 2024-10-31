print("Welcome to NV4H!")
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
    -- File explorer (nvim-tree)
    { "kyazdani42/nvim-tree.lua", config = function() require("nvim-tree").setup {} end },
    -- Dashboard
    { "glepnir/dashboard-nvim", config = function()
        require("dashboard").setup({
            theme = "hyper",
            config = {
                week_header = { enable = true },
                center = {
                    { icon = "  ", desc = "Recently opened files", action = "Telescope oldfiles" },
                    { icon = "  ", desc = "Open configuration", action = "edit ~/.config/nvim/init.lua" },
                },
            },
        })
    end },
    -- LSP Config
    { "neovim/nvim-lspconfig", config = function()
        local lspconfig = require("lspconfig")

        -- Using ast-grep for multiple languages
        lspconfig.ast_grep.setup{
            cmd = { "ast-grep", "lsp" },
            filetypes = { "c", "cpp", "javascript", "typescript", "python", "go", "rust", "java", "haskell", "zig", "bash", "ruby", "php" },
        }

        lspconfig.ts_ls.setup{}   -- JavaScript/TypeScript
        lspconfig.pyright.setup{}    -- Python
        lspconfig.clangd.setup{}     -- C and C++
        lspconfig.omnisharp.setup{}  -- C#
        lspconfig.rust_analyzer.setup{} -- Rust
    end },
    -- Autocompletion
    { "hrsh7th/nvim-cmp", dependencies = { 
        "hrsh7th/cmp-nvim-lsp", 
        "hrsh7th/cmp-buffer", 
        "hrsh7th/cmp-path", 
        "hrsh7th/cmp-cmdline", 
        "saadparwaiz1/cmp_luasnip", 
        "L3MON4D3/LuaSnip" 
    }, config = function()
        local cmp = require('cmp')
        cmp.setup {
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)  -- For luasnip users.
                end,
            },
            mapping = {
                ['<C-k>'] = cmp.mapping.select_prev_item(),
                ['<C-j>'] = cmp.mapping.select_next_item(),
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-u>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm { select = true },
            },
            sources = {
                { name = 'nvim_lsp' },
                { name = 'buffer' },
                { name = 'path' },
            },
        }
    end },
   -- Git integration
    { "tpope/vim-fugitive" },
    -- Prettier for formatting
    { "sbdchd/neoformat" },
    -- AI integration
  { "supermaven-inc/supermaven-nvim", config = function()
        require("supermaven-nvim").setup({})
    end },
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

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function()
                if #vim.lsp.get_active_clients() > 0 then
                    require("trouble").toggle()
                end
            end,
        })
    end },
    -- Telescope for fuzzy finding
    { "nvim-telescope/telescope.nvim", requires = { {"nvim-lua/plenary.nvim"} }, config = function()
        require("telescope").setup{}
    end },
    -- Treesitter for improved syntax highlighting
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", config = function()
        require("nvim-treesitter.configs").setup {
            highlight = {
                enable = true,
            },
            ensure_installed = "all",  -- Install all parsers
        }
    end },
})

-- Colorscheme setup
vim.cmd[[colorscheme catppuccin]]
-- Lualine configuration
require('lualine').setup {
    options = { theme = 'catppuccin' }
}

-- Keybindings
vim.api.nvim_set_keymap('n', '<leader>xx', ':TroubleToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>xw', ':TroubleNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>xp', ':TroublePrevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tb', ':Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>th', ':Telescope help_tags<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>to', ':Telescope oldfiles<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tc', ':Telescope colorscheme<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dd', ':Dashboard<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Set options
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.showmode = false

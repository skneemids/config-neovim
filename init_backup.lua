vim.g.maplocalleader = " "
vim.g.mapleader = " " -- Space leader key

-- Bootstrap lazy.nvim if it's not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    { "preservim/nerdtree" },
    { "tikhomirov/vim-glsl" },
    { "dasupradyumna/midnight.nvim", lazy = false, priority = 1000 },
	{
    	"mfussenegger/nvim-jdtls", -- Java LSP support
    	dependencies = { "mfussenegger/nvim-dap" },
	},
    {
        'projekt0n/github-nvim-theme',
        name = 'github-theme',
        lazy = false,
        priority = 1000,
        config = function()
            require('github-theme').setup({})
            vim.cmd('colorscheme github_dark')
        end,
    },

    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "jdtls", "pyright", "ts_ls", "lua_ls", "clangd" },
            })
        end
    },
	{
		"jay-babu/mason-nvim-dap.nvim",
		config = function()
			-- ensure java debug adapter is installed
			require("mason-nvim-dap").setup({
				ensure_installed = { "java-debug-adapter", "java-test" }
			})
		end
	},

    -- Add Telescope plugin
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-u>"] = false,
                            ["<C-d>"] = false,
                        },
                    },
                },
            })
        end
    },

    -- Add Treesitter plugin
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { "c", "lua", "python", "javascript", "java", "html", "css", "bash" },
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "grn",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                    },
                },
            })
        end
    },

    -- Add bufferline plugin
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require("bufferline").setup({
                options = {
                    mode = "buffers",
                    separator_style = "slant",
                    always_show_bufferline = true,
                    diagnostics = "nvim_lsp",
                    show_close_icon = false,
                    show_buffer_close_icons = false,
                },
            })
        end
    },
	{
    'neovim/nvim-lspconfig', -- Core LSP configurations
    config = function()
        local lspconfig = require("lspconfig")
        --local jdtls = require("jdtls")

        -- Enable LSP servers for different languages
        lspconfig.lua_ls.setup({})  -- Lua
		-- lspconfig.tsserver.setup()
        -- lspconfig.clangd.setup({})  -- C/C++
		vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "[C]ode [H]over Documentation" })
		vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "[C]ode goto [D]efinition" })
		-- Set vim motion for <Space> + c + a for display code action suggestions for code diagnostics in both normal and visual mode
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" })
        -- Set vim motion for <Space> + c + r to display references to the code under the cursor
        vim.keymap.set("n", "<leader>cr", require("telescope.builtin").lsp_references, { desc = "[C]ode Goto [R]eferences" })
        -- Set vim motion for <Space> + c + i to display implementations to the code under the cursor
        vim.keymap.set("n", "<leader>ci", require("telescope.builtin").lsp_implementations, { desc = "[C]ode Goto [I]mplementations" })
        -- Set a vim motion for <Space> + c + <Shift>R to smartly rename the code under the cursor
        vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "[C]ode [R]ename" })
        -- Set a vim motion for <Space> + c + <Shift>D to go to where the code/object was declared in the project (class file)
        vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "[C]ode Goto [D]eclaration" })
        -- Java project root detection (checks for .git, build.gradle, pom.xml)
        local root_dir = require("jdtls.setup").find_root({".git", "build.gradle", "pom.xml"})
        if not root_dir then return end -- If root is not detected, don't start jdtls

        local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. vim.fn.fnamemodify(root_dir, ":t")

        -- Configure jdtls
        lspconfig.jdtls.setup({
            cmd = {
                vim.fn.stdpath("data") .. "/mason/packages/jdtls/bin/jdtls",
                "-configuration", vim.fn.stdpath("data") .. "/mason/packages/jdtls/config_linux",
                "-data", workspace_dir,
            },
            root_dir = root_dir, -- Correct project root
            settings = {
                java = {
                    configuration = {
                        runtimes = {
                            {
                                name = "JavaSE-21",
                                path = "/opt/java/jdk-21/",
                            },
                        },
                    },
                },
            },
            init_options = {
                workspaceFolders = { root_dir },
                extendedClientCapabilities = jdtls.extendedClientCapabilities,
            },
        })

        -- Configure diagnostic signs (squiggly lines, icons, etc.)
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            update_in_insert = false,
        })
    end
}

	

})

-- Colorscheme settings
vim.cmd("colorscheme midnight")

-- Set editor options
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Background transparency
vim.cmd [[
    highlight Normal guibg=NONE ctermbg=NONE
    highlight NonText guibg=NONE ctermbg=NONE
]]

-- Enable syntax highlighting
vim.cmd('syntax enable')

-- Make NERDTree background transparent
vim.cmd([[
    highlight NERDTreeNormal guibg=NONE ctermbg=NONE
]])

-- Load Java syntax file
vim.cmd("source ~/.config/nvim/syntax/java.vim")

-- Create :Nt command to open NERDTree
vim.api.nvim_create_user_command("Nt", "NERDTreeToggle", {})

-- Create :Ts command to open Telescope Treesitter
vim.api.nvim_create_user_command("Ts", "Telescope treesitter", {})

-- Keybindings
vim.api.nvim_set_keymap("n", "<leader>n", ":NERDTreeToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>t", ":Telescope treesitter<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>h", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true }) -- Previous buffer
vim.api.nvim_set_keymap("n", "<leader>l", ":BufferLineCycleNext<CR>", { noremap = true, silent = true }) -- Next buffer

--require("config.lsp")

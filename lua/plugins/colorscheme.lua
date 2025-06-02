return {
    -- Shortened Github Url
    "dasupradyumna/midnight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        -- Make sure to set the color scheme when neovim loads and configures the dracula plugin
        vim.cmd.colorscheme "midnight"
    end
}

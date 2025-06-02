return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers", -- or "tabs" if you prefer real tabs
        diagnostics = "nvim_lsp",
        separator_style = "slant", -- "slant", "padded_slant", "thin", "thick"
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    })
  end,
}


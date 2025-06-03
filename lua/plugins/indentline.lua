return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl", -- required for v3+
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("ibl").setup({
      indent = {
        char = "│", -- you can also use "▏", "¦", "┊", etc.
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = true,
      },
    })
  end,
}


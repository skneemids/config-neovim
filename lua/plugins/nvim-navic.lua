return {
  "SmiteshP/nvim-navic",
  dependencies = { "neovim/nvim-lspconfig" }, -- Ensure LSP is loaded first
  config = function()
    require("nvim-navic").setup({
      icons = {
        File = " ",
        Module = " ",
        Namespace = " ",
        Package = " ",
        Class = " ",
        Method = " ",
        Property = " ",
        Field = " ",
        Constructor = " ",
        Enum = " ",
        Interface = " ",
        Function = " ",
        Variable = " ",
        Constant = " ",
        String = " ",
        Number = " ",
        Boolean = " ",
        Array = " ",
        Object = " ",
        Key = " ",
        Null = " ",
        EnumMember = " ",
        Struct = " ",
        Event = " ",
        Operator = " ",
        TypeParameter = " "
      },
      highlight = true,
      separator = " > ", -- Customize breadcrumb separator
      depth_limit = 3, -- Limit breadcrumb depth
    })
  end
}


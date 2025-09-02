return {
  {
    "ellisonleao/gruvbox.nvim",
    config = function()
      require("gruvbox").setup({
        transparent_mode = true, -- Enables transparent background
        overrides = {
          Normal = { bg = "NONE" }, -- Ensure main background is transparent
          NormalFloat = { bg = "NONE" }, -- Transparent floating windows (e.g., popups)
          SignColumn = { bg = "NONE" }, -- Transparent sign column
          FoldColumn = { bg = "NONE" }, -- Transparent fold column
          -- Add other highlight groups if needed
        },
      })
      vim.cmd("colorscheme gruvbox")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}

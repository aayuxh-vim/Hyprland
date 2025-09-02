-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.keymap.set({ "i", "v", "n", "c" }, "<Tab>q", "<Esc>", { noremap = true })
vim.keymap.set("n", "<leader>z", ":ToggleTerm direction=horizontal<CR>", { desc = "Open horizontal terminal" })

-- Terminal Mapping
vim.keymap.set("n", "<leader>t", ":botright split term://zsh<CR>", { noremap = true })
vim.keymap.set("n", "<leader>T", ":botright 10split term://zsh<CR>", { noremap = true })
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.cmd("startinsert")
  end,
})
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

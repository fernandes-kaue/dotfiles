-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Insert mode: Map 'jk' to exit insert mode rapidly without reaching for Escape
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

vim.keymap.set("n", "<leader>cE", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.fixAll.eslint" },
      diagnostics = {},
    },
  })
end, { desc = "ESLint Fix All" })

vim.keymap.set("n", "<leader>cO", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.organizeImports" },
      diagnostics = {},
    },
  })
end, { desc = "Organize Imports" })

vim.keymap.set("n", "<leader>fd", function()
  Snacks.picker.files({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "Find Files (buffer dir)" })

vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Workspace Diagnostics" })

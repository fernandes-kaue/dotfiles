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

vim.keymap.set("n", "<leader>fC", function()
  Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Neovim Config" })

vim.keymap.set("n", "<leader>ez", "<cmd>edit ~/.config/zsh/aliases.zsh<cr>", { desc = "Edit Zsh Aliases" })
vim.keymap.set("n", "<leader>eZ", "<cmd>edit ~/.zshrc<cr>", { desc = "Edit Zshrc" })
vim.keymap.set("n", "<leader>eg", "<cmd>edit ~/.config/ghostty/config.ghostty<cr>", { desc = "Edit Ghostty Config" })
vim.keymap.set("n", "<leader>ek", "<cmd>edit ~/.config/kitty/kitty.conf<cr>", { desc = "Edit Kitty Config" })
vim.keymap.set("n", "<leader>en", "<cmd>edit ~/.config/nvim/init.lua<cr>", { desc = "Edit Neovim Init" })

vim.keymap.set("n", "<leader>sB", function()
  Snacks.picker.grep_buffers()
end, { desc = "Grep Open Buffers" })

vim.keymap.set("n", "<leader>sg", function()
  Snacks.picker.grep()
end, { desc = "Grep" })

vim.keymap.set({ "n", "x" }, "<leader>sw", function()
  Snacks.picker.grep_word()
end, { desc = "Grep Word/Selection" })

vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "<leader>cL", "<cmd>LspInfo<cr>", { desc = "LSP Info" })
vim.keymap.set("n", "<leader>cR", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Workspace Diagnostics" })
vim.keymap.set("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })

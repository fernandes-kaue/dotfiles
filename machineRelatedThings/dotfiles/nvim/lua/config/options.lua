-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.lazyvim_php_lsp = "intelephense"
vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_eslint_auto_format = true

vim.filetype.add({
  filename = {
    [".env"] = "sh",
    [".env.local"] = "sh",
    [".env.development"] = "sh",
    [".env.production"] = "sh",
    [".env.test"] = "sh",
  },
  pattern = {
    ["%.env%.[%w_.-]+"] = "sh",
  },
})

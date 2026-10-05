-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local augroup = vim.api.nvim_create_augroup("local_performance", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "bigfile",
  callback = function(args)
    vim.b[args.buf].minihipatterns_disable = true
    vim.b[args.buf].minianimate_disable = true
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})

vim.api.nvim_create_autocmd("BufReadPre", {
  group = augroup,
  callback = function(args)
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > 1024 * 1024 then
      vim.b[args.buf].minianimate_disable = true
    end
  end,
})

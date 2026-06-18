local M = {}

local tools = {
  cli = {
    "node",
    "npm",
    "php",
    "composer",
    "docker",
    "rg",
    "fd",
    "git",
  },
  mason = {
    "bash-language-server",
    "biome",
    "docker-compose-language-service",
    "dockerfile-language-server",
    "eslint-lsp",
    "hadolint",
    "intelephense",
    "js-debug-adapter",
    "php-cs-fixer",
    "php-debug-adapter",
    "phpcs",
    "prettier",
    "prisma-language-server",
    "shellcheck",
    "sqlls",
    "sqlfluff",
    "taplo",
    "yaml-language-server",
  },
}

local function ok_line(label, ok, detail)
  local icon = ok and "OK" or "MISS"
  return string.format("%-4s %-28s %s", icon, label, detail or "")
end

local function executable(name)
  local path = vim.fn.exepath(name)
  return path ~= "" and path or nil
end

local function mason_package(name)
  local ok, registry = pcall(require, "mason-registry")
  if not ok then
    return nil, "mason-registry unavailable"
  end

  local has_package, package = pcall(registry.get_package, name)
  if not has_package then
    return nil, "unknown package"
  end

  local installed = package:is_installed()
  local detail = installed and "installed" or "not installed"

  if type(package.get_install_path) == "function" then
    detail = package:get_install_path()
  end

  return installed, detail
end

function M.run()
  local lines = { "# DevHealth", "" }

  lines[#lines + 1] = "## CLI"
  for _, tool in ipairs(tools.cli) do
    local path = executable(tool)
    lines[#lines + 1] = ok_line(tool, path ~= nil, path or "not on PATH")
  end

  lines[#lines + 1] = ""
  lines[#lines + 1] = "## Mason"
  for _, tool in ipairs(tools.mason) do
    local installed, detail = mason_package(tool)
    lines[#lines + 1] = ok_line(tool, installed == true, detail)
  end

  lines[#lines + 1] = ""
  lines[#lines + 1] = "## Current Buffer"
  lines[#lines + 1] = ok_line("filetype", vim.bo.filetype ~= "", vim.bo.filetype ~= "" and vim.bo.filetype or "unset")

  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    lines[#lines + 1] = ok_line("lsp clients", false, "none attached")
  else
    for _, client in ipairs(clients) do
      lines[#lines + 1] = ok_line("lsp:" .. client.name, true, client.config.root_dir or "")
    end
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "markdown"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.cmd("vsplit")
  vim.api.nvim_win_set_buf(0, buf)
end

vim.api.nvim_create_user_command("DevHealth", M.run, { desc = "Check local development tools" })

return M

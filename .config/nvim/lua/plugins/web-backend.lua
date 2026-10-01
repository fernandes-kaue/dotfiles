local js_like = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}

local prettier_like = vim.list_extend(vim.deepcopy(js_like), {
  "css",
  "scss",
  "less",
  "html",
  "json",
  "jsonc",
  "yaml",
  "markdown",
  "markdown.mdx",
})

local function buf_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  return name ~= "" and vim.fs.dirname(name) or vim.uv.cwd()
end

local function has_root_file(bufnr, names)
  return #vim.fs.find(names, { path = buf_dir(bufnr), upward = true }) > 0
end

local function js_formatter(bufnr)
  if has_root_file(bufnr, { "biome.json", "biome.jsonc", ".biome.json", ".biome.jsonc" }) then
    return { "biome-check", "prettier", stop_after_first = true }
  end

  return { "prettier", stop_after_first = true }
end

return {
  {
    "mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bash-language-server",
        "biome",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "eslint-lsp",
        "hadolint",
        "intelephense",
        "java-debug-adapter",
        "java-test",
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
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.default_format_opts = vim.tbl_deep_extend("force", opts.default_format_opts or {}, {
        timeout_ms = 5000,
        lsp_format = "fallback",
        stop_after_first = true,
      })

      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(prettier_like) do
        opts.formatters_by_ft[ft] = js_formatter
      end
      opts.formatters_by_ft.php = { "php_cs_fixer" }
      opts.formatters_by_ft.sql = { "sqlfluff", lsp_format = "fallback" }

      opts.formatters = opts.formatters or {}
      opts.formatters.prettier = vim.tbl_deep_extend("force", opts.formatters.prettier or {}, {
        command = function(_, ctx)
          return vim.fs.find("node_modules/.bin/prettier", { path = ctx.dirname, upward = true })[1] or "prettier"
        end,
      })

      opts.formatters["biome-check"] = vim.tbl_deep_extend("force", opts.formatters["biome-check"] or {}, {
        require_cwd = true,
      })

      opts.formatters.sqlfluff = vim.tbl_deep_extend("force", opts.formatters.sqlfluff or {}, {
        args = { "format", "--dialect=ansi", "-" },
      })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = vim.tbl_deep_extend("force", opts.linters_by_ft or {}, {
        bash = { "shellcheck" },
        dockerfile = { "hadolint" },
        sh = { "shellcheck" },
        sql = { "sqlfluff" },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "css",
        "dockerfile",
        "html",
        "http",
        "java",
        "javascript",
        "json",
        "php",
        "prisma",
        "sql",
        "tsx",
        "typescript",
        "yaml",
      })
    end,
  },

  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      opts.adapters["neotest-jest"] = {
        jestCommand = "npm test --",
        env = { CI = true },
        cwd = function(path)
          path = path or vim.api.nvim_buf_get_name(0)
          return vim.fs.root(path, { "package.json", "jest.config.js", "jest.config.ts" }) or vim.uv.cwd()
        end,
      }
      opts.adapters["neotest-vitest"] = {}
    end,
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    keys = {
      {
        "<leader>dn",
        function()
          require("dap").continue({
            type = "pwa-node",
            request = "launch",
            name = "Launch current Node file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          })
        end,
        desc = "Debug Node File",
        ft = js_like,
      },
      {
        "<leader>dN",
        function()
          require("dap").continue({
            type = "pwa-node",
            request = "attach",
            name = "Attach Node Process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          })
        end,
        desc = "Attach Node Process",
        ft = js_like,
      },
    },
  },
}

local js_like = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}

return {
  {
    "mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bash-language-server",
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
      })

      opts.formatters = opts.formatters or {}
      opts.formatters.prettier = vim.tbl_deep_extend("force", opts.formatters.prettier or {}, {
        command = function(_, ctx)
          return vim.fs.find("node_modules/.bin/prettier", { path = ctx.dirname, upward = true })[1] or "prettier"
        end,
      })

      opts.formatters.sqlfluff = vim.tbl_deep_extend("force", opts.formatters.sqlfluff or {}, {
        args = { "format", "--dialect=ansi", "-" },
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
    },
  },
}

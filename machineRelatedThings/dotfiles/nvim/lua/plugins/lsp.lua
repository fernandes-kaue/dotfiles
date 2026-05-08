return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.inlay_hints = vim.tbl_deep_extend("force", opts.inlay_hints or {}, {
        enabled = true,
        exclude = { "vue" },
      })

      opts.codelens = vim.tbl_deep_extend("force", opts.codelens or {}, {
        enabled = true,
      })

      opts.servers = opts.servers or {}

      opts.servers.vtsls = vim.tbl_deep_extend("force", opts.servers.vtsls or {}, {
        settings = {
          complete_function_calls = true,
          vtsls = {
            autoUseWorkspaceTsdk = true,
            experimental = {
              maxInlayHintLength = 40,
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = false },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
        },
      })

      opts.servers.bashls = opts.servers.bashls or {}
      opts.servers.sqlls = opts.servers.sqlls or {}
      opts.servers.intelephense = vim.tbl_deep_extend("force", opts.servers.intelephense or {}, {
        settings = {
          intelephense = {
            files = {
              maxSize = 5000000,
            },
          },
        },
      })
    end,
  },
}

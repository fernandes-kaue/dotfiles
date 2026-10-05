return {
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      {
        "-",
        function()
          require("oil").open()
        end,
        desc = "Open Parent Directory",
      },
      {
        "<leader>fo",
        function()
          require("oil").open()
        end,
        desc = "Oil",
      },
    },
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-p>"] = "actions.preview",
        ["<C-s>"] = "actions.select_split",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-t>"] = "actions.select_tab",
        ["g."] = "actions.toggle_hidden",
      },
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
      },
    },
  },

  {
    "Wansmer/treesj",
    keys = {
      {
        "<leader>j",
        function()
          require("treesj").toggle()
        end,
        desc = "Toggle Split/Join",
      },
      {
        "<leader>J",
        function()
          require("treesj").join()
        end,
        desc = "Join Node",
      },
      {
        "<leader>S",
        function()
          require("treesj").split()
        end,
        desc = "Split Node",
      },
    },
    opts = {
      use_default_keymaps = false,
      max_join_length = 160,
    },
  },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>uU", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" },
    },
    init = function()
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_WindowLayout = 2
    end,
  },
}

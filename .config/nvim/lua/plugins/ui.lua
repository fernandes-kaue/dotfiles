return {
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      smear_insert_mode = true,
      scroll_buffer_space = true,
      stiffness = 0.8,
      trailing_stiffness = 0.6,
      stiffness_insert_mode = 0.7,
      trailing_stiffness_insert_mode = 0.7,
      damping = 0.95,
      damping_insert_mode = 0.95,
      distance_stop_animating = 0.5,
    },
    keys = {
      {
        "<leader>uC",
        function()
          require("smear_cursor").toggle()
        end,
        desc = "Toggle Animated Cursor",
      },
    },
  },
}

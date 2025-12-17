return {
  {
    "LazyVim/LazyVim",
    keys = {
      -- Diff accept all from specific buffer
      { "<leader>da1", ":%diffget 1<CR>:diffupdate<CR>", desc = "Diff: accept all from buffer 1", mode = "n" },
      { "<leader>da2", ":%diffget 2<CR>:diffupdate<CR>", desc = "Diff: accept all from buffer 2", mode = "n" },
      { "<leader>da3", ":%diffget 3<CR>:diffupdate<CR>", desc = "Diff: accept all from buffer 3", mode = "n" },

      -- Diff navigation
      { "<leader>dj", "]c", desc = "Diff: next change", mode = "n" },
      { "<leader>dk", "[c", desc = "Diff: prev change", mode = "n" },

      -- Extra utilities
      { "<leader>du", ":diffupdate<CR>", desc = "Diff: update", mode = "n" },
      { "<leader>do", ":diffget<CR>", desc = "Diff: obtain (current hunk)", mode = "n" },
      { "<leader>dh", ":diffput<CR>", desc = "Diff: put (current hunk)", mode = "n" },
    },
  },
}

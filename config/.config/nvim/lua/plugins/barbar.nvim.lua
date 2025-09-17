return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',         -- Optional: for git status
    'nvim-tree/nvim-web-devicons',     -- Optional: for file icons
  },
  init = function()
    -- Disable auto-setup so manual setup via opts is used
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    animation = true,
    insert_at_start = true,
    -- Add more options if needed
  },
  version = '^1.0.0', -- Only update when a new 1.x version is released
}

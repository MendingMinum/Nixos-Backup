local M = {}

function M.setup()
  local map = vim.keymap.set

  -- Barbar.nvim shortcuts
  map('n', '<C-r>', '<Cmd>BufferNext<CR>',     { desc = 'Next buffer' })
  map('n', '<C-A-r>', '<Cmd>BufferPrevious<CR>', { desc = 'Previous buffer' })
  map('n', '<C-n>', '<Cmd>enew<CR>', { desc = 'New buffer' })
  map('n', '<C-w>', '<Cmd>BufferClose<CR>', { desc = 'Close buffer' })
  map('n', '<C-b>', function()
    if vim.o.showtabline == 0 then
      vim.o.showtabline = 2
    else
      vim.o.showtabline = 0
    end
  end, { desc = 'Toggle tabline' })

  -- Save
  map('n', '<C-s>', '<Cmd>w<CR>', { desc = 'Save file' })
  map('i', '<C-s>', '<Esc><Cmd>w<CR>a', { desc = 'Save file' })

  -- Copy Paste
  map('v', '<C-c>', '"+y', { desc = 'Copy to system clipboard' })
  map('v', '<C-x>', '"+d', { desc = 'Cut to system clipboard' })

  map('n', '<C-v>', '"+p', { desc = 'Paste from system clipboard' })
  map('i', '<C-v>', '<C-r>+', { desc = 'Paste from system clipboard' })

  -- Undo (Ctrl+Z)
  map('n', '<C-z>', 'u', { desc = 'Undo' })
  map('i', '<C-z>', '<Esc>ui', { desc = 'Undo' })

  -- Redo (Ctrl+Shift+Z)
  map('n', '<C-S-z>', '<C-r>', { desc = 'Redo' })
  map('i', '<C-S-z>', '<Esc><C-r>i', { desc = 'Redo' })


end

return M

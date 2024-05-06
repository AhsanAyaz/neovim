
vim.api.nvim_set_keymap('n', '<F9>', '<Cmd>lua OpenTerminalHorizontal()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<F9>', '<Cmd>lua ExitTerminal()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F10>', '<Cmd>lua OpenTerminalVertical()<CR>', { noremap = true, silent = true })
-- Set a variable to keep track of the terminal window's expanded state
-- Globals to track terminal expansion state and dimensions
-- Global toggle state and dimensions
terminal_expanded = true
local max_h_size = 10  -- Maximum size when expanded
local min_h_size = 1  -- Minimum size when collapsed
local max_v_size = 30
local min_v_size = 10

function ToggleTerminalSize()
  local cur_win = vim.api.nvim_get_current_win()
  local cur_buf = vim.api.nvim_win_get_buf(cur_win)
  local buftype = vim.api.nvim_buf_get_option(cur_buf, 'buftype')

  -- Check if the current buffer is a terminal
  if buftype == 'terminal' then
    print("is terminal")
    local win_width = vim.api.nvim_win_get_width(cur_win)
    local win_height = vim.api.nvim_win_get_height(cur_win)
    -- Print the variables win_width and win_height
    vim.cmd('echo "Window width: ' .. win_width .. ', Window height: ' .. win_height .. '"')

    -- Determine if it's vertically or horizontally split by comparing dimensions
    -- This logic assumes a significant difference in dimensions to determine the split type
    if win_width > win_height * 1.5 then  -- Adjust ratio as needed for your specific use-case
      -- More likely a vertical split
      print("is horizontal")
      if terminal_expanded then
        vim.api.nvim_win_set_height(cur_win, min_h_size)
      else
        vim.api.nvim_win_set_height(cur_win, max_h_size)
      end
    elseif win_height > win_width * 1.1 then
      -- More likely a horizontal split
      print("is vertical")
      if terminal_expanded then
        vim.api.nvim_win_set_width(cur_win, min_v_size)
      else
        vim.api.nvim_win_set_width(cur_win, max_v_size)
      end
    else
      print("Unable to determine split orientation")
    end

    terminal_expanded = not terminal_expanded
  else
    print("Not a terminal window")
  end
end



-- Key mapping to toggle the terminal size
vim.api.nvim_set_keymap('n', '<F12>', '<Cmd>lua ToggleTerminalSize()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<F12>', '<Cmd>lua ToggleTerminalSize()<CR>', { noremap = true, silent = true })

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = '*',
  callback = function()
    SetTerminalKeymaps()
  end
})

function OpenTerminalHorizontal()
  local cur_win = vim.api.nvim_get_current_win()
  local cur_buf = vim.api.nvim_win_get_buf(cur_win)
  local buftype = vim.api.nvim_buf_get_option(cur_buf, 'buftype')
  if buftype ~= 'terminal' then
    vim.cmd('split')        -- Open a horizontal split
    vim.cmd('wincmd J')     -- Move the split to the bottom
    vim.cmd('resize 10')    -- Resize the new window to be smaller
    vim.cmd('terminal')     -- Start the terminal
    vim.cmd('startinsert')  -- Begin in insert mode
  else
    ExitTerminal()
  end
end

function OpenTerminalVertical()
  local cur_win = vim.api.nvim_get_current_win()
  local cur_buf = vim.api.nvim_win_get_buf(cur_win)
  local buftype = vim.api.nvim_buf_get_option(cur_buf, 'buftype')
  if buftype ~= 'terminal' then
    vim.cmd('vsplit')       -- Open a vertical split
    vim.cmd('wincmd L')     -- Move the split to the right
    vim.cmd('vertical resize 30')
    vim.cmd('terminal')     -- Start the terminal
    vim.cmd('startinsert')  -- Begin in insert mode
  end
end

function ExitTerminal()
  local exit_command = "exit\n"
  vim.api.nvim_feedkeys(exit_command, 't', false)
  -- Schedule window closure shortly after sending the exit command
  vim.defer_fn(function()
    vim.cmd('q!')
  end, 10) -- waits 10 milliseconds before executing
end


function SetTerminalKeymaps()
  local opts = {noremap = true, silent = true}
  -- Switch back to normal mode without leaving the terminal
  vim.api.nvim_buf_set_keymap(0, 't', '<Esc>', '<C-\\><C-n>', opts)
end

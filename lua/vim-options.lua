vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

vim.api.nvim_set_keymap('n', '<F9>', '<Cmd>lua OpenTerminal()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<F9>', '<Cmd>lua ExitTerminal()<CR>', { noremap = true, silent = true })

function OpenTerminal()
    vim.cmd('split')        -- Open a horizontal split
    vim.cmd('wincmd J')     -- Move the split to the bottom
    vim.cmd('resize 10')    -- Resize the new window to be smaller
    vim.cmd('terminal')     -- Start the terminal
    vim.cmd('startinsert')  -- Begin in insert mode
end

function ExitTerminal()
    local exit_command = "exit\n"
    vim.api.nvim_feedkeys(exit_command, 't', false)
    -- Schedule window closure shortly after sending the exit command
    vim.defer_fn(function()
        vim.cmd('q!')
    end, 10) -- waits 500 milliseconds before executing
end



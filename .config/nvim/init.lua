local set = vim.opt

set.showtabline = 2
set.number = true
set.laststatus = 2
set.colorcolumn = '101'

set.tabstop = 8
set.shiftwidth = 2
set.softtabstop = -1 -- insert mode only: treat shiftwidth # of spaces as a tab
set.expandtab = true

vim.g.mapleader = "\\"


--
-- custom keymaps
--

-- legacy syntax until 0.7 in Debian
-- vim.keymap.set('n', '<leader>R', ':source $MYVIMRC<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>R', ':source $MYVIMRC<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>r', ':registers<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>d', ':nohlsearch<CR>', {noremap = true})


--
-- NERDTree
--

vim.api.nvim_set_keymap('', '<C-n>', ':NERDTreeToggle<CR>', {})


--
-- command-t
--

vim.g.CommandTPreferredImplementation = 'ruby'
vim.cmd [[
  function! LoadCommandT()
    set runtimepath+=$HOME/.local/share/nvim/site/pack/vendor/enter/command-t
    runtime! plugin/command-t.vim
  endfunction

  autocmd VimEnter * call LoadCommandT()
]]

set.wildignore:append('*/node_modules')
set.wildignore:append('*/build')
set.wildignore:append('*/dist')


--
-- coc
--

vim.cmd [[source $HOME/.config/nvim/coc.vim]]



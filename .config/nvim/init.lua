-- Set leader key before any other keymaps
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Your Neovim plugins are managed via git submodules
-- Plugin configurations are set directly in init.lua

-- Plugin build system
local function load_build_state()
  local state_file = vim.fn.stdpath("config") .. "/plugin_build_state.json"
  if vim.fn.empty(vim.fn.glob(state_file)) > 0 then
    return {}
  end
  local content = vim.fn.readfile(state_file)
  return vim.fn.json_decode(table.concat(content, "\n"))
end

local function save_build_state(state)
  local state_file = vim.fn.stdpath("config") .. "/plugin_build_state.json"
  local content = vim.fn.json_encode(state)
  vim.fn.writefile({content}, state_file)
end

local function get_git_hash(plugin_path)
  local current = vim.fn.system(string.format("cd %s && git rev-parse HEAD", plugin_path))
  return string.gsub(current, "%s+", "") -- trim whitespace
end

local function build_plugin(plugin_name)
  local plugin_path = vim.fn.stdpath("config") .. "/pack/plugins/start/" .. plugin_name
  local state = load_build_state()
  
  -- Plugin-specific build commands
  local build_commands = {
    ["coc.nvim"] = function()
      local current_hash = get_git_hash(plugin_path)
      local last_built_hash = state[plugin_name] and state[plugin_name].last_built_hash or ""
      
      if current_hash ~= last_built_hash then
        vim.notify("Building " .. plugin_name .. "...", vim.log.levels.INFO)
        vim.fn.system("cd " .. plugin_path .. " && npm ci")
        
        -- Update build state
        state[plugin_name] = { last_built_hash = current_hash }
        save_build_state(state)
        
        vim.notify(plugin_name .. " built successfully!", vim.log.levels.INFO)
      end
    end,
    ["nvim-treesitter"] = function()
      local current_hash = get_git_hash(plugin_path)
      local last_built_hash = state[plugin_name] and state[plugin_name].last_built_hash or ""

      if current_hash ~= last_built_hash then
        vim.notify("Updating treesitter parsers...", vim.log.levels.INFO)
        
        -- Use the Lua API instead of command
        require('nvim-treesitter.install').update()

        -- Update build state
        state[plugin_name] = { last_built_hash = current_hash }
        save_build_state(state)

        vim.notify("Treesitter parsers update initiated!", vim.log.levels.INFO)
      end
    end
    -- Add more plugins and their build commands here as needed
    -- ["example-plugin"] = function() ... end,
  }

  -- Execute build command if it exists for the plugin
  if build_commands[plugin_name] then
    build_commands[plugin_name]()
  end
end

-- Scan and build all plugins in start directory
local function build_all_plugins()
  local start_path = vim.fn.stdpath("config") .. "/pack/plugins/start"
  local plugins = vim.fn.glob(start_path .. "/*", 0, 1)
  
  for _, plugin_path in ipairs(plugins) do
    local plugin_name = vim.fn.fnamemodify(plugin_path, ":t")
    build_plugin(plugin_name)
  end
end

require('nvim-treesitter.configs').setup({
  ensure_installed = {
    "typescript",
    "javascript",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "bash",
    "markdown",
    "markdown_inline",
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
})

-- Build plugins on startup
build_all_plugins()

-- Colorscheme
require('onedark').setup {
    style = 'deep'
}
require('onedark').load()

-- Basic vim options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Status line configuration
vim.opt.statusline = vim.opt.statusline + "%{coc#status()}%{get(b:,'coc_current_function','')}"


-- Telescope keymaps
vim.keymap.set('n', '<leader>t', require('telescope.builtin').find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Help tags' })

-- Example plugin configurations

-- NERDTree configuration
vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeMinimalUI = 1
vim.keymap.set('n', '<C-n>', ':NERDTreeToggle<CR>', { silent = true })

-- CoC configuration
vim.g.coc_global_extensions = {
  'coc-json',
  'coc-tsserver',
  'coc-prettier'
}

-- Use tab for trigger completion with characters ahead and navigate
local function check_back_space()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
vim.keymap.set("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
vim.keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> auto-select the first completion item
vim.keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Diagnostic navigation
vim.keymap.set("n", "g[", "<Plug>(coc-diagnostic-prev)", {silent = true})
vim.keymap.set("n", "g]", "<Plug>(coc-diagnostic-next)", {silent = true})

-- GoTo code navigation
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", {silent = true})
vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
vim.keymap.set("n", "gI", "<Plug>(coc-implementation)", {silent = true})
vim.keymap.set("n", "gA", "<Plug>(coc-references)", {silent = true})

-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
vim.keymap.set("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

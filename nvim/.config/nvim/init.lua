-------------------- HELPERS -------------------------------
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
--
-------------------- PLUGINS -------------------------------
local plugpath = fn.stdpath('data') .. '/plugged'
local Plug = fn['plug#']
vim.call('plug#begin',plugpath)

Plug 'morhetz/gruvbox'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'preservim/nerdtree'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'neovim/nvim-lspconfig'

--completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'

Plug 'mhinz/vim-startify'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'

Plug 'vimwiki/vimwiki'

Plug 'mfussenegger/nvim-jdtls'

vim.call('plug#end')

-------------------- OPTIONS ------------------------------
local indent = 2
cmd 'colorscheme gruvbox'                             -- Put your favorite colorscheme here
opt('b', 'expandtab', true)                           -- Use spaces instead of tabs
opt('b', 'shiftwidth', indent)                        -- Size of an indent
opt('b', 'smartindent', true)                         -- Insert indents automatically
opt('b', 'tabstop', indent)                           -- Number of spaces tabs count for
opt('o', 'hidden', true)                              -- Enable modified buffers in background
opt('o', 'ignorecase', true)                          -- Ignore case
opt('o', 'joinspaces', false)                         -- No double spaces with join after a dot
opt('o', 'scrolloff', 4 )                             -- Lines of context
opt('o', 'shiftround', true)                          -- Round indent
opt('o', 'sidescrolloff', 8 )                         -- Columns of context
opt('o', 'smartcase', true)                           -- Don't ignore case with capitals
opt('o', 'splitbelow', true)                          -- Put new windows below current
opt('o', 'splitright', true)                          -- Put new windows right of current
opt('o', 'termguicolors', true)                       -- True color support
opt('o', 'wildmode', 'list:longest')                  -- Command-line completion mode
opt('w', 'list', true)                                -- Show some invisible characters (tabs...)
opt('w', 'number', true)                              -- Print line number
opt('w', 'relativenumber', true)                      -- Relative line numbers
opt('w', 'wrap', false)                               -- Disable line wrap
-------------------- MAPPINGS ------------------------------
map('', '<leader>c', '"+y')       -- Copy to clipboard in normal, visual, select and operator modes
map('n', '<leader>tt', '<cmd> lua require"usermod".makeJavaTest()<CR>')

map('n', '<leader>s', ':Startify<CR>')

map('n', '<leader>f', ':NERDTreeToggle<CR>')
map('n', '<leader>ff', ':NERDTreeFind<CR>')
map('n', '<C-p>', "<cmd>lua require'telescope.builtin'.find_files()<CR>")
map('n', '<C-b>', "<cmd>lua require'telescope.builtin'.live_grep()<CR>")

map('n', '<C-l>', '<cmd>noh<CR>')    -- Clear highlights
map('n', '<C-w>t', '<cmd>split term://zsh<CR>')

map('v', '<', '<gv')
map('v', '>', '>gv')

map('n', '<leader>rl', '<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR><cmd>:edit<CR>')

--[[
vim.cmd [[
imap <tab> <Plug>(completion_smart_tab)
imap <s-tab> <Plug>(completion_smart_s_tab)

imap <c-k> <Plug>(completion_prev_source)
imap <c-j> <Plug>(completion_next_source)
]]
-------------------- STARTIFY ---------------------------
g.pastetoggle = '<f5>'
g.startify_bookmarks = {
  {c = '~/.config/nvim/init.lua'},
  {b = '~/.bashrc'},
  {z = '~/.zshrc'}
}
-------------------- TREE-SITTER ---------------------------
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}
-------------------- COMPLETION -----------------------------------
opt('o','completeopt','menuone,noinsert,noselect')
local cmp = require'cmp'
cmp.setup{
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  sources = {
    { name = 'nvim-lsp' },
    { name = 'ultisnips' },
    { name = 'buffer' }
  }
}
---------------------- LSP -----------------------------------
local lspconfig = require'lspconfig'
-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = fn.getenv("HOME") .. '/dev/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/Linux/lua-language-server"

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  on_attach = function()
       require'lspmaps'.on_attach()
     end,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

vim.cmd 'source $HOME/.config/nvim/java-lsp.vim'

lspconfig.lemminx.setup{
    cmd = { "lemminx" },
    on_attach = function()
      require'lspmaps'.on_attach()
    end,
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

lspconfig.yamlls.setup{
  cmd = {"yaml-language-server", "--stdio"},
  filetypes = {"yaml"},
  on_attach = function()
    require'lspmaps'.on_attach()
  end,
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

lspconfig.denols.setup{
  on_attach = function()
    require'lspmaps'.on_attach()
  end,
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

lspconfig.pylsp.setup{
  on_attach = function()
    require'lspmaps'.on_attach()
  end,
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

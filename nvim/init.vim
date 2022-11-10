" setup vim-plug
call plug#begin()

" lsp
Plug 'neovim/nvim-lspconfig', { 'commit': '7429f810f0998688b50cd304a0d25e846513dfc0' }
Plug 'hrsh7th/cmp-nvim-lsp', { 'commit': '78924d1d677b29b3d1fe429864185341724ee5a2' }
Plug 'hrsh7th/cmp-buffer', { 'commit': '3022dbc9166796b644a841a02de8dd1cc1d311fa' }
Plug 'hrsh7th/cmp-path', { 'commit': '91ff86cd9c29299a64f968ebb45846c485725f23' }
Plug 'hrsh7th/cmp-cmdline', { 'commit': 'c66c379915d68fb52ad5ad1195cdd4265a95ef1e' }
Plug 'hrsh7th/nvim-cmp', { 'commit': 'c4dcb1244a8942b8d2bd3c0a441481e12f91cdf1' }
Plug 'quangnguyen30192/cmp-nvim-ultisnips', { 'commit': '21f02b62deb409ce69928a23406076bd0043ddbc' }

" language support
Plug 'SirVer/ultisnips', { 'tag': '3.2' }
Plug 'honza/vim-snippets',  { 'commit': 'b47c2e37237875185d170f32cac67af5ab72f22d' }
Plug 'ray-x/go.nvim'

" ui
Plug 'flazz/vim-colorschemes', { 'commit': 'fd8f122cef604330c96a6a6e434682dbdfb878c9' }
Plug 'airblade/vim-gitgutter', { 'commit': '256702dd1432894b3607d3de6cd660863b331818' }
Plug 'itchyny/lightline.vim', { 'commit': 'a29b8331e1bb36b09bafa30c3aa77e89cdd832b2' }
Plug 'nvim-treesitter/nvim-treesitter', { 'commit': '1942f3554184e9d9dfb90dcc6542047b8f6511f2', 'do': ':TSUpdate'}

" editor features
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator', { 'commit': '9ca5bfe5bd274051b5dd796cc150348afc993b80' }
Plug 'tpope/vim-fugitive'

call plug#end()

" vim settings
set number
set hidden

" Better display for messages
set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes

" whitespace
set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set list                          " Show invisible characters
set backspace=indent,eol,start    " backspace through everything in insert mode

" list chars
set listchars=""
set listchars=tab:\ \             " a tab should display as "  ", trailing whitespace as "."
set listchars+=trail:.            " show trailing spaces as dots
set listchars+=extends:>          " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen
set listchars+=precedes:<         " The character to show in the last column when wrap is
                                  " off and the line continues beyond the left of the screen

" setup lspconfig
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(),
    ['<Down>'] = cmp.mapping.select_next_item(),

    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' }, -- For ultisnips users.
  }, {
    { name = 'buffer' },
  })
})

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'solargraph', 'sorbet' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.gopls.setup{
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = {
        shadow = true,
      },
    },
  },
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = {'dockerfile', 'go', 'gomod', 'json', 'make', 'ruby', 'vim', 'yaml'}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {  },  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

require('go').setup()
EOF

" go.nvim
autocmd BufWritePre *.go :silent! lua require('go.format').goimport()

" setup nvim-cmp
set completeopt=menu,menuone,noselect


" setup lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

set clipboard+=unnamedplus
colorscheme PaperColor

" setup fzf-vim
" bind ctrl+p to open files with fzf
nnoremap <C-p> :Files<Cr>

set runtimepath+=~/.config/nvim/my-snippets

" custom filetype detection
au BufRead,BufNewFile *.yaml.lock		setfiletype yaml

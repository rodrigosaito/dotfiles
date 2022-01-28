" setup vim-plug
call plug#begin()

" lsp
Plug 'neovim/nvim-lspconfig', { 'commit': '0f72e5468e510429d5f14b73c93fb528ead1fdaa' }
Plug 'hrsh7th/cmp-nvim-lsp', { 'commit': '134117299ff9e34adde30a735cd8ca9cf8f3db81' }
Plug 'hrsh7th/cmp-buffer', { 'commit': 'a0fe52489ff6e235d62407f8fa72aef80222040a' }
Plug 'hrsh7th/cmp-path', { 'commit': 'e1a69161703171f5804d311005a73b742fbda123' }
Plug 'hrsh7th/cmp-cmdline', { 'commit': '29ca81a6f0f288e6311b3377d9d9684d22eac2ec' }
Plug 'hrsh7th/nvim-cmp', { 'commit': '4efecf7f5b86949de387e63fa86715bc39f92219' }
Plug 'quangnguyen30192/cmp-nvim-ultisnips', { 'commit': '78a9452d61bc7f1c3aeb33f6011513760f705bdf' }

" language support
Plug 'LnL7/vim-nix', { 'commit': '63b47b39c8d481ebca3092822ca8972e08df769b' }
Plug 'SirVer/ultisnips', { 'tag': '3.2' }
Plug 'honza/vim-snippets', { 'commit': 'cd6d5f975f729bff209140ea6e6961102e29b079' }
Plug 'ray-x/go.nvim'

" ui
Plug 'flazz/vim-colorschemes', { 'commit': 'fd8f122cef604330c96a6a6e434682dbdfb878c9' }
Plug 'airblade/vim-gitgutter', { 'commit': '256702dd1432894b3607d3de6cd660863b331818' }
Plug 'itchyny/lightline.vim', { 'commit': 'a29b8331e1bb36b09bafa30c3aa77e89cdd832b2' }
Plug 'nvim-treesitter/nvim-treesitter', { 'commit': '288ef60edde1b5a49c325b0770bdf999ae648a92', 'do': ':TSUpdate'}

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
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
      }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
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

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
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

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
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
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

set clipboard+=unnamedplus
colorscheme PaperColor

" setup fzf-vim
" bind ctrl+p to open files with fzf
nnoremap <C-p> :Files<Cr>

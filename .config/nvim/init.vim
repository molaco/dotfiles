:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set modifiable

" --- Plugins

call plug#begin()

Plug 'nvim-lualine/lualine.nvim' " Lualine
Plug 'kyazdani42/nvim-web-devicons' " Web Dev Icons
Plug 'folke/tokyonight.nvim', { 'branch': 'main' } " tokyonight theme
Plug 'preservim/nerdtree' " NERDTree
Plug 'mhinz/vim-startify' " Startify Menu
Plug 'nvim-lua/plenary.nvim' " Plenary
Plug 'nvim-telescope/telescope.nvim' " Telescope
Plug 'neovim/nvim-lspconfig' " LSP
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Treesitter
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " fzf
Plug 'romgrk/barbar.nvim' " tabs
Plug 'akinsho/toggleterm.nvim' " toggleterm
Plug 'vimwiki/vimwiki'
Plug 'morhetz/gruvbox' " gruvbox theme

call plug#end()

" --- Lua configuration
lua require('molaco')

" --- colorscheme

let g:gruvbox_bold = 1
let g:gruvbox_transparent_bg = 1 

set termguicolors

colorscheme gruvbox

hi! Normal ctermbg=NONE guibg=NONE

" --- NERDTree

nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.

autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" --- Telescope

nmap <C-P> :Telescope git_files hidden=true <CR>
nmap <C-K> :Telescope live_grep hidden=true <CR>

" --- nvim-cmp

set completeopt=menu,menuone,noselect

" --- fzf

nmap <C-b> :FZF<CR>

" --- Startify

 let g:startify_custom_header =
       \ startify#pad(split(system('figlet -w 100 molaco'), '\n'))

" --- vimwiki

let g:vimwiki_links_space_char = '_'

let g:vimwiki_list = [{
  \ 'path': '~/Documents/vimwiki/',
  \ 'template_path': '~/Documents/vimwiki/templates/',
  \ 'template_default': 'default',
  \ 'template_ext': '.html',
  \ 'path_html': '~/Documents/vimwiki_html/'}]

" function! VimwikiLinkHandler(link)
" 	" exclude ref links to headers
" 	if a:link =~# '.*#.*'
" 		return 0
" 	endif
" 	let buf = bufnr('%')
" 	let link_infos = vimwiki#base#resolve_link(a:link)
" 	if link_infos.filename == ''
" 	  echomsg 'Vimwiki Error: Unable to resolve link!'
" 	  return 0
" 	else
" 	  exe 'edit ' . fnameescape(link_infos.filename)
" 	  exe 'bd' . buf
" 	  return 1
" 	endif
" endfunction

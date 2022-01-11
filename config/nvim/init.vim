" python setting
" 2系のpipがinstallできないため3系で代用
let g:python_host_prog=$PYENV_ROOT.'/versions/neovim2/bin/python'
let g:python3_host_prog=$PYENV_ROOT.'/versions/neovim3/bin/python'

" for dein
if &compatible
  set nocompatible
endif
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#load_toml('~/.config/nvim/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.config/nvim/dein_lazy.toml', {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif
if dein#check_install()
 call dein#install()
endif

" base setting
filetype on
set encoding=utf-8
scriptencoding utf-8
set showcmd
set wildmenu
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smartindent
set number
set showmatch
set backspace=indent,eol,start
set clipboard+=unnamed
" colorscheme elly
let g:monochrome_italic_comments = 1
colorscheme monochrome
set termguicolors
set cursorline
set guifont=Cica:h16
set printfont=Cica:h12
set hidden
set splitbelow
set splitright
set statusline=%f

" backup setting
set noswapfile
set nobackup
set nowrap

" serach settings
set incsearch
set ignorecase
set smartcase

" keymap settings
nmap j gj
nmap k gk
nmap <down> gj
nmap <up> gk
nmap ; :
nmap f *
noremap <S-h>   ^
noremap <S-j>   L
noremap <S-k>   H
nnoremap <S-l>   $
vnoremap <S-l>   $h
tnoremap <Esc> <C-\><C-n>
let mapleader = "\<Space>"
nnoremap <Leader>g :te tig<CR>i

augroup HTMLANDXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

" Search for visually selected text. And you can delete the part by input 'cgn'.
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>N


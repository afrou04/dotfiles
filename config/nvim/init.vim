" python setting
" 2系のpipがinstallできないため3系で代用
let g:python_host_prog=$PYENV_ROOT.'/versions/neovim2/bin/python'
let g:python3_host_prog=$PYENV_ROOT.'/versions/neovim3/bin/python'

let s:dein_base = '/Users/afro/.cache/dein'
let s:dein_src = '/Users/afro/.cache/dein/repos/github.com/Shougo/dein.vim'

" Set Dein source path (required)
let s:dein_src = '/Users/afro/.cache/dein/repos/github.com/Shougo/dein.vim'

" for dein
if &compatible
  set nocompatible
endif
execute 'set runtimepath+=' . s:dein_src
if dein#load_state('~/.cache/dein')
  call dein#begin(s:dein_base)
  call dein#load_toml('~/.config/nvim/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.config/nvim/dein_lazy.toml', {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif
if dein#check_install()
 call dein#install()
endif

let g:coc_global_extensions = [
  \'coc-clangd',
  \'coc-css',
  \'coc-db',
  \'coc-diagnostic',
  \'coc-eslint',
  \'coc-git',
  \'coc-go',
  \'coc-html',
  \'coc-import-cost',
  \'coc-json',
  \'coc-lua',
  \'coc-prettier',
  \'coc-rls',
  \'coc-rust-analyzer',
  \'coc-snippets',
  \'coc-spell-checker',
  \'coc-pairs',
  \'coc-tsserver',
  \'coc-sumneko-lua'
\]


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

augroup HTMLANDXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

" Search for visually selected text. And you can delete the part by input 'cgn'.
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>N

hi! DiffAdd ctermbg=NONE ctermfg=green guibg=#122A20 guifg=#63bf75
hi! DiffChange ctermbg=NONE ctermfg=yellow guibg=#312851 guifg=#62529e
hi! DiffDelete ctermbg=NONE ctermfg=red guibg=#301A1F guifg=#c2425f

" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif

" python setting
" 2系のpipがinstallできないため3系で代用
let g:python_host_prog=$PYENV_ROOT.'/versions/neovim2/bin/python'
let g:python3_host_prog=$PYENV_ROOT.'/versions/neovim3/bin/python'

let s:dein_base = '~/.cache/dein'
let s:dein_src = '~/.cache/dein/repos/github.com/Shougo/dein.vim'

" for dein
if &compatible
  set nocompatible
endif
execute 'set runtimepath+=' . s:dein_src
if dein#load_state('~/.cache/dein')
  call dein#begin(s:dein_base)

  " すべての環境で使うplugin
  call dein#load_toml('~/.config/nvim/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.config/nvim/dein_lazy.toml', {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
 call dein#install()
endif

let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
    call map(s:removed_plugins, "delete(v:val, 'rf')")
    call dein#recache_runtimepath()
endif

" coc-import-costでtsconfigのimportエラーなどが出る場合があるので注意
" @see: https://github.com/wix/import-cost/issues/281#issuecomment-1629997498
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
  \'coc-spell-checker',
  \'coc-pairs',
  \'coc-tsserver',
  \'coc-sumneko-lua',
  \'coc-phpls',
  \'coc-prisma',
  \'coc-restclient',
  \'coc-sql',
  \'coc-vimlsp'
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
set foldmethod=manual
set number
set showmatch
set backspace=indent,eol,start
set clipboard+=unnamed
set termguicolors
set cursorline
set nofoldenable
set belloff=all
" set guifont=Cica:h16
" set printfont=Cica:h12
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
noremap <S-s>   :%s/
noremap <S-h>   ^
noremap <S-j>   L
noremap <S-k>   H
nnoremap <S-l>   $
vnoremap <S-l>   $h
tnoremap <Esc> <C-\><C-n>
inoremap <C-c> <Esc>
let mapleader = "\<Space>"

function! s:manageEditorWidth(...)
  let count = a:1
  let to = a:2

  if exists('g:vscode')
    for i in range(1, count ? count : 1)
      call VSCodeNotify(to ==# 'increase' ? 'workbench.action.increaseViewWidth' : 'workbench.action.decreaseViewWidth')
    endfor
  endif

  if to == 'increase'
    wincmd >
  else
    wincmd <
  endif
endfunction

" window commands
nnoremap > <Cmd>call <SID>manageEditorWidth(v:count,  'increase')<CR>
nnoremap < <Cmd>call <SID>manageEditorWidth(v:count,  'decrease')<CR>

augroup HTMLANDXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

" Search for visually selected text. And you can delete the part by input 'cgn'.
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>N

" Close buffer list but except editing buffer
command! BufCloseList silent! execute "%bd|e#|bd#"

" vim ms間でclipboardを共有する.
" FIXME: 文字化けの対応もしているがやや遅いのでチューニングしたい
" @see: https://zenn.dev/kumavale/scraps/2271c61cbd19ef
if system('uname -a | grep microsoft') != ''
  augroup myYank
    au!
    autocmd TextYankPost * silent! if v:event.operator == 'y' | call system('xsel -bi', @") | endif
  augroup END
endif

command! RemoveCachePlugin :call dein#recache_runtimepath() 


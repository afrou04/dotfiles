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
if !exists('g:vscode')
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
endif

" TODO: diff viewのときにts serverをdisableにする

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
imap <silent> <Esc><BS> <C-\><C-o>:call <SID>deletePreviousWordOrSpace()<CR>
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
noremap S   :%s/
noremap H   ^
noremap J   L
noremap K   H
nnoremap L   $
vnoremap L   $h
tnoremap <Esc> <C-\><C-n>
inoremap <C-c> <Esc>
let mapleader = "\<Space>"

" Cursor/VSCode (VSCode Neovim) 用: LSP/補完/診断はVSCode側へ寄せる
if exists('g:vscode')
  " LSP navigation
  nnoremap <silent> gd <Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>
  nnoremap <silent> gt <Cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<CR>
  nnoremap <silent> gi <Cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>
  nnoremap <silent> gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>

  " Hover / docs (Cocの ? 代替)
  nnoremap <silent> ? <Cmd>call VSCodeNotify('editor.action.showHover')<CR>

  " Code actions / rename / format
  nnoremap <silent> <leader>? <Cmd>call VSCodeNotify('editor.action.quickFix')<CR>
  nnoremap <silent> <S-r> <Cmd>call VSCodeNotify('editor.action.rename')<CR>
  nnoremap <silent> <leader>af <Cmd>call VSCodeNotify('editor.action.quickFix')<CR>

  " Diagnostics
  nnoremap <silent> <C-[> <Cmd>call VSCodeNotify('editor.action.marker.prev')<CR>
  nnoremap <silent> <C-]> <Cmd>call VSCodeNotify('editor.action.marker.next')<CR>
endif

function! s:deletePreviousWordOrSpace()
    if getline('.')[col('.') - 2] =~ '\s'
        normal! vb"_de
    else
        normal! caW
    endif
    " 末尾に強制的に移動
    normal! $
endfunction

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
" if system('uname -a | grep microsoft') != ''
"   augroup myYank
"     au!
"     " y cmdだけに限定することで他のそうさの時に遅くなるのを防ぐ
"     autocmd TextYankPost * silent! if v:event.operator == 'y' | call system('xsel -bi', @") | endif
"   augroup END
" endif
"
" command! RemoveCachePlugin :call dein#recache_runtimepath() 
"

" クリップボードの共有先を接続形態で切り替える
"
" nvim を動かしているマシンと、Ctrl+V を押すマシンが一致するとは限らない。
" SSH 経由の場合 clip.exe や win32yank が書くのは「接続先」の Windows の
" クリップボードなので、手元のマシンには届かない。端末のエスケープシーケンス
" (OSC 52) なら SSH の接続を通って手元まで転送される。
"
" nvim は $SSH_TTY を見て OSC 52 に切り替えてはくれず、明示的な指定が必要
" (runtime/autoload/provider/clipboard.vim の "User opted-in to OSC 52" 分岐)。
" また provider の自動検出は WSL では当てにならない。xsel は $DISPLAY が必要で
" X サーバの無い環境では候補から外れ、clip.exe/powershell を拾う分岐も
" executable('clip') を見るため .exe 付きの WSL では一致しない。結果として
" provider が空になり、clipboard=unnamed の * レジスタごと機能しなくなる。
if !empty($SSH_TTY)
  " OSC 52 の貼り付けは端末へ問い合わせて応答を待つ実装で、応答しない端末では
  " 1 回あたり最大 10 秒フリーズする (runtime/lua/vim/ui/clipboard/osc52.lua の
  " vim.wait(1000) + vim.wait(9000))。clipboard=unnamed のままだと p や dd の
  " たびにこれを踏むため、レジスタ共有を切って p を provider から切り離す。
  " ヤンクした内容は TextYankPost で OSC 52 へ送るので手元のマシンには届く。
  " 逆方向 (手元でコピーしたものを貼る) は端末の貼り付け Ctrl+Shift+V を使う。
  set clipboard-=unnamed
  set clipboard-=unnamedplus
  lua << EOF
    local osc52 = require('vim.ui.clipboard.osc52')
    -- "+y を使ったとき用に provider も定義するが、貼り付けは上記の理由で無効化する
    vim.g.clipboard = {
      name = 'osc52-copy-only',
      copy = { ['+'] = osc52.copy('+'), ['*'] = osc52.copy('*') },
      paste = { ['+'] = function() return {} end, ['*'] = function() return {} end },
    }
    vim.api.nvim_create_autocmd('TextYankPost', {
      group = vim.api.nvim_create_augroup('Osc52Yank', { clear = true }),
      desc = 'ヤンクした内容を OSC 52 で手元のマシンのクリップボードへ送る',
      callback = function()
        -- 削除(d/x)まで送ると意図しない上書きが起きるのでヤンクだけに限定する
        if vim.v.event.operator == 'y' then
          osc52.copy('+')(vim.v.event.regcontents)
        end
      end,
    })
EOF
elseif has('wsl')
  " 接続先のコンソールで直接使う場合は Windows のクリップボードへ書く
  if executable('win32yank.exe')
    let s:wsl_copy  = ['win32yank.exe', '-i', '--crlf']
    let s:wsl_paste = ['win32yank.exe', '-o', '--lf']
  else
    " clip.exe は標準入力のエンコーディングを推測するため、UTF-8 をそのまま渡すと
    " CP932 と誤解釈されて日本語が化ける (「日本語」-> 「譌･譛ｬ隱・)。iconv で
    " UTF-16LE にすると解釈されるが、プロセスやコンソールの状態に左右され確実ではない
    let s:wsl_copy = executable('iconv')
          \ ? ['sh', '-c', 'iconv -f UTF-8 -t UTF-16LE | /mnt/c/Windows/System32/clip.exe']
          \ : ['/mnt/c/Windows/System32/clip.exe']
    " Get-Clipboard は行末に CR を残すため除去する。しないと貼り付けた全行に ^M が付く
    let s:wsl_paste = ['/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe',
          \ '-NoProfile', '-NoLogo', '-Command',
          \ '[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
          \ . ' [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))']
  endif
  " cache_enabled=0: 貼り付けのたびに Windows 側を読み直す。1 にすると nvim が最後に
  " コピーした内容を返すため、Windows でコピーした内容が反映されず元の不具合に戻る
  let g:clipboard = {
        \ 'name': 'WslClipboard',
        \ 'copy':  {'+': s:wsl_copy,  '*': s:wsl_copy},
        \ 'paste': {'+': s:wsl_paste, '*': s:wsl_paste},
        \ 'cache_enabled': 0,
        \ }
endif

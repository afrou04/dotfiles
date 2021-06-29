" base setting
set updatetime=300
set cmdheight=2
set hidden

highlight CocErrorSign guifg=red guibg=0
highlight CocWarningSign guifg=yellow guibg=0

" keymap settings
nmap <silent> <C-[> <Plug>(coc-diagnostic-prev)
nmap <silent> <C-]> <Plug>(coc-diagnostic-next)
nmap <silent> <S-r> <Plug>(coc-refactor)
let mapleader = "\<Space>"
nmap <silent> <Leader>d :call CocAction('jumpDefinition', 'vsplit')<CR>

" GoTo code navigatiton
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>?  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>af  <Plug>(coc-fix-current)

nnoremap <silent> ? :call <SID>show_documentation()<CR>
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr><C-j> pumvisible() ? "\<C-n>" : "\<C-h>"
inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" windowのkey-bindと競合しないように一緒に管理する
nmap <silent><C-k> :TComment<CR>
vmap <silent><C-k> :TComment<CR>

" floating window表示しているときのスクロール処理
nnoremap <nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-u>"
nnoremap <nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-d>"
inoremap <nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-d> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" lsp settings
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

let g:coc_disable_transparent_cursor = 1


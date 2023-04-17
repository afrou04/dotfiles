function! PackagerInit() abort
  packadd vim-packager
  call packager#init()
  call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })
  call packager#add('tpope/vim-dadbod')
  call packager#add('kristijanhusak/vim-dadbod-ui')
endfunction

let g:dbs = {
      \ 'hoge': 'postgresql://postgres:password@localhost:5432/hoge',
      \ }

autocmd FileType dbui nmap <buffer> o <Plug>(DBUI_SelectLine)
autocmd FileType dbui nmap <buffer> <Enter> <Plug>(DBUI_SelectLine)

let g:db_ui_default_query = 'SELECT * FROM "{table}"'


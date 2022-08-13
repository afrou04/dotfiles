function! PackagerInit() abort
  packadd vim-packager
  call packager#init()
  call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })
  call packager#add('tpope/vim-dadbod')
  call packager#add('kristijanhusak/vim-dadbod-ui')
endfunction

let g:dbs = {
      \ 'resily': 'postgresql://postgres:password@localhost:5432/resily',
      \ 'resily-one-on-one': 'postgresql://postgres:password@localhost:5432/one-on-one',
      \ }

autocmd FileType dbui nmap <buffer> o <Plug>(DBUI_SelectLine)
autocmd FileType dbui nmap <buffer> <Enter> <Plug>(DBUI_SelectLine)

let g:db_ui_default_query = 'SELECT * FROM "{table}"'


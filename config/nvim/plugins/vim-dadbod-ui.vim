function! PackagerInit() abort
  packadd vim-packager
  call packager#init()
  call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })
  call packager#add('tpope/vim-dadbod')
  call packager#add('kristijanhusak/vim-dadbod-ui')
endfunction

let g:dbs = {
      \ 'resily': 'postgresql://postgres:password@localhost:5432/resily',
      \ }

autocmd FileType dbui nmap <buffer> o <Plug>(DBUI_SelectLine)

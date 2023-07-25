let g:dbs = {
      \ 'test-db': 'postgresql://postgres:password@localhost:5432/hoge',
      \ }

augroup DBUI_MAP
  autocmd!
  autocmd FileType dbui nmap <buffer> o <Plug>(DBUI_SelectLine)
  autocmd FileType dbui nmap <buffer> <Enter> <Plug>(DBUI_SelectLine)
  " autocmd FileType dbui nnoremap <buffer> <C-n> :DBUIToggle<CR>
  " autocmd FileType sql nnoremap <C-n> :DBUIToggle<CR>
augroup END

let g:db_ui_default_query = 'SELECT * FROM "{table}"'

let g:db_ui_table_helpers = {
	\ 	'postgresql': {
	\ 		'List': 'select * from {table}',
	\ 		'Count': 'select count(*) from {optional_schema}{table}',
	\ 		'Explain': 'explain analyze {last_query}'
	\ 	}
 	\ }


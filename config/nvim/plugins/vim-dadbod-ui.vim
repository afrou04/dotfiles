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


function! s:populate_query() abort
  let rows = db_ui#query(printf(
        \ "select column_name, data_type from information_schema.columns where table_name='%s' and table_schema='%s'",
        \ b:dbui_table_name,
        \ b:dbui_schema_name
        \ ))
  let lines = ['INSERT INTO '.b:dbui_table_name.' (']
  for [column, datatype] in rows
    call add(lines, column)
  endfor
  call add(lines, ') VALUES (')
  for [column, datatype] in rows
    call add(lines, printf('%s <%s>', column, datatype))
  endfor
  call add(lines, ')')
  call setline(1, lines)
endfunction

autocmd FileType sql nnoremap <buffer><leader>i :call <sid>populate_query()

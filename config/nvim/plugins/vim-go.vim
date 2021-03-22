let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_operators = 1

let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_methods = 1

let g:go_highlight_generate_tags = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1

nmap <buffer> <leader>r :w<CR> <Plug>(go-run)
nmap <buffer> <leader>t :GoTest<CR>
nmap <Leader>f :GoTestFunc


call defx#custom#column('filename', {
      \ 'min_width': 40,
      \ 'max_width': 40,
      \ })

call defx#custom#column('mark', {
      \ 'readonly_icon': '✗',
      \ 'selected_icon': '✓',
      \ })

call defx#custom#option('_', {
      \ 'resume': 1,
      \ 'sort': 'filename',
      \ })

autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> <CR>
    \ defx#is_directory() ?
    \ defx#do_action('open_tree') :
    \ defx#do_action('open')
  nnoremap <silent><buffer><expr> r<CR> defx#do_action('open_tree_recursive')
  nnoremap <silent><buffer><expr> p defx#do_action('preview', 'vsplit')
  nnoremap <silent><buffer><expr> cp defx#do_action('copy')
  nnoremap <silent><buffer><expr> mv defx#do_action('move')
  nnoremap <silent><buffer><expr> nd defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> nf defx#do_action('new_file')
  nnoremap <silent><buffer><expr> rm defx#do_action('remove')
  nnoremap <silent><buffer><expr> rn defx#do_action('rename')
  nnoremap <silent><buffer><expr> ! defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> .. defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~ defx#do_action('cd')
  nnoremap <silent><buffer><expr> <C-n> defx#do_action('quit')
  nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
endfunction

nnoremap <silent> <C-n> :<C-u>silent call <SID>open_or_close_defx()<CR>

function! s:open_or_close_defx() abort
  let opts = [
        \   '-no-show-ignored-files',
        \   '-ignored-files=.git,.nvimrc,.lc.*,_tmp',
        \   '-sort=filename',
        \   '-no-listed',
        \   '-no-new',
        \   '-buffer-name=defx',
        \   '-split=no',
        \   printf('-session-file=%s', '.defx_session.json'),
        \   printf('-search=%s %s', expand('%:p'), getcwd()),
        \ ]
  call defx#util#call_defx('Defx', join(opts, ' '))
endfunction


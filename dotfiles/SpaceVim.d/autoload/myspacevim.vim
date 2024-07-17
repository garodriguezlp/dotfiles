function! myspacevim#before() abort
  call s:enableAutoSave()
endfunction

function! myspacevim#after() abort
  call s:enableSystemClipboard()
  call s:configureCopilot()
endfunction

function! s:enableAutoSave() abort
  set autowrite
  autocmd InsertLeave,TextChanged,FocusLost,BufLeave * silent! update
endfunction

function! s:enableSystemClipboard() abort
  set clipboard+=unnamed
endfunction

function! s:configureCopilot() abort
  imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
  let g:copilot_no_tab_map = v:true

  let g:copilot_filetypes = {
        \ 'gitcommit': v:true,
        \ }
endfunction

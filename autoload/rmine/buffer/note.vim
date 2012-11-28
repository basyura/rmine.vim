
function! rmine#buffer#note#load()
  silent %delete _
  call s:buffer_setting()
  call s:append_expalin()
  call s:define_default_key_mappings()
  let &filetype = 'rmine_note'
  call rmine#util#clear_undo()
  startinsert!
endfunction

function! s:append_expalin()
  let msg = 'note : #' . b:rmine_cache.id . ' ' . b:rmine_cache.subject
  call append(0, msg)
  call append(1, rmine#util#ljust('', strwidth(msg), '-'))
endfunction

function! s:buffer_setting()
  setlocal noswapfile
  setlocal buftype=acwrite
  setlocal nomodified
endfunction

function! s:post_note()
  let ret = input('post note ? (y/n) : ')
  if ret != 'y'
    redraw
    echohl Error | echo 'canceled' | echohl None
    return
  endif
  let note = join(getline(3, '$'), "\n")
  let ret  = rmine#api#issue_update(b:rmine_cache.id, {'notes' : note})
  bd!
  " moved to issue buffer
  call rmine#issue(b:rmine_cache.id)
  normal! G
  redraw!
endfunction

function! s:define_default_key_mappings()
  augroup rmine_note
    autocmd!
    nnoremap <buffer> <silent> q :bd!<CR>
    nnoremap <buffer> <silent> <CR> :call <SID>post_note()<CR>
    inoremap <buffer> <silent> <C-CR> <ESC>:call <SID>post_note()<CR>
  augroup END

  if !exists('b:rmine_note_bufwrite_cmd')
    augroup rmine_note_bufwrite_cmd
      autocmd!
      autocmd BufWriteCmd <buffer> :call s:post_note()
      let b:rmine_note_bufwrite_cmd = 1
    augroup END
  endif
endfunction


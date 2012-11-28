
function! rmine#buffer#note#load()
  silent %delete _
  call s:buffer_setting()
  call s:append_expalin()
  call s:define_default_key_mappings()
  let &filetype = 'rmine_note'
  call rmine#util#clear_undo()
  call cursor(1,1)
  "startinsert!
endfunction

function! s:append_expalin()
  let msg = 'note : #' . b:rmine_cache.id . ' ' . b:rmine_cache.subject
  call append(0, msg)
  call append(1, rmine#util#ljust('', strwidth(msg), '-'))
  call append(2, [
        \ 'assigned_to : ' . (has_key(b:rmine_cache, 'assigned_to') ? b:rmine_cache.assigned_to.id . ' # ' . b:rmine_cache.assigned_to.name : ''),
        \ 'status      : ' . b:rmine_cache.status.id      . ' # ' . b:rmine_cache.status.name,
        \ 'tracker     : ' . b:rmine_cache.tracker.id     . ' # ' . b:rmine_cache.tracker.name ,
        \ 'priority    : ' . b:rmine_cache.priority.id    . ' # ' . b:rmine_cache.priority.name,
        \ 'start_date  : ' . (has_key(b:rmine_cache, 'start_date') ? b:rmine_cache.start_date : ''),
        \ 'due_date    : ' . (has_key(b:rmine_cache, 'due_date')   ? b:rmine_cache.due_date   : ''),
        \ 'done_ratio  : ' . (has_key(b:rmine_cache, 'done_ratio') ? b:rmine_cache.done_ratio : ''),
        \ ''
        \ ])
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

  call cursor(3,1)
  
  " extract changed field
  let issue = {}
  while 1
    let line = getline('.')
    let pair = split(line, '\s\{0,}:\s\{0,}')
    if len(pair) > 1
      let converted_key   = s:convert_key(pair[0])
      let converted_value = s:convert_value(converted_key, pair[1])
      if !has_key(b:rmine_cache, pair[0])
          let issue[converted_key] = converted_value
      else
        let target = type(b:rmine_cache[pair[0]]) == 4 ? b:rmine_cache[pair[0]].id : b:rmine_cache[pair[0]]
        if target != converted_value
          let issue[converted_key] = converted_value
        endif
      endif
    endif
    execute "normal! \<Down>"
    if line =~ '^$' || line('.') == line('$')
      break
    endif
  endwhile

  let issue.notes = join(getline('.', '$') , "\n")

  let ret  = rmine#api#issue_update(b:rmine_cache.id, issue)
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

    inoremap <silent> <buffer> <C-s> <ESC>:call unite#sources#rmine_selector#start()<CR>
    nnoremap <silent> <buffer> <C-s> <ESC>:call unite#sources#rmine_selector#start()<CR>
  augroup END

  if !exists('b:rmine_note_bufwrite_cmd')
    augroup rmine_note_bufwrite_cmd
      autocmd!
      autocmd BufWriteCmd <buffer> :call s:post_note()
      let b:rmine_note_bufwrite_cmd = 1
    augroup END
  endif
endfunction


" ↓ copy & paste

let s:convert_map = {
      \ 'project'     : 'project_id',
      \ 'assigned_to' : 'assigned_to_id',
      \ 'status'      : 'status_id',
      \ 'tracker'     : 'tracker_id',
      \ 'priority'    : 'priority_id',
      \ }

function! s:convert_key(key)
  if has_key(s:convert_map, a:key)
    return s:convert_map[a:key]
  endif
  return a:key
endfunction

function! s:convert_value(key, value)
  if a:key =~ 'id$'
    " trim to id only
    return substitute(a:value, ' .*', '', '')
  else
    " trim tail space
    return substitute(a:value, ' *$', '', '')
  endif
endfunction

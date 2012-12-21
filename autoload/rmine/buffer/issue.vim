" issue

function! rmine#buffer#issue#load(issue)
  call s:pre_process() 
  call s:load(a:issue)
endfunction

function! s:pre_process()
  setlocal noswapfile
  setlocal modifiable
  setlocal buftype=nofile
  call s:define_default_key_mappings()
  setfiletype rmine_issue
  silent %delete _
endfunction

function! s:load(issue)
  let b:rmine_cache = a:issue

  let header = s:create_header(a:issue)
  let desc   = s:create_description(a:issue)
  let notes  = s:create_notes(a:issue)

  call append(0, header + desc + ['', '', '<< comments >>', ''] + notes)
  delete _
  call rmine#util#clear_undo()
  :0
endfunction

function! s:create_header(issue)
  let issue = a:issue
  let title = '[rmine] - ' . issue.project.name . '  #' . issue.id . ' ' . issue.subject
  let header = [
        \ title,
        \ '',
        \ 'author      : ' . issue.author.name,
        \ 'assigned_to : ' . get(issue, 'assigned_to', {'name' : ''}).name,
        \ 'status      : ' . issue.status.name,
        \ 'tracker     : ' . issue.tracker.name,
        \ 'priority    : ' . issue.priority.name,
        \ 'start_date  : ' . get(issue, 'start_date', ''),
        \ 'due_date    : ' . get(issue, 'due_date'  , ''),
        \ 'done_ratio  : ' . issue.done_ratio,
        \ 'created_on  : ' . rmine#util#format_date(issue.created_on),
        \ 'updated_on  : ' . rmine#util#format_date(issue.updated_on),
        \ '',
        \ ]
  
  return header
endfunction

function! s:create_description(issue)
  let issue = a:issue
  let desc = []
  for line in split(issue.description,"\n")
    let line = substitute(line , '' , '' , 'g')
    if line !~ "^h2\."
      let line = '  ' . line
    endif
    call add(desc , line)
  endfor

  return desc
endfunction

function! s:create_notes(issue)
  let issue = a:issue
  let notes = []
  for jnl in issue.journals
    if !has_key(jnl, 'notes') || jnl.notes == ''
      continue
    endif
    let name = jnl.user.name . ' - ' . jnl.created_on
    call add(notes, name)
    call add(notes, rmine#util#ljust('~', strwidth(name), '~'))
    for line in split(jnl.notes,"\n")
      call add(notes , '  ' . substitute(line , '' , '' , 'g'))
    endfor
    call add(notes, '')
  endfor

  return notes
endfunction

function! s:define_default_key_mappings()
  augroup rmine_issue
    nnoremap <silent> <buffer> <leader>r :call rmine#issue(b:rmine_cache.id)<CR>
    "nnoremap <silent> <buffer> <C-f> :call rmine#issue(b:rmine_cache.id - 1)<CR>
    "nnoremap <silent> <buffer> <C-b> :call rmine#issue(b:rmine_cache.id + 1)<CR>
    nnoremap <silent> <buffer> <Leader>s :call rmine#buffer#note()<CR>
    nnoremap <silent> <buffer> <Leader>b :call rmine#open_browser(b:rmine_cache.id)<CR>
  augroup END
endfunction

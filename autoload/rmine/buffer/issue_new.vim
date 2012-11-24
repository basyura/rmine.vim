
function! rmine#buffer#issue_new#load()
  call s:append_tempate()
  call s:buffer_setting()
  call s:define_default_key_mappings()
  setfiletype rmine_issue_new
  call cursor(1,1)
  startinsert!
endfunction

function! s:append_tempate()
  call append(0, [
        \ 'project     : ',
        \ 'subject     : ',
        \ 'assigned_to : ',
        \ 'status      : ',
        \ 'tracker     : ',
        \ 'priority    : ',
        \ 'start_date  : ',
        \ 'done_ratio  : ',
        \ ''
        \ ])
endfunction

function! s:buffer_setting()
  setlocal noswapfile
  setlocal buftype=acwrite
  call rmine#util#clear_undo()
  setlocal nomodified
endfunction

function! s:define_default_key_mappings()


  if !exists('b:rmine_issue_new_bufwrite_cmd')
    augroup rmine_issue_new_bufwrite_cmd
      autocmd!
      autocmd BufWriteCmd <buffer> :call s:post_issue()
      let b:rmine_issue_new_bufwrite_cmd = 1
    augroup END
  endif
endfunction 

function! s:post_issue()
  call cursor(1,1)
  let issue = {}
  while 1
    let line = getline('.')
    let pair = split(line, '\s\+:\s\=')
    " changed field only
    if len(pair) > 1
      let issue[pair[0]] = pair[1]
    endif
    execute "normal! \<Down>"
    if line =~ '^$' || line('.') == line('$')
      break
    endif
  endwhile
  
  let issue.description = join(getline('.', '$'), '\n')
  
  for key in ['project', 'subject']
    if !s:check_blank(issue, key)
      echohl Error | echo key . ' is blank' | echohl None
      return
    endif
  endfor

  let project = remove(issue, 'project')
  let subject = remove(issue, 'subject')
  let desc    = remove(issue, 'description')

  let res     = rmine#api#issue_post(project, subject, desc, issue)
  bd!
  call rmine#issue(res.issue.id)
endfunction

function! s:check_blank(issue, key)
  if get(a:issue, a:key, '') == ''
    return 0
  endif
  return 1
endfunction

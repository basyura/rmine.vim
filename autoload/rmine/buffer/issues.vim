" issues

function! rmine#buffer#issues#load(project, issues)
  let b:rmine_project = a:project
  call s:pre_process()
  call s:load(a:issues)
endfunction

function! s:pre_process()
  setlocal noswapfile
  setlocal modifiable
  setlocal nolist
  setlocal buftype=nofile
  call s:define_default_key_mappings()
  setfiletype rmine_issues
  silent %delete _
endfunction

function! s:load(issues)
  let b:rmine_cache = {}
  let title = '[rmine] ' . b:rmine_project

  :0

  call append(0, title)
  call append(1, tweetvim#util#separator('~'))

  let separator    = tweetvim#util#separator('-')
  let current_user = rmine#api#current_user()
  let apply_current_user = 0
  for issue in a:issues
    let b:rmine_cache[line(".")] = issue
    call append(line('$') - 1, s:format(issue))
    call append(line('$') - 1, separator)
    execute "syntax match rmine_issue_priority_" . issue.priority.id . " '\\zs#" . issue.id  ."\\ze '"
    if !apply_current_user
      let assigned_to = get(issue, 'assigned_to', {})
      if !empty(assigned_to)
        if assigned_to.id == current_user.id
          execute "syntax match rmine_issue_current_user '" . assigned_to.name  . "'"
          let apply_current_user = 1
        endif
      endif
    endif
  endfor
  call rmine#util#clear_undo()
  call s:apply_syntax()
  call cursor(1,1)
endfunction

function! s:define_default_key_mappings()
  augroup rmine_issues
    nnoremap <silent> <buffer> <CR>      :call <SID>open_issue()<CR>
    nnoremap <silent> <buffer> <leader>r :call rmine#issues(b:rmine_project)<CR>
    nnoremap <silent> <buffer> <leader>p :Unite rmine/project<CR>
    nnoremap <silent> <buffer> <leader>q :Unite rmine/query<CR>
    nnoremap <silent> <buffer> j :call <SID>cursor_down()<CR>
    nnoremap <silent> <buffer> k :call <SID>cursor_up()<CR>
  augroup END
endfunction

function! s:open_issue()
  if !has_key(b:rmine_cache, line("."))
    return
  endif
  let no = b:rmine_cache[line(".")].id
  call rmine#issue(no)
endfunction

function! s:format(issue)
  let buf = ''
  if b:rmine_project == 'all'
    let buf .= a:issue.project.name . ' '
  endif

  let buf .= '#' . rmine#util#ljust(a:issue.id, 4) . ' ' . 
          \ rmine#util#ljust(a:issue.status.name, 8) . ' ' . 
          \ rmine#util#ljust((has_key(a:issue, 'assigned_to') ? a:issue.assigned_to.name : '') , 15)  . ' ' . 
          \ rmine#util#ljust(get(a:issue, 'due_date',''), 12) . ' ' . 
          \ a:issue.subject . ' ' . 
          \ '[[' . rmine#util#format_date(a:issue.updated_on) . ']]'
  return buf
endfunction

function! s:apply_syntax()
  let statuses = rmine#api#issue_statuses()  
  for status in statuses
    execute "syntax match rmine_issue_status_" . status.id . " '" . status.name . "'"
  endfor
endfunction

function! s:server_url()
  return substitute(g:unite_yarm_server_url , '/$' , '' , '')
endfunction

function! s:cursor_down()
  while 1
    :execute "normal! \<Down>"
    if getline(".") !~ '^  ' && (!s:isCursorOnSeprator() || line(".") == line("$"))
      break
    endif
  endwhile
endfunction

function! s:cursor_up()
  while 1
    :execute "normal! \<Up>"
    if !s:isCursorOnSeprator() || line(".") == 1
      break
    endif
  endwhile
endfunction

function! s:isCursorOnSeprator()
  let name = synIDattr(synID(line('.'),col('.'),1),'name')
  return name == 'rmine_issues_separator' || name == 'rmine_issues_separator_title'
endfunction

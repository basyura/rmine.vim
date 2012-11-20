" issues

function! rmine#buffer#issues#load(issues)
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
  let b:redmine_cache = {}
  let title = '[rmine]'

  :0

  call append(0, title)
  call append(1, tweetvim#util#separator('~'))

  let separator = tweetvim#util#separator('-')
  for issue in a:issues
    let b:redmine_cache[line(".")] = issue
    call append(line('$') - 1, s:format(issue))
    call append(line('$') - 1, separator)
  endfor
  call cursor(1,1)
endfunction

function! s:define_default_key_mappings()
  augroup rmine_issues
    nnoremap <silent> <buffer> <CR>      :call <SID>open_issue()<CR>
    nnoremap <silent> <buffer> <leader>r :Rmine<CR>
  augroup END
endfunction

function! s:open_issue()
  if !has_key(b:redmine_cache, line("."))
    return
  endif
  let no = b:redmine_cache[line(".")].id
  call rmine#issue(no)
endfunction

function! s:format(issue)
  let buf = a:issue.project.name . ' ' . 
          \ '#' . a:issue.id . ' ' . 
          \ rmine#util#ljust(a:issue.status.name, 8) . ' ' . 
          \ a:issue.author.name . ' ' . 
          \ a:issue.subject . ' ' . 
          \ rmine#util#format_date(a:issue.updated_on)
  return buf
endfunction


function! s:server_url()
  return substitute(g:unite_yarm_server_url , '/$' , '' , '')
endfunction

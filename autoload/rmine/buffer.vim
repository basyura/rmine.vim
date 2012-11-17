scriptencoding utf-8

let s:last_bufnr = 0

let s:buf_name = '[rmine]'
function! rmine#buffer#load(issues)
  if type(a:issues) == 3
    call s:switch_buffer('issues', 'rmine')
    call s:pre_process('rmine')
    call s:load_isssues(a:issues)
  else
    call s:switch_buffer(a:issues.id, 'rmine_issue')
    call s:pre_process('rmine_issue')
    call s:show(a:issues)
  endif
endfunction
"
"
"
function! s:switch_buffer(name, filetype)
  " get buf no from buffer's name
  let bufname = s:buf_name . ' - ' . a:name
  let bufnr = -1
  let num   = bufnr('$')
  while num >= s:last_bufnr
    if getbufvar(num, '&filetype') ==# a:filetype && bufname(num) == bufname
      let bufnr = num
      break
    endif
    let num -= 1
  endwhile
  " buf is not exist
  if bufnr < 0
    execute g:tweetvim_open_buffer_cmd . ' ' . bufname
    let s:last_bufnr = bufnr("")
    return
  endif
  " buf is exist in window
  let winnr = bufwinnr(bufnr)
  if winnr > 0
    execute winnr 'wincmd w'
    return
  endif
  " buf is exist
  if buflisted(bufnr)
    if g:tweetvim_open_buffer_cmd =~ "split"
      execute g:tweetvim_open_buffer_cmd
    endif
    execute 'buffer ' . bufnr
  else
    " buf is already deleted
    execute g:tweetvim_open_buffer_cmd . ' ' . bufname
    let s:last_bufnr = bufnr("")
  endif
endfunction

function! s:pre_process(filetype)
  setlocal noswapfile
  setlocal modifiable
  setlocal nolist
  setlocal buftype=nofile
  "call s:define_default_key_mappings()
  execute "call s:define_default_key_mappings_" . a:filetype . "()"
  execute "setfiletype " . a:filetype
  silent %delete _
endfunction

function! s:load_isssues(issues)
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

function! s:format(issue)
  let buf = a:issue.project.name . ' ' . 
          \ '#' . a:issue.id . ' ' . 
          \ s:padding(a:issue.status.name, 8) . ' ' . 
          \ a:issue.author.name . ' ' . 
          \ a:issue.subject . ' ' . 
          \ rmine#util#format_date(a:issue.updated_on)
  return buf
endfunction

function! s:show(issue)
  let issue = a:issue
  let b:rmine_cache = issue
  let title = '[rmine] - ' . issue.project.name . '  #' . issue.id . ' ' . issue.subject

  :0

  call append(line('$') , title)
  call append(line('$') , tweetvim#util#separator('~'))
  call append(line('$') , 'author     : ' . issue.author.name)
  call append(line('$') , 'tracker    : ' . issue.tracker.name)
  call append(line('$') , 'priority   : ' . issue.priority.name)
  call append(line('$') , 'start_date : ' . issue.start_date)
  call append(line('$') , 'created_on : ' . rmine#util#format_date(issue.created_on))
  call append(line('$') , 'updated_on : ' . rmine#util#format_date(issue.updated_on))
  call append(line('$') , 'done_ratio : ' . issue.done_ratio)
  call append(line('$') , '')
  for line in split(a:issue.description,"\n")
    let line = substitute(line , '' , '' , 'g')
    if line !~ "^h2\."
      let line = '  ' . line
    endif
    call append(line('$') , line)
  endfor

  call append(line('$') , '-----------------------------------------------------------------------')

  for jnl in issue.journals
    if !has_key(jnl, 'notes') || jnl.notes == ''
      continue
    endif
    call append(line('$') , jnl.user.name)
    for line in split(jnl.notes,"\n")
      call append(line('$') , '  ' . substitute(line , '' , '' , 'g'))
    endfor
  endfor

  :0
  delete _
endfunction


" let date_time = s:DateTime.from_format(a:date,'%Y-%m-%dT%H:%M:%SZ', 'C')
" return date_time.strftime("%Y/%m/%d %H:%M")


function! s:padding(msg, length)
  let msg = a:msg
  while len(msg) < a:length
    let msg = msg . ' '
  endwhile
  return msg
endfunction

function! s:define_default_key_mappings_rmine()
  augroup rmine
    nnoremap <silent> <buffer> <CR>  :call <SID>open_issue()<CR>
  augroup END
endfunction

function! s:define_default_key_mappings_rmine_issue()
  augroup rmine
    nnoremap <silent> <buffer> <CR>  :echo "hi" <CR>
    nnoremap <silent> <buffer> <leader>r :call <SID>open_issue(b:rmine_cache.id)<CR>
  augroup END
endfunction


function! s:open_issue(...)
  if a:0 != 0
    let no = a:1
  else
    if !has_key(b:redmine_cache, line("."))
      return
    endif
    let no = b:redmine_cache[line(".")].id
  endif

  let url   = s:server_url() . '/issues/' . no . '.json?include=journals'
  if exists('g:unite_yarm_access_key')
    let url .= '&key=' . g:unite_yarm_access_key
  endif
  echomsg url
  let res = webapi#http#get(url)
  " check status code
  if split(res.header[0])[1] != '200'
    call unite#yarm#error(res.header[0])
    return []
  endif
  " convert xml to dict
  let issue = webapi#json#decode(res.content).issue
  call rmine#buffer#load(issue)
endfunction

function! s:server_url()
  return substitute(g:unite_yarm_server_url , '/$' , '' , '')
endfunction

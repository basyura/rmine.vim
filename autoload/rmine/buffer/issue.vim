" issue

function! rmine#buffer#issue#load(issue)
  call s:pre_process() 
  call s:load(a:issue)
endfunction

function! s:pre_process()
  setlocal noswapfile
  setlocal modifiable
  setlocal nolist
  setlocal buftype=nofile
  call s:define_default_key_mappings()
  setfiletype rmine_issue
  silent %delete _
endfunction

function! s:load(issue)
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
    call append(line('$'), jnl.user.name)
    call append(line('$'), rmine#util#ljust('-', strwidth(jnl.user.name), '-'))
    for line in split(jnl.notes,"\n")
      call append(line('$') , '  ' . substitute(line , '' , '' , 'g'))
    endfor
    call append(line('$'), '')
  endfor

  :0
  delete _
endfunction


function! s:define_default_key_mappings()
  augroup rmine_issue
    nnoremap <silent> <buffer> <leader>r :call rmine#issue(b:rmine_cache.id)<CR>
    nnoremap <silent> <buffer> <C-f> :call rmine#issue(b:rmine_cache.id - 1)<CR>
    nnoremap <silent> <buffer> <C-b> :call rmine#issue(b:rmine_cache.id + 1)<CR>
  augroup END
endfunction



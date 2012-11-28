scriptencoding utf-8

let s:bufMgr = vital#of('rmine.vim').import('Vim.BufferManager').new()

let s:last_bufnr = 0

function! rmine#buffer#load(issues)
  if type(a:issues) == 3
    call s:bufMgr.open("rmine:issues", {'opener' : 'edit!' })
    call rmine#buffer#issues#load(a:issues)
  else
    call s:bufMgr.open("rmine:" . a:issues.id . ' - ' . a:issues.subject, {'opener' : 'edit!' })
    call rmine#buffer#issue#load(a:issues)
  endif
endfunction

function! rmine#buffer#new_issue()
  call s:bufMgr.open("rmine:issue_new", {'opener' : 'edit!' })
  call rmine#buffer#issue_new#load()
endfunction


function! rmine#buffer#note()
  try
    if &filetype != 'rmine_issue'
      return
    endif
    let cache = b:rmine_cache
    vsplit
    "split
    "wincmd j
    "execute '30 wincmd _'
    call s:bufMgr.open("rmine:note", {'opener' : 'split'})
    let b:rmine_cache = cache
    call rmine#buffer#note#load()
  catch
    echo v:exception
  endtry
endfunction

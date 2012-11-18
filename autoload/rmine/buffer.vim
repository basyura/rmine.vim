scriptencoding utf-8

let s:bufMgr = vital#of('rmine.vim').import('Vim.BufferManager').new()

let s:last_bufnr = 0

function! rmine#buffer#load(issues)
  if type(a:issues) == 3
    call s:bufMgr.open("rmine:issues", {'opener' : 'edit!' })
    call rmine#buffer#issues#load(a:issues)
  else
    call s:bufMgr.open("rmine:" . a:issues.id . ' - ' . a:issues.subject)
    call rmine#buffer#issue#load(a:issues)
  endif
endfunction

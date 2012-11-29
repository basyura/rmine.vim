

function! rmine#issues(project, ...)
  let param = a:0 > 0 ? a:1 : {}
  if !has_key(param, 'limit')
    let param.limit = 100
  endif
  let issues = rmine#api#issues(a:project, param)
  call rmine#buffer#load(a:project, issues)
endfunction

function! rmine#issue(no)
  let issue = rmine#api#issue(a:no)
  call rmine#buffer#load('', issue)
endfunction

function! rmine#open_browser(no)
  let url = s:server_url() . '/issues/' . a:no
  execute "OpenBrowser " . url
endfunction

function! s:server_url()
  return substitute(g:rmine_server_url , '/$' , '' , '')
endfunction

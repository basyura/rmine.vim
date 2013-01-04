

function! rmine#issues(project, ...)
  let param = a:0 > 0 ? a:1 : {}
  if !has_key(param, 'limit')
    let param.limit = 100
  endif
  let issues = rmine#api#issues(a:project, param)
  call rmine#buffer#load(a:project, issues)
endfunction

function! rmine#issues_command(...)
  let project = a:0 > 0 ? a:1 : 'all'
  call rmine#issues(project)
endfunction

function! rmine#issue(no)
  let issue = rmine#api#issue(a:no)
  call rmine#buffer#load('', issue)
endfunction

function! rmine#open_browser(no)
  let url = rmine#server_url() . '/issues/' . a:no
  execute "OpenBrowser " . url
endfunction

function! rmine#server_url()
  let url = get(g:, 'rmine_server_url', 'http://localhost:3000')
  return substitute(url , '/$' , '' , '')
endfunction

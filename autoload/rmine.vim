

function! rmine#issues(project)
  let issues = rmine#api#issues(a:project, {'limit' : 100})
  call rmine#buffer#load(issues)
endfunction

function! rmine#issue(no)
  let issue = rmine#api#issue(a:no)
  call rmine#buffer#load(issue)
endfunction

function! rmine#open_browser(no)
  let url = s:server_url() . '/issues/' . a:no
  execute "OpenBrowser " . url
endfunction

function! s:server_url()
  return substitute(g:rmine_server_url , '/$' , '' , '')
endfunction

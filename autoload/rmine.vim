

function! rmine#issues(project)
  let limit = 20
  let issues = rmine#api#issues(a:project)
  call rmine#buffer#load(issues)
endfunction

function! rmine#issue(no)
  let issue = rmine#api#issue(a:no)
  call rmine#buffer#load(issue)
endfunction

function! rmine#projects()
endfunction

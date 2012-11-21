

function! rmine#issues()
  let limit = 20
  let issues = rmine#api#issues()
  call rmine#buffer#load(issues)
endfunction

function! rmine#issue(no)
  let issue = rmine#api#issue(a:no)
  call rmine#buffer#load(issue)
endfunction

function! rmine#projects()
endfunction

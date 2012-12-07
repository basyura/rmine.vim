
function! rmine#complete#project(arglead, ...)
  let projects = rmine#api#projects()
  return join(map(projects, 'v:val.identifier'), "\n")
endfunction

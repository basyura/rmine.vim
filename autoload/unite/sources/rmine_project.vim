
function! unite#sources#rmine_project#define()
  return s:source
endfunction

let s:source = {
      \ 'name': 'rmine/project',
      \ 'hooks' : {},
      \ 'action_table' : {},
      \ 'default_action' : {'common' : 'execute'},
      \ }

function! s:source.gather_candidates(args, context)
  
  let projects = rmine#api#projects()

  return map(projects, '{
        \ "word"               : v:val.name,
        \ "source__identifier" : v:val.identifier,
        \ }')
endfunction

let s:source.action_table.execute = {'description' : 'project issues'}
function! s:source.action_table.execute.func(candidate)
  let id = a:candidate.source__identifier
  call rmine#issues(id)
endfunction

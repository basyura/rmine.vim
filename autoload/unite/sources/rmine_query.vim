
function! unite#sources#rmine_query#define()
  return s:source
endfunction

let s:source = {
      \ 'name': 'rmine/query',
      \ 'hooks' : {},
      \ 'action_table' : {},
      \ 'default_action' : {'common' : 'execute'},
      \ }

function! s:source.gather_candidates(args, context)
  
  let queries = rmine#api#queries()

  let project    = get(b:, 'rmine_project', 'all')
  let project_id = project == 'all' ? '' : rmine#api#project(project).id

  let list = []
  for query in queries
    if !has_key(query, 'project_id') || query.project_id == project_id
      call add(list, {
                    \ "word"            : query.name,
                    \ "source__query"   : query.id,
                    \ "source__project" : project,
                    \ })
    endif
  endfor

  return list
endfunction

let s:source.action_table.execute = {'description' : 'project queries'}
function! s:source.action_table.execute.func(candidate)
  let project = a:candidate.source__project
  let query   = a:candidate.source__query
  call rmine#issues(project, {"query_id" : query})
endfunction

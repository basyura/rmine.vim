

function! unite#sources#rmine_selector#define()
  return s:source
endfunction

let s:source = {
      \ 'name': 'rmine/selector',
      \ 'hooks' : {},
      \ 'action_table' : {},
      \ 'default_action' : {'common' : 'execute'},
      \ 'is_listed' : 0,
      \ }

let s:selector_map = {
      \ 'project'     : 'projects',
      \ 'tracker'     : 'trackers',
      \ 'assigned_to' : 'users',
      \ 'status'      : 'issue_statuses',
      \ 'priority'    : 'issue_priorities',
      \ }

function! unite#sources#rmine_selector#start()
  " get line and judge selector
  let line = getline('.')
  let pair = split(line, '\s\{0,}:\s\{0,}')
  " check line
  if len(pair) == 0
    return
  endif
  " check api
  let selector = pair[0]
  if !has_key(s:selector_map, selector)
    return
  endif
  try
    let list = eval("rmine#api#" . s:selector_map[selector] . "()")
  catch
    echohl Error | echo 'not supported' | echohl None
    return
  endtry
  "
  for v in list
    if selector == 'assigned_to'
      let v.name     = v.firstname . ' ' . v.lastname
    endif
    let v.selector = selector
    let v.line     = line
  endfor
  return unite#start(['rmine/selector'], {
        \ 'source__list'     : list,
        \ })
endfunction

function! s:source.gather_candidates(args, context)
  return map(a:context.source__list, '{
        \ "word"             : v:val.name,
        \ "source__id"       : v:val.id,
        \ "source__name"     : v:val.name,
        \ "source__selector" : v:val.selector,
        \ "source__line"     : v:val.line,
        \ }')
endfunction

let s:source.action_table.execute = {'description' : 'select item'}
function! s:source.action_table.execute.func(candidate)
  let id   = a:candidate.source__id
  let name = a:candidate.source__name
  let line = substitute(a:candidate.source__line, ':.*', '', '') . ': ' . id . ' # ' . name
  call append('.', line)
  delete _
endfunction

function! unite#sources#rmine_selector#id_sort(i1, i2)
  return a:i1.id - a:i2.id
endfunction

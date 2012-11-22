
function! rmine#api#versions(project_id)
  return s:request('/projects/' . a:project_id . '/versions').versions
endfunction

function! rmine#api#projects()
  return s:request('projects').projects
endfunction

function! rmine#api#issues()
  return s:request('issues').issues
endfunction

function! rmine#api#issue(no)
  return s:request('issues/' . a:no, {'include' : 'journals'}).issue
endfunction

function! rmine#api#users()
  return s:request('users').users
endfunction

function! rmine#api#project_memberships(project_id)
  return s:request('/projects/' . a:project_id . '/memberships').memberships
endfunction

function! rmine#api#trackers(project_id)
  return s:request('/trackers').trackers
endfunction

function! rmine#api#queries(project_id)
  return s:request('/queries').queries
endfunction

function! rmine#api#issue_statuses()
  return s:request('/issue_statuses').issue_statuses
endfunction


function! s:request(path, ...)
  let path   = a:path =~ '^\/' ? a:path : '/' . a:path
  let option = a:0 > 0 ? a:1 : {}

  if exists('g:rmine_access_key')
    let option['key'] = g:rmine_access_key
  endif

  let ret = rmine#http#get(s:server_url() . path . '.json', option)

  let status = substitute(ret.header[0], 'HTTP/1.\d ', '', '')
  let status = substitute(status, ' .*', '', '')
  if status != '200'
    throw ret.header[0]
  endif
  return rmine#json#decode(ret.content)
endfunction

function! s:server_url()
  return substitute(g:rmine_server_url , '/$' , '' , '')
endfunction

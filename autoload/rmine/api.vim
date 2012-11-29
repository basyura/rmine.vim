let s:vital = vital#of('rmine.vim')
let s:http  = s:vital.import('Web.Http')


function! rmine#api#versions(project_id)
  return s:get('projects/' . a:project_id . '/versions').versions
endfunction

function! rmine#api#projects(...)
  return s:get('projects').projects
endfunction

function! rmine#api#project(id)
  return s:get('projects/' . a:id).project
endfunction
"
" project : all or project_id
"
function! rmine#api#issues(project, ...)
  let param = a:0 > 0 ? a:1 : {}
  let path  = a:project == 'all' ? 'issues' : 'projects/' . a:project . '/issues'
  return s:get(path, param).issues
endfunction

function! rmine#api#issue(no)
  return s:get('issues/' . a:no, {'include' : 'journals'}).issue
endfunction
"{
"    "issue": {
"      "project_id": "example",
"      "subject": "Test issue",
"      "custom_field_values":{
"        "1":"1.1.3"  #the affected version field
"      }
"    }
"}
"
"{
"   'issue': {
"     'id'              : 67,
"     'status_id'       : 1
"     'author'          : {'id': 1, 'name': 'admin'},
"     'tracker_id'      : 4
"     'priority_id'     : 4
"     'project_id'      : 1
"     'done_ratio'      : 0,
"     'subject'         : 'あ', 
"     'description'     : 'いいいいいいいいいいいいい',
"     'assigned_to_id'  : 1,
"     'start_date'      : '2012-11-23',
"     'due_date'        : '2012-11-24',
"     'estimated_hours' : 10,
"     'created_on'      : '2012-11-23T14:54:00Z',
"     'updated_on'      : '2012-11-23T14:54:00Z'
"     }
"   }
function! rmine#api#issue_post(project_id, subject, description, ...)
  let param = a:0 > 0 ? a:1 : {}
  let issue = {
        \ 'project_id'  : a:project_id,
        \ 'subject'     : a:subject,
        \ 'description' : a:description
        \ }
  let issue = extend(issue, param)
  return s:post('issues', {'issue' : issue})
endfunction

function! rmine#api#issue_update(no, param)
  return s:put('issues/' . a:no, {'issue' : a:param})
endfunction

function! rmine#api#issue_delete(no)
  return s:delete('issues/' . a:no)
endfunction

function! rmine#api#issue_statuses()
  return s:get('issue_statuses').issue_statuses
endfunction

function! rmine#api#issue_priorities()
  return s:get('enumerations/issue_priorities').issue_priorities
endfunction

function! rmine#api#users()
  return s:get('users').users
endfunction

function! rmine#api#project_memberships(project_id)
  return s:get('projects/' . a:project_id . '/memberships').memberships
endfunction

function! rmine#api#trackers()
  return s:get('trackers').trackers
endfunction

function! rmine#api#queries()
  return s:get('queries').queries
endfunction

"-------------- private -----------------

function! s:get(path, ...)
  return s:request('get', a:path, {}, a:0 > 0 ? a:1 : {})
endfunction

function! s:post(path, data, ...)
  return s:request('post', a:path, a:data, a:0 > 0 ? a:1 : {})
endfunction

function! s:put(path, data, ...)
  return s:request('put', a:path, a:data, a:0 > 0 ? a:1 : {})
endfunction

function! s:delete(path)
  return s:request('delete', a:path, {}, {})
endfunction

function! s:request(method, path, data, option)
  let path   = a:path =~ '^\/' ? a:path : '/' . a:path
  let option = a:option

  if exists('g:rmine_access_key')
    let option['key'] = g:rmine_access_key
  endif

  let url   = s:server_url() . path . '.json'
  let param = webapi#http#encodeURI(option)
  if strlen(param)
    let url .= "?" . param
  endif

  if a:method == 'GET'
    let ret = webapi#http#get(url)
  else
    let data = webapi#json#encode(a:data)
    let ret  = webapi#http#post(url, data, {'Content-Type' : 'application/json'} , toupper(a:method))
  endif

  let status = substitute(ret.header[0], 'HTTP/1.\d ', '', '')
  let status = substitute(status, ' .*', '', '')
  if index(['200', '201'], status) < 0
    throw ret.header[0]
  endif

  " put or delete
  if ret.content == ' '
    return 1
  else
    return webapi#json#decode(ret.content)
  endif
endfunction


function! s:server_url()
  return substitute(g:rmine_server_url , '/$' , '' , '')
endfunction

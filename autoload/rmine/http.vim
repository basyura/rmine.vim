let s:Vital = vital#of('rmine.vim')
let s:Http  = s:Vital.import('Web.Http')

function! rmine#http#get(url, ...)
  let param = [a:url] + a:000
  return call(function('webapi#http#get'), param)
  "return s:Http.get(a:url)
endfunction

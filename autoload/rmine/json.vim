let s:Vital = vital#of('rmine.vim')
let s:Json  = s:Vital.import('Web.Json')

function! rmine#json#decode(json)
  return s:Json.decode(a:json)
endfunction

let s:Vital    = vital#of('rmine.vim')
let s:DateTime = s:Vital.import('DateTime')
let s:Html     = s:Vital.import('Web.Html')
let s:List     = s:Vital.import('Data.List')
"
"
"
function! rmine#util#format_date(date)
  return a:date
  let date_time = s:DateTime.from_format(a:date,'%Y-%m-%dT%H:%M:%SZ', 'C')
  return date_time.strftime("%Y/%m/%d %H:%M")
endfunction

function! rmine#util#ljust(msg, length, ...)
  let padstr = a:0 > 0 ? a:1 : ' '
  let msg = a:msg
  while strwidth(msg) < a:length
    let msg = msg . padstr
  endwhile
  return msg
endfunction


function! rmine#util#clear_undo()
  let old_undolevels = &undolevels
  setlocal undolevels=-1
  execute "normal a \<BS>\<Esc>"
  let &l:undolevels = old_undolevels
  unlet old_undolevels
endfunction


let s:Vital    = vital#of('rmine.vim')
let s:DateTime = s:Vital.import('DateTime')
let s:Html     = s:Vital.import('Web.Html')
let s:List     = s:Vital.import('Data.List')
"
"
"
function! rmine#util#format_date(date)
  let date_time = s:DateTime.from_format(a:date,'%Y-%m-%dT%H:%M:%SZ', 'C')
  return date_time.strftime("%Y/%m/%d %H:%M")
endfunction

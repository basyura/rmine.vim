
"runtime! syntax/textile.vim

syntax match rmine_title_h2 "^h2\..*"

syntax match rmine_title_h3 "^  \zsh3\..*\ze"


syntax match rmine_note_author_separator "^\~*$"

syntax match rmine_quote "^\s\+>.*"
syntax match rmine_comments "^<< comments >>$"

syntax match rmine_pre_start "<pre>"
syntax match rmine_pre_end   "</pre>"
syntax match rmine_code_start "<code.*>"
syntax match rmine_code_end   "</code>"
""syntax region rmine_pre start="<pre\>" end="</pre>" contains=rmine_pre_start,rmine_pre_end,rmine_code_start,rmine_code_end
syntax region rmine_pre  keepend start="<pre\>" end="</pre>" contains=rmine_code_start,rmine_code_end,rmine_pre_start,rmine_pre_end
""syntax region rmine_pre start='<pre\>' end='</pre>' 


hi def link rmine_title_h2 Underlined
hi def link rmine_title_h3 Underlined
hi def link rmine_comments Underlined
hi def link rmine_note_author_separator Comment
hi def link rmine_quote    Comment
hi rmine_pre guifg=orange
hi rmine_pre_start guifg=#6A6A6A
hi rmine_pre_end guifg=#6A6A6A
hi rmine_code_start guifg=#6A6A6A
hi rmine_code_end   guifg=#6A6A6A

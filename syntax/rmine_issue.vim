
syntax match rmine_title_h2 "^h2\..*"

syntax match rmine_title_h3 "^  \zsh3\..*\ze"

syntax match rmine_quote "^\s\+>.*"
syntax match rmine_comments "^<< comments >>$"


hi def link rmine_title_h2 Underlined
hi def link rmine_title_h3 Underlined
hi def link rmine_comments Underlined
hi def link rmine_quote    Comment

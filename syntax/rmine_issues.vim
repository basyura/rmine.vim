scriptencoding utf-8

setlocal conceallevel=2
setlocal concealcursor=nc

syntax match rmine_issues_separator       "^-\+$"
syntax match rmine_issues_separator_title "^\~\+$"

syntax match rmine_appendix "\[\[.\{-1,}\]\]" contains=rmine_appendix_block
syntax match rmine_appendix_block /\[\[/ contained conceal
syntax match rmine_appendix_block /\]\]/ contained conceal

highlight default rmine_issues_separator guifg=#444444
highlight default rmine_issues_separator_title guifg=#444444

highlight default rmine_appendix         guifg=#616161


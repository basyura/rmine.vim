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

highlight default link rmine_issue_status_1 Normal
highlight default link rmine_issue_status_2 Visual
highlight default link rmine_issue_status_3 Todo
highlight default link rmine_issue_status_4 NonText
highlight default link rmine_issue_status_5 Normal
highlight default link rmine_issue_status_6 Normal
highlight default link rmine_issue_status_7 Normal
highlight default link rmine_issue_status_8 Normal
highlight default link rmine_issue_status_9 Normal

highlight default link rmine_issue_priority_3 Statement
highlight default link rmine_issue_priority_4 Normal
highlight default link rmine_issue_priority_5 Constant
highlight default link rmine_issue_priority_6 WarningMsg
highlight default link rmine_issue_priority_7 ErrorMsg

highlight default link rmine_issue_current_user Type



command! Rmine :call rmine#issues('all')

command! -nargs=1 RmineIssue :call rmine#issue(<args>)

command! RmineNewIssue :call rmine#buffer#new_issue()

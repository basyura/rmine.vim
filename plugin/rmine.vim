

command! -nargs=? -complete=custom,rmine#complete#project Rmine :call rmine#issues_command(<f-args>)

command! -nargs=1 RmineIssue :call rmine#issue(<args>)

command! RmineNewIssue :call rmine#buffer#new_issue()



command! Rmine :call rmine#issues()

command! -nargs=1 RmineIssue :call rmine#issue(<args>)

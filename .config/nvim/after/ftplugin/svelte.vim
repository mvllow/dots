if exists('loaded_matchit') && !exists('b:match_words')
  let b:match_ignorecase = 0
  let b:match_words =
        \ '#\%(if\|await\|each\)\>:\:\%(else\|catch\|then\)\>:\/\%(if\|await\|each\)\>,' .
        \ '{:},' .
        \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
        \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
        \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'
endif

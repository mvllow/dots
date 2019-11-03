E:VISUAL = nvim
E:EDIOTR = $E:VISUAL
E:GIT_EDITOR = $E:EDITOR

use re
use epm

epm:install &silent-if-installed=$true \
  github.com/zzamboni/elvish-completions \
  github.com/zzamboni/elvish-modules

use github.com/zzamboni/elvish-completions/builtins
use github.com/zzamboni/elvish-completions/cd
use github.com/zzamboni/elvish-completions/git
use github.com/zzamboni/elvish-modules/alias

paths = [/usr/local/bin $@paths]

edit:rprompt = { put '' }

alias:new vi nvim

-exports- = (alias:export)

E:VISUAL = nvim
E:EDITOR = $E:VISUAL
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

if (test nvim) {
  alias:new vi nvim
}

if (test code-insiders) {
  alias:new code code-insiders
}

-exports- = (alias:export)

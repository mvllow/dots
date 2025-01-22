#!/usr/bin/env sh

# Handled by Brewfile
# brew install lua-language-server # lua_ls
# brew install shfmt
# go install golang.org/x/tools/cmd/goimports@latest

npm i -g @angular/language-server              # angularls
npm i -g @astrojs/language-server              # astro
npm i -g @tailwindcss/language-server          # tailwindcss
npm i -g @typescript/native-preview            # tsgo
npm i -g stimulus-language-server              # stimulus_ls
npm i -g svelte-language-server                # svelte
npm i -g turbo-language-server                 # turbo_ls
npm i -g typescript typescript-language-server # ts_ls
npm i -g vscode-langservers-extracted          # html, css, json, eslint

mise use -g ruby@latest && gem install ruby-lsp # ruby_lsp

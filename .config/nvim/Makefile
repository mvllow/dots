SHELL := /bin/sh

BREW_PACKAGES = lua-language-server \
					 stylua
NPM_PACKAGES = @fsouza/prettierd \
					typescript-language-server \
					vscode-langservers-extracted \
					@tailwindcss/language-server \
					svelte-language-server \
					@volar/vue-language-server

.PHONY: install
install:
	brew upgrade
	brew install $(BREW_PACKAGES)
	npm install --global --latest $(NPM_PACKAGES)

.PHONY: uninstall
uninstall:
	brew uninstall $(BREW_PACKAGES)
	npm uninstall --global $(NPM_PACKAGES)

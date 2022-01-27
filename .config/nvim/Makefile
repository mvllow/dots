SHELL := /bin/sh

BREW_PACKAGES = lua-language-server \
				stylua \
				shfmt
NPM_PACKAGES = @fsouza/prettierd \
			   typescript-language-server \
			   vscode-langservers-extracted \
			   @tailwindcss/language-server \
			   svelte-language-server \
			   @volar/server

install:
	brew upgrade
	brew install $(BREW_PACKAGES)
	npm install --global --latest $(NPM_PACKAGES)

clean:
	brew uninstall $(BREW_PACKAGES)
	npm uninstall --global $(NPM_PACKAGES)

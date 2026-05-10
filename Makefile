.DEFAULT_GOAL := help

.PHONY: help menu dev build preview upgrade

help:
	@printf "\n  \033[33mspec-md\033[0m\n"
	@printf "\n  usage: make <target>\n\n"
	@awk '/^[a-zA-Z_-]+:.*##/ { printf "  \033[36m%-10s\033[0m %s\n", substr($$1, 1, length($$1)-1), substr($$0, index($$0, "##")+3) }' $(MAKEFILE_LIST)
	@printf "\n"

menu: ## show this menu (alias for help)
	@make help

dev: ## start astro dev server
	npm run dev

build: ## build static site to dist/
	npm run build

preview: ## preview built site locally
	npm run preview

upgrade: ## upgrade astro and dependencies
	npx @astrojs/upgrade

.DEFAULT_GOAL := help

.PHONY: help dev build preview

help:
	@echo "usage: make <target>"
	@echo ""
	@echo "  dev      start astro dev server"
	@echo "  build    build static site to dist/"
	@echo "  preview  preview built site locally"

dev:
	npm run dev

build:
	npm run build

preview:
	npm run preview

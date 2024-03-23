.DEFAULT_GOAL:=help

.PHONY: build
build: ## Build emacs config
	@emacs --batch -f batch-byte-compile ~/.emacs.d/init.el

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

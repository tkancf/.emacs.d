EMACS ?= emacs

.DEFAULT_GOAL:=help

.PHONY: build
build: ## Build emacs config
	@$(EMACS) -Q --batch --eval "(progn (require 'ob-tangle) (org-babel-tangle-file \"./init.org\" \"./init.el\" \"emacs-lisp\"))"
	@$(EMACS) --batch -Q -f batch-byte-compile init.el 2>&1 | grep -E -v 'Warning|https://github.com/emacs-evil/evil-collection/issues/60'

.PHONY: build-log
build-log: ## Build emacs config with log
	@$(EMACS) -Q --batch --eval "(progn (require 'ob-tangle) (org-babel-tangle-file \"./init.org\" \"./init.el\" \"emacs-lisp\"))"
	@$(EMACS) --batch -Q -f batch-byte-compile init.el

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

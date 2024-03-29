;; init.el --- My init.el -*- lexical-binding: t -*-
;; Configurations for Emacs

(setq indent-tabs-mode nil)

(setq ring-bell-function 'ignore)

(defun delete-to-beginning-of-line ()
  (interactive)
  (kill-region (line-beginning-position) (point)))

(global-set-key (kbd "C-u") 'delete-to-beginning-of-line)



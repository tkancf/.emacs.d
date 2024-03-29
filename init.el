;; init.el --- My init.el -*- lexical-binding: t -*-
;; Configurations for Emacs

(setq indent-tabs-mode nil)

(setq ring-bell-function 'ignore)

(defun delete-to-beginning-of-line ()
  (interactive)
  (kill-region (line-beginning-position) (point)))

(global-set-key (kbd "C-u") 'delete-to-beginning-of-line)

(global-set-key (kbd "C-j") 'Control-X-prefix)

(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

(leaf org
  :custom
  (org-directory . "~/Dropbox/org/")
  (org-use-speed-commands . t)
  (org-log-done . 'time)
  (org-md-export-with-toc . nil)
  :config
  ;; org-captureのテンプレート
  (setq org-capture-templates
        `(("u" "Todo with Link" entry (file+headline ,(concat org-directory "todo.org") "Todo")
           "* TODO %?\n  %i\n  %a")
          ("t" "Todo" entry (file+headline ,(concat org-directory "todo.org") "Todo")
           "* TODO %?\n SCHEDULED: %t\n")
          ("m" "Memo" entry (file+headline ,(concat org-directory "memo.org") "Memo")
           "* %?\n")
          ("n" "Memo with Link" entry (file+headline ,(concat org-directory "memo.org") "Memo")
           "* %?\nEntered on %U\n  %i\n  %a")
          ("j" "Journal" entry (file ,(concat org-directory "journal.org"))
           "* %<%Y-%m-%d>\n%?\n%i\n")))
  ;; org-agendaのファイル
  (setq org-agenda-files (list (concat org-directory "todo.org")
                               (concat org-directory "journal.org")))
  :bind
  (("C-c c" . org-capture)
   ("C-c a" . org-agenda)))



;; init.el --- My init.el -*- lexical-binding: t -*-
;; Configurations for Emacs

(push '(tool-bar-lines . 0) default-frame-alist)

(setq inhibit-startup-message t)

(setq indent-tabs-mode nil)

(setq ring-bell-function 'ignore)

;; Cicaフォントの設定
(set-face-attribute 'default nil
                    :family "Cica"
                    :height 180) ; フォントの大きさは好みで調整してください

;; 日本語文字にもCicaフォントを使用
(set-fontset-font t 'japanese-jisx0208 (font-spec :family "Cica"))
(set-fontset-font t 'japanese-jisx0212 (font-spec :family "Cica"))
(set-fontset-font t 'katakana-jisx0201 (font-spec :family "Cica"))

;; 絵文字等のためにシンボルフォントも指定する
(set-fontset-font t 'symbol (font-spec :family "Cica"))

(blink-cursor-mode 0)

(setq make-backup-files nil)
(setq auto-save-list-file-prefix nil)
(setq create-lockfiles nil)
(setq auto-save-default nil)

(defun delete-to-beginning-of-line ()
  (interactive)
  (kill-region (line-beginning-position) (point)))

(global-set-key (kbd "C-u") 'delete-to-beginning-of-line)

(define-key key-translation-map (kbd "C-j") (kbd "C-x"))
(define-key key-translation-map (kbd "C-x") (kbd "C-j"))

(define-key key-translation-map (kbd "s-j") (kbd "M-x"))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package)))

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  '(doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package which-key
  :ensure t
  :custom ((which-key-idle-delay 1.0))
  :config
  (which-key-mode 1))

(use-package corfu
  :ensure t
  :custom
  ((corfu-auto t)
   (corfu-auto-delay 0.1)
   (corfu-cycle t)
   (corfu-auto-prefix 2) ;; 補完候補を2文字で出す
   (corfu-on-exact-match nil))
  :config
  ;; 基本設定
  (global-corfu-mode 1)

  ;; indentモードでの補完を強化
  (with-eval-after-load 'indent
    (setq tab-always-indent 'complete)))

(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-history)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  :config
  )

(use-package vertico
  :ensure t
  :custom
  (vertico-count 15) ; 候補数を15に増やす
  :init
  (vertico-mode))

(use-package orderless
  :ensure t
  :init
  ;; Set completion style for Emacs
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))

(use-package recentf
  :config
  (setq recentf-max-saved-items 15             ; consult-bufferに表示する最近使ったファイルの最大表示数
        recentf-exclude '(".recentf" "^/ssh:") ; recentfの履歴に含ませないファイルリスト
        recentf-auto-cleanup 'never           ; recentfの履歴を削除しない
        recentf-auto-save-timer
        (run-with-idle-timer 30 t 'recentf-save-list)) ; バッファを開いて30秒以上したら履歴に登録
  (recentf-mode 1))

(use-package consult
  :ensure t
  :bind (("C-x b" . consult-buffer)
         ("M-g M-g" . consult-goto-line)  ;; goto-lineをconsult-goto-lineに置き換え
         ("C-c s" . consult-line)         ;; バッファ内をキーワードで検索
         ("C-c o" . consult-outline)))    ;; アウトライン

(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  (setq evil-normal-state-cursor '(box "#EFEBEB"))
  (setq evil-insert-state-cursor '(bar "#EFEBEB"))
  (setq evil-default-cursor '(hbar "#7355AE"))
  (with-eval-after-load 'evil-maps
    ;; :と;をスワップ
    (define-key evil-motion-state-map ";" 'evil-ex)
    (define-key evil-motion-state-map ":" 'evil-repeat-find-char)

    ;; C-uでVimと同じようにスクロール 
    (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)

    ;; ステート切り替えキーを変更
    ;; EmacsステートからESCでEvilモードに復帰
    (define-key evil-emacs-state-map (kbd "ESC") 'evil-normal-state)
    ;; あらゆるモードからSuper-oでステートをトグル
    (define-key evil-emacs-state-map (kbd "s-o") 'evil-normal-state)
    (define-key evil-normal-state-map (kbd "s-o") 'evil-emacs-state)
    (define-key evil-insert-state-map (kbd "s-o") 'evil-emacs-state)
    (define-key evil-visual-state-map (kbd "s-o") 'evil-emacs-state)

    ;; インサートステートでのキーマップをEmacsにちょっと寄せる
    ;; nilを定義するとEmacsデフォルトの挙動になる
    (define-key evil-insert-state-map (kbd "TAB") 'nil)
    (define-key evil-insert-state-map (kbd "C-a") 'nil)
    (define-key evil-insert-state-map (kbd "C-e") 'nil)
    (define-key evil-insert-state-map (kbd "C-n") 'nil)
    (define-key evil-insert-state-map (kbd "C-p") 'nil)
    (define-key evil-insert-state-map (kbd "C-f") 'nil)
    (define-key evil-insert-state-map (kbd "C-b") 'nil)
    (define-key evil-insert-state-map (kbd "C-k") 'nil)
    (define-key evil-insert-state-map (kbd "C-r") 'nil)
    ))

(use-package evil-leader
  :ensure t
  :config
  ;; global-evil-leader-modeが未設定の場合のみ、有効化
  (unless (bound-and-true-p global-evil-leader-mode)
    (global-evil-leader-mode 1))
  ;; リーダーキーとしてスペースキーを設定
  (evil-leader/set-leader "<SPC>"))

(evil-leader/set-key
  "<SPC>" 'execute-extended-command
  "c" 'org-capture
  "a" 'org-agenda
  "rc" 'org-roam-capture
  "rf" 'org-roam-node-find
  "ri" 'org-roam-node-insert
  "rg" 'org-id-get-create
  )

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1)
  :config
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets")
  (yas-reload-all))

(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  ;;(setq projectile-project-search-path '("~/projects"))
  (setq projectile-globally-ignored-files '("*.jpg" "*.png"))
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package org
  :custom
  (org-directory "~/Dropbox/org/")
  (org-use-speed-commands t)
  (org-log-done 'time)
  (org-md-export-with-toc nil)
  :config
  ;; org-captureのテンプレート
  (custom-set-variables
   '(org-capture-templates
     `(("u" "Todo with Link" entry (file+headline ,(concat org-directory "todo.org") "Todo")
        "* TODO %?\n  %i\n  %a")
       ("t" "Todo" entry (file+headline ,(concat org-directory "todo.org") "Todo")
        "* TODO %?\n SCHEDULED: %t\n")
       ("m" "Memo" entry (file+headline ,(concat org-directory "memo.org") "Memo")
        "* %?\n")
       ("n" "Memo with Link" entry (file+headline ,(concat org-directory "memo.org") "Memo")
        "* %?\nEntered on %U\n  %i\n  %a")
       ("j" "Journal" entry (file ,(concat org-directory "journal.org"))
        "* %<%Y-%m-%d>\n%?\n%i\n"))))
  ;; org-agendaのファイル
  (setq org-agenda-files (directory-files-recursively (expand-file-name org-directory) "\\.org$"))
  :bind
  ("C-c c" . org-capture)
  ("C-c a" . org-agenda))

(use-package org-roam
  :ensure t
  :custom ((org-roam-directory org-directory))
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c r" . org-roam-capture))
  :config
  '(org-roam-setup)
  ;; キャプチャテンプレートの設定
  (setq org-roam-capture-templates
        '(("f" "Fleeting(一時メモ)" plain "%?"
           :target (file+head "fleeting/%<%Y%m%d%H%M%S>-${slug}.org" "#+TITLE: ${title}\n")
           :unnarrowed t)
          ("l" "Literature(文献)" plain "%?"
           :target (file+head "literature/%<%Y%m%d%H%M%S>-${slug}.org" "#+TITLE: ${title}\n")
           :unnarrowed t)
          ("p" "Permanent(記事)" plain "%?"
           :target (file+head "permanent/%<%Y%m%d%H%M%S>-${slug}.org" "#+TITLE: ${title}\n")
           :unnarrowed t)
          ("b" "Publish(ブログ・Zenn・Qiitaなど)" plain "%?"
           :target (file+head "publish/${slug}.org" "#+TITLE: ${title}\n")
           :unnarrowed t))))

(use-package ox-gfm
  :ensure t
  :after org)

(use-package dired-toggle
  :ensure t
  :bind (("C-x -" . dired-toggle))
  :config
  )

(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here

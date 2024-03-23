;; this enables this running method
;;   emacs -q -l ~/.debug.emacs.d/{{pkg}}/init.el
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("org"   . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu"   . "https://elpa.gnu.org/packages/")))
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

;; ここにいっぱい設定を書く

;; エラー出力レベル                                        ;
(setq display-warning-minimum-level :error)

;; メニューツールバーの削除
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; フォント設定 -- Cicaフォント
(set-face-attribute 'default nil
                    :family "Cica"
                    :height 180)

;; colorscheme設定
(leaf monokai-theme
  :ensure t
  :config
  ;; テーマの有効化
  (load-theme 'monokai t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; which-keyのインストール
(leaf which-key
  :ensure t
  :config
  (which-key-mode 1))

;; ダッシュボードの変更
(leaf dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents  . 5)
                          (bookmarks . 5)
                          (projects . 5))))

;; 自動補完の設定
(leaf corfu
  :ensure t
  :custom
  ((corfu-cycle . t) ;; 候補のループを有効にする
   (corfu-auto . t) ;; 自動補完を有効にする
   (corfu-auto-prefix . 2) ;; 補完候補を二文字で出す
   )
  :global-minor-mode global-corfu-mode)

;; vertico - M-xをファジーファインダーっぽくする
(leaf vertico
  :ensure t
  :custom
  (vertico-cycle . t) ;; 一番下の選択肢からさらに下に行こうとすると最初に戻る
  :init
  (vertico-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-modeの設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; orgのディレクトリ設定
;; org-directoryの設定
(setq org-dir "~/Dropbox/org/")

(leaf org
  :custom
  (org-directory . org-dir)
  :config
  ;; org-captureのテンプレート
  (setq org-capture-templates
        `(("t" "Todo" entry (file+headline ,(concat org-dir "todo.org") "Todo")
           "* TODO %?\n  %i\n  %a")
          ("n" "Note" entry (file+headline ,(concat org-dir "memo.org") "Memo")
           "* %?\nEntered on %U\n  %i\n  %a")
          ("j" "Journal" entry (file+headline ,(concat org-dir "journal.org") "Journal")
           "* %U\n%?\n%i\n")))

  ;; org-agendaのファイル
  (setq org-agenda-files (list (concat org-directory "tasks.org")
                               (concat org-directory "calendar.org")))

  ;; org-modeのキー設定
  (global-set-key "\C-cc" 'org-capture) ;; org-capture
  (define-key global-map "\C-ca" 'org-agenda)) ;; org-agenda

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; オリジナルキーマップ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; カーソル位置から行頭まで削除する
(leaf *backward-kill-line
  :config
  (defun backward-kill-line (arg)
  "Kill chars backward until encountering the end of a line."
  (interactive "p")
  (kill-line 0))
  ;; C-uに設定
  (global-set-key (kbd "C-u") 'backward-kill-line)
  ;; 元のC-uの挙動をC-.へ割当
  (global-set-key (kbd "C-.") 'universal-argument))

(leaf *disable-ctrl-x-ctrl-c
  :config
  (global-set-key (kbd "C-x C-c") 'ignore))


(leaf leaf
  :config
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom ((imenu-list-size . 30)
             (imenu-list-position . 'left))))

(leaf macrostep
  :ensure t
  :bind (("C-c e" . macrostep-expand)))

(provide 'init)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(blackout el-get hydra leaf-keywords leaf)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here

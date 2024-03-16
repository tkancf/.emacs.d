;; 行番号の表示
(global-linum-mode t)

;; シンタックスハイライトの強化
(global-font-lock-mode t)

;; バックアップファイルを作成しない
(setq make-backup-files nil)

;; 自動保存ファイルを作成しない
(setq auto-save-default nil)

;; スタートアップメッセージを非表示
(setq inhibit-startup-message t)

;; カーソルの点滅を止める
(blink-cursor-mode 0)

;; タブにスペースを使用
(setq-default indent-tabs-mode nil)

;; タブ幅
(setq-default tab-width 4)

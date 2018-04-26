(require 'package)

;; Use emacs as our editor 
(server-start)

;; Enable MELPA
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
		     (not (gnutls-available-p))))
	(proto (if no-ssl "http" "https")))
     (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/"))))
(package-initialize)

(put 'downcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cider-annotate-completion-candidates t)
 '(cider-auto-jump-to-error (quote errors-only))
 '(cider-auto-select-error-buffer nil)
 '(cider-show-error-buffer (quote except-in-repl))
 '(custom-safe-themes
   (quote
    ("73a13a70fd111a6cd47f3d4be2260b1e4b717dbf635a9caee6442c949fad41cd" "b59d7adea7873d58160d368d42828e7ac670340f11f36f67fa8071dbf957236a" "c3d4af771cbe0501d5a865656802788a9a0ff9cf10a7df704ec8b8ef69017c68" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(org-agenda-files
   (quote
    ("~/notes/envs100/week1.org" "~/notes/psyc100/syllabus.org" "~/notes/math238/syllabus.org" "~/notes/class-schedule-winter-2018.org")))
 '(org-startup-truncated nil)
 '(package-selected-packages
   (quote
    (airline-themes monokai-theme org-bullets powerline-evil syndicate ## ac-cider rotate smartparens evil restart-emacs auto-complete simpleclip ace-window avy solarized-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-theme 'monokai)

;;Functions
(setq ring-bell-function
      (lambda ()
        (let ((orig-fg (face-foreground 'mode-line)))
          (set-face-foreground 'mode-line "#F2804F")
          (run-with-idle-timer 0.1 nil
	    (lambda (fg) (set-face-foreground 'mode-line fg))
	    orig-fg))))

;; Keybinds
(global-set-key (kbd "C-c j") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "M-p") 'ace-window)
(global-set-key (kbd "C-c a") 'org-agenda)
(require 'auto-complete-config)
(ac-config-default)
(setq inhibit-splash-screen t)
(setq org-todo-keywords
  '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))
(add-hook 'dired-load-hook '(lambda () (require 'dired-x))) ; Load Dired X when Dired is loaded.
    (setq dired-omit-mode t) ; Turn on Omit mode.
(require 'smartparens-config)
(require 'ac-cider)
(defun sp-config ()
  (progn
    (smartparens-strict-mode)
    (ac-flyspell-workaround)
    (ac-cider-setup)
    (local-set-key (kbd "C-<right>") 'sp-forward-slurp-sexp)
    (local-set-key (kbd "C-<left>") 'sp-backward-slurp-sexp)
    (local-set-key (kbd "M-<right>") 'sp-forward-barf-sexp)
    (local-set-key (kbd "M-<left>") 'sp-backward-barf-sexp)))

(mapc (lambda (f) (add-hook f #'sp-config)) '(cider-mode-hook cider-repl-mode-hook clojure-mode-hook emacs-lisp-mode-hook))

(setq cider-repl-display-help-banner nil)
(eval-after-load "auto-complete"
  '(progn
     (add-to-list 'ac-modes 'cider-mode)
     (add-to-list 'ac-modes 'cider-repl-mode)))

(defalias 'ispl 'ispell)

(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)
(require 'syndicate)
(require 'powerline)
(require 'powerline-evil)
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(key-chord-mode 1)
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
(dumb-jump-mode 1)
(require 'airline-themes)
(load-theme 'airline-molokai)
(custom-theme-set-faces
 'airline-molokai
 `(minibuffer-prompt ((t (:foreground nil :background nil :inherit 'default)))))
(menu-bar-mode -1)
(tool-bar-mode -1)
(linum-mode)
(scroll-bar-mode -1)
(require 'helm-config)
(redraw-display)
(setq org-ellipsis "⤵")

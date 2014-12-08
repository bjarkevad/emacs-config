;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

;; Variables
(setq-default
 ;; List of additional paths where to look for configuration layers.
 ;; Paths must have a trailing slash (ie. `~/.mycontribs/')
 dotspacemacs-configuration-layer-path '()
 ;; List of contribution to load.
 dotspacemacs-configuration-layers '(themes-megapack python auctex misc company-mode haskell)
 ;; If non nil the frame is maximized when Emacs starts up (Emacs 24.4+ only)
 dotspacemacs-fullscreen-at-startup nil
 ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth scrolling
 ;; overrides the default behavior of Emacs which recenters the point when
 ;; it reaches the top or bottom of the screen
 dotspacemacs-smooth-scrolling t
 ;; If non nil pressing 'jk' in insert state, ido or helm will activate the
 ;; evil leader.
 dotspacemacs-feature-toggle-leader-on-jk nil
 ;; A list of packages and/or extensions that will not be install and loaded.
 dotspacemacs-excluded-packages '()
 ;; The default package repository used if no explicit repository has been
 ;; specified with an installed package.
 ;; Not used for now.
 dotspacemacs-default-package-repository nil
 )

;; Functions

(defun dotspacemacs/init ()
  "User initialization for Spacemacs. This function is called at the very
 startup."
  ;;(load-theme 'hc-zenburn)
  )

(defun dotspacemacs/config ()
  "This is were you can ultimately override default Spacemacs configuration.
This function is called at the very end of Spacemacs initialization."
  (setq powerline-default-separator 'bar)
  (load-theme 'hc-zenburn)
  ;; esc quits
  (defun minibuffer-keyboard-quit ()
    "Abort recursive edit.
    In Delete Selection mode, if the mark is active, just deactivate it;
    then it takes a second \\[keyboard-quit] to abort the minibuffer."
    (interactive)
    (if (and delete-selection-mode transient-mark-mode mark-active)
        (setq deactivate-mark  t)
      (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
      (abort-recursive-edit)))
  (define-key evil-normal-state-map [escape] 'keyboard-quit)
  (define-key evil-visual-state-map [escape] 'keyboard-quit)
  (define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
  (global-set-key [escape] 'evil-exit-emacs-state)
  (setq flycheck-check-syntax-automatically '(save idle-change mode-enabled))
  ;; (setq global-auto-complete-mode 0)

  (let ((font "Source Code Pro"))
    (when (member font (font-family-list))
      (pcase window-system
        (`x (spacemacs/set-font font 10))
        (other (spacemacs/set-font font 12)))))
  (pcase window-system
    (`x (menu-bar-mode 0))
    (other (menu-bar-mode 1)))

      (add-to-list 'evil-emacs-state-modes 'helm-mode)
      ;;(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
      ;;(define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
      ;;(define-key evil-insert-state-map (kbd "C-u")
      ;; (lambda ()
      ;;(interactive)
      ;;(evil-delete (point-at-bol) (point))))

      ;; FLYCHECK
      (add-hook 'after-init-hook #'global-flycheck-mode)

      ;; HASKELL
      ;(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
      (custom-set-variables
        '(haskell-process-type 'cabal-repl)
        '(haskell-process-suggest-remove-import-lines t)
        '(haskell-process-auto-import-loaded-modules t)
        '(haskell-process-log t))

      (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
      (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
      ;; (eval-after-load "haskell-mode"
      ;;   '(define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile))
      ;; (eval-after-load "haskell-cabal"
      ;;   '(define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile))

      (evil-define-key 'insert haskell-interactive-mode-map (kbd "RET") 'haskell-interactive-mode-return)
      (evil-define-key 'normal haskell-interactive-mode-map (kbd "RET") 'haskell-interactive-mode-return)

      (setq haskell-stylish-on-save t)

      ;rebind inferior mode to interactive mode
      (eval-after-load "haskell-mode"
                       '(progn
                          (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
                          (define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
                          (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
                          (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
                          (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
                          (define-key haskell-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
                          (define-key haskell-mode-map (kbd "C-c c") 'haskell-process-cabal)
                          (define-key haskell-mode-map (kbd "C-c i") 'haskell-mode-jump-to-def-or-tag)
                          (define-key haskell-mode-map (kbd "C-c C-d") 'inferior-haskell-find-haddock)
                          (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)))
      ;     (define-key haskell-cabal-mode-map (kbd "C-`") 'haskell-interactive-bring)
      ;     (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
      ;     (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
      ;     (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)))

      ;; SNAP
      (add-to-list 'auto-mode-alist '("\\.tpl\\'" . xml-mode))
  )


;; Custom variables

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-ispell-requires 4)
 '(ahs-case-fold-search nil)
 '(ahs-default-range (quote ahs-range-whole-buffer))
 '(ahs-idle-interval 0.25)
 '(ahs-inhibit-face-list nil)
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("4217c670c803e8a831797ccf51c7e6f3a9e102cb9345e3662cc449f4c194ed7d" "1affe85e8ae2667fb571fc8331e1e12840746dae5c46112d5abb0c3a973f5f5a" "41b6698b5f9ab241ad6c30aea8c9f53d539e23ad4e3963abff4b57c0f8bf6730" default)))
 '(ring-bell-function (quote ignore) t)
 '(show-paren-mode t)
 '(tool-bar-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil)))))

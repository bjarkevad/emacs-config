;;; -*- mode: emacs-lisp -*-

(setq-default
 dotspacemacs-configuration-layer-path '()
 dotspacemacs-configuration-layers '(auctex company-mode haskell git osx themes)
 dotspacemacs-fullscreen-at-startup t
 dotspacemacs-smooth-scrolling t
 dotspacemacs-feature-toggle-leader-on-jk nil
 dotspacemacs-excluded-packages '(smartparens)
 dotspacemacs-default-package-repository nil
 dotspacemacs-default-theme 'hc-zenburn
 )

(defun dotspacemacs/init ()
  "User initialization for Spacemacs. This function is called at the very
 startup."
  (add-to-list 'exec-path "~/.cabal/bin/")
  )

(defun dotspacemacs/config ()
  "This is were you can ultimately override default Spacemacs configuration.
This function is called at the very end of Spacemacs initialization."
  (setq powerline-default-separator 'bar)
  (setq magit-repo-dirs '("~/Workspace/"))

  (evil-leader/set-key
    "ass" 'multi-term-next)

  (evil-leader/set-key "TAB" 'spacemacs/alternate-buffer)

  (setq flycheck-check-syntax-automatically '(save idle-change mode-enabled))
  (setq system-uses-terminfo nil)

  (global-linum-mode t)
  (linum-relative-toggle)
  (spacemacs/toggle-golden-ratio)

  (set-face-attribute 'fringe nil :background "#3F3F3F" :foreground "#3F3F3F")
  (set-face-attribute 'linum nil :background "#3F3F3F")

  (add-to-list 'evil-emacs-state-modes 'helm-mode)
  (add-hook 'after-init-hook #'global-flycheck-mode)

  (evil-leader/set-key "TAB" 'spacemacs/alternate-buffer)

  (pcase window-system
    (`x    (progn
             (spacemacs/set-font "Termsyn" 11)
             (menu-bar-mode 0)
             ))
    (other (progn
             (spacemacs/set-font "Menlo" 12)
             (menu-bar-mode 1)
             ))
    )

  (defun haskell-addons()
    (print "haskell addons loaded")
    )

  (eval-after-load "haskell"
    'haskell-addons
    )
)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-ispell-requires 4)
 '(ahs-case-fold-search nil)
 '(ahs-default-range (quote ahs-range-whole-buffer))
 '(ahs-idle-interval 0.25)
 '(ahs-idle-timer 0 t)
 '(ahs-inhibit-face-list nil)
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(company-idle-delay 0.0)
 '(custom-safe-themes
   (quote
    ("4217c670c803e8a831797ccf51c7e6f3a9e102cb9345e3662cc449f4c194ed7d" "1affe85e8ae2667fb571fc8331e1e12840746dae5c46112d5abb0c3a973f5f5a" "41b6698b5f9ab241ad6c30aea8c9f53d539e23ad4e3963abff4b57c0f8bf6730" default)))
 '(flycheck-check-syntax-automatically (quote (save idle-change mode-enabled)))
 '(flycheck-idle-change-delay 0.5)
 '(guide-key/idle-delay 0.4)
 ;; '(haskell-interactive-popup-error nil)
 ;; '(haskell-notify-p t)
 ;; '(haskell-process-auto-import-loaded-modules t)
 ;; '(haskell-process-suggest-remove-import-lines t)
 ;; '(haskell-process-type (quote cabal-repl))
 ;; '(haskell-stylish-on-save nil)
 ;; '(haskell-tags-on-save t)
 '(paradox-github-token t)
 '(ring-bell-function (quote ignore) t)
 '(show-paren-mode t)
 '(smartparens-global-mode t)
 '(sp-autoinsert-if-followed-by-word nil)
 '(tool-bar-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil))))
 '(company-tooltip-annotation ((t (:inherit company-tooltip :foreground "Brown"))))
 '(company-tooltip-common ((t (:inherit company-tooltip :weight bold :underline nil))))
 '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :weight bold :underline nil))))
 '(evil-search-highlight-persist-highlight-face ((t (:background "selectedMenuItemColor"))))
 '(sp-pair-overlay-face ((t (:background "#444455")))))

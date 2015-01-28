;;; -*- mode: emacs-lisp -*-

(setq-default
 dotspacemacs-configuration-layer-path '()
 dotspacemacs-configuration-layers '(auctex company-mode haskell git osx themes misc)
 dotspacemacs-smooth-scrolling t
 dotspacemacs-feature-toggle-leader-on-jk nil
 dotspacemacs-excluded-packages '() 
 dotspacemacs-default-package-repository nil
 dotspacemacs-themes '(hc-zenburn)
 )

(pcase window-system
  (`x
   (setq-default
    dotspacemacs-default-font '("Termsyn"
                                :size 14
                                :weight normal
                                :width normal
                                :powerline-offset 2)))
  (`mac
   (setq-default
    dotspacemacs-fullscreen-use-non-native t
    dotspacemacs-fullscreen-at-startup t
    dotspacemacs-default-font '("Menlo"
                                :size 12
                                :weight normal
                                :width normal
                                :powerline-offset 2))))

(defun dotspacemacs/init ()
  "User initialization for Spacemacs. This function is called at the very
 startup."
  (add-to-list 'exec-path "~/.cabal/bin/")
  )

(defun dotspacemacs/config ()
  "This is were you can ultimately override default Spacemacs configuration.
This function is called at the very end of Spacemacs initialization."
  (add-hook 'after-init-hook #'global-flycheck-mode)

  (setq powerline-default-separator 'arrow)
  (setq magit-repo-dirs '("~/Workspace/"))
  (setq system-uses-terminfo nil)

  (evil-leader/set-key "TAB" 'spacemacs/alternate-buffer)

  (global-linum-mode t)
  (linum-relative-toggle)
  (spacemacs/toggle-golden-ratio)

  (set-face-attribute 'fringe nil :background "#3F3F3F" :foreground "#3F3F3F")
  (set-face-attribute 'linum nil :background "#3F3F3F")

  (add-to-list 'evil-emacs-state-modes 'helm-mode)

  (pcase window-system
    (`x (progn (menu-bar-mode 0)))
    (`mac (progn (menu-bar-mode 1)))
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
 '(flycheck-idle-change-delay 0.5)
 '(guide-key/idle-delay 0.4)
 '(haskell-interactive-popup-error nil)
 '(haskell-notify-p t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-type (quote auto))
 '(haskell-stylish-on-save nil)
 '(haskell-tags-on-save t)
 '(paradox-github-token t)
 '(ring-bell-function (quote ignore) t)
 '(show-paren-mode t)
 '(sp-autoinsert-if-followed-by-same 0)
 '(sp-autoinsert-if-followed-by-word nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;; '(default ((t (:inherit nil :stipple nil :background "#313131" :foreground "#DCDCCC" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "Misc" :family "Termsyn"))))
 '(company-tooltip-annotation ((t (:inherit company-tooltip :foreground "Brown"))))
 '(company-tooltip-common ((t (:inherit company-tooltip :weight bold :underline nil))))
 '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :weight bold :underline nil))))
 '(evil-search-highlight-persist-highlight-face ((t (:background "selectedMenuItemColor"))))
 '(region ((t (:inverse-video t))))
 '(sp-pair-overlay-face ((t (:background "#444455")))))

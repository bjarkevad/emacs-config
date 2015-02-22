;;; -*- mode: emacs-lisp -*-

(setq-default
 dotspacemacs-configuration-layer-path '("~/.emacsprivate/private/")
 dotspacemacs-configuration-layers '(
                                     auctex
                                     company-mode
                                     (haskell :variables
                                              haskell-ghci-ng-support t)
                                     git
                                     osx
                                     themes
                                     scala
                                     misc
                                     markdown)
 dotspacemacs-smooth-scrolling t
 dotspacemacs-feature-toggle-leader-on-jk nil
 dotspacemacs-excluded-packages '() 
 dotspacemacs-default-package-repository nil
 dotspacemacs-themes '(hc-zenburn)
 configuration-layer-private-directory "~/.emacsprivate/private/"
 )

(pcase window-system
  (`x
   (setq-default
    dotspacemacs-default-font '("Terminus"
                                :size 12
                                :weight normal
                                :width normal
                                :powerline-offset 2)))
  (`mac
   (setq-default
    dotspacemacs-fullscreen-use-non-native t
    dotspacemacs-fullscreen-at-startup t
    dotspacemacs-default-font '("Source Code Pro"
                                :size 12
                                :weight normal
                                :width normal
                                :powerline-offset 2))))

(defun dotspacemacs/init ()
  "User initialization for Spacemacs. This function is called at the very
 startup."
  (add-to-list 'exec-path "~/.OmniSharp/")
  (add-to-list 'exec-path "~/.cabal-emacs/.cabal-sandbox/bin/")
  )

(defun dotspacemacs/config ()
  "This is were you can ultimately override default Spacemacs configuration.
This function is called at the very end of Spacemacs initialization."
  ;;(company-emacs-eclim-setup)
  
  (if (equal window-system `mac)
      (progn
        (setq load-path (cons "~/.emacsprivate/02263/" load-path))
        (load "rsltc.el")
        (load "rsl-mode.el")
        (load "rslconvert.el")

        (defun rsl2latex ()
          "Do rslatex on buffer"
          (interactive)
          (do-latex))

        (defun latex2rsl ()
          "Undo rslatex on buffer"
          (interactive)
          (undo-latex))

        (evil-leader/set-key-for-mode 'rsl-mode
          "ml" 'rsl2latex
          "mL" 'latex2rsl
          "mc" 'rsltc-cc
          )))

  (add-hook 'after-init-hook #'global-flycheck-mode)

  (setq powerline-default-separator 'arrow)
  (setq magit-repo-dirs '("~/Workspace/"))
  (setq system-uses-terminfo nil)
  (setq omnisharp-server-executable-path "~/.OmniSharp/OmniSharpServer")

  (evil-leader/set-key "TAB" 'spacemacs/alternate-buffer)
  (evil-define-key 'normal evil-org-mode-map "O" 'evil-open-above)

  (global-linum-mode t)
  (linum-relative-toggle)
  (spacemacs/mode-line-minor-modes-toggle)
  ;; (spacemacs/toggle-golden-ratio)

  (set-face-attribute 'fringe nil :background "#3F3F3F" :foreground "#3F3F3F")
  (set-face-attribute 'linum nil :background "#3F3F3F")

  (add-to-list 'evil-emacs-state-modes 'helm-mode)

  ;;(setq projectile-switch-project-action 'neotree-projectile-action)


  (defun neotree-find-project-root ()
    (interactive)
    (neotree-find (projectile-project-root)))

  (evil-leader/set-key "fT" 'neotree-find-project-root)

  (setq helm-prevent-escaping-from-minibuffer t)

  (pcase window-system
    (`x    (progn
             (menu-bar-mode 0)
             ))
    (other (progn
             (setq mac-command-modifier 'meta)
             (setq mac-option-modifier nil)
             (menu-bar-mode 1)
             (spacemacs/mode-line-battery-info-toggle)
             ))
    )

  ;; SQL
  (add-hook 'sql-mode-hook 'edbi-minor-mode)
  (add-hook 'sql-interactive-mode-hook
            (lambda ()
              (toggle-truncate-lines t)))

  ;; NXTOFF

  ; set default DB
  (setq sql-postgres-login-params
        '((user :default "postgres")
          (database :default "nxtoff")
          (server :default "localhost")
          (post :default 5432)
          ))
  
  (setq sql-connection-alist
        '((nxtoff-test (sql-product 'postgres)
                       (sql-port 5432)
                       (sql-server "localhost")
                       (sql-user "nxtoff")
                       (sql-password "password")
                       (sql-database "nxtoff_test")
                       )
        (nxtoff-prod (sql-product 'postgres)
                     (sql-port 5432)
                     (sql-server "localhost")
                     (sql-user "nxtoff")
                     (sql-password "password")
                     (sql-database "nxtoff_prod")
                     )))

  (defun nxtoff-db/test ()
    (interactive)
    (my-sql-connect 'postgres 'nxtoff-test))

  (defun my-sql-connect (product connection)
    (setq sql-product product)
    (sql-connect connection))

  (defvar database-servers-list
    '(("nxtoff-test" nxtoff-db/test))
    "Alist of server name and the function to connect")

  (defun helm-connect-database (func)
    "Connect to the input server using database-servers-list"
    (interactive
     (helm-comp-read "Select server: " database-servers-list))
    (funcall func)
    )

  (evil-leader/set-key
    "od" 'helm-connect-database
    "oa" 'sql-set-sqli-buffer
    )

  (defun gen-ensime ()
     (interactive)
     (sbt-command "gen-ensime")
     )

  (evil-leader/set-key-for-mode 'scala-mode
    "mnq" 'ensime-shutdown
    "mng" 'gen-ensime
    )

  (evil-leader/set-key
    "of" 'make-frame)
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
 '(company-idle-delay 0.0)
 '(ensime-goto-test-config-defaults
   (quote
    (:test-class-names-fn ensime-goto-test--test-class-names :test-class-suffixes
                          ("Test" "Spec" "Specification" "Check")
                          :impl-class-name-fn ensime-goto-test--impl-class-name :impl-to-test-dir-fn ensime-goto-test--impl-to-test-dir :is-test-dir-fn ensime-goto-test--is-test-dir :test-template-fn ensime-goto-test--test-template-scalatest-2)))
 '(evil-search-highlight-persist t)
 '(flycheck-idle-change-delay 0.5)
 '(global-evil-search-highlight-persist t)
 '(gud-gdb-command-name "gdb --annotate=1")
 '(guide-key/idle-delay 0.4)
 '(haskell-interactive-popup-error nil)
 '(haskell-notify-p t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-type (quote auto))
 ;; '(haskell-stylish-on-save nil)
 '(haskell-tags-on-save t)
 '(large-file-warning-threshold nil)
 '(org-agenda-files
   (quote
    ("~/Google Drive/School/IPD/ipd.org" "~/Google Drive/School/FA/fa.org" "~/ITM/plzcome/plzcome.org" "~/Google Drive/notes.org" "~/Google Drive/School/AI/ai.org" "~/Google Drive/School/2.org")))
 '(org-clock-continuously t)
 '(org-clock-idle-time 15)
 '(org-clock-persist t)
 '(paradox-github-token t)
 '(ring-bell-function (quote ignore) t)
 '(scala-indent:align-forms t)
 '(scala-indent:align-parameters t)
 '(scala-indent:default-run-on-strategy scala-indent:operator-strategy)
 '(show-paren-mode nil)
 '(sp-autoescape-string-quote nil)
 '(sp-autoskip-opening-pair nil)
 '(sp-cancel-autoskip-on-backward-movement nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;; '(default ((t (:foreground "#DCDCCC" :background "#313131"))))
 '(company-tooltip-annotation ((t (:inherit company-tooltip :foreground "Brown"))))
 '(company-tooltip-common ((t (:inherit company-tooltip :weight bold :underline nil))))
 '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :weight bold :underline nil))))
 '(evil-search-highlight-persist-highlight-face ((t (:background "selectedMenuItemColor"))))
 '(region ((t (:inverse-video t))))
 '(sp-pair-overlay-face ((t (:background "#444455")))))

;;; -*- mode: emacs-lisp -*-

(setq-default
 dotspacemacs-configuration-layer-path '("~/.emacsprivate/private/")
dotspacemacs-configuration-layers '(
                                     fasd
                                     auctex
                                     (company-mode :variables
                                                   company-mode-enable-yas t
                                                   company-mode-use-tab-instead-of-enter t
                                                   )
                                     (haskell :variables
                                              haskell-enable-ghci-ng-support t
                                              haskell-enable-shm-support t
                                              haskell-enable-hindent-support t
                                              )
                                     (git :variables
                                         ;;git-enable-github-support t
                                          )
                                     osx
                                     themes
                                     scala
                                     misc
                                     markdown
                                     )
 dotspacemacs-smooth-scrolling t
 dotspacemacs-feature-toggle-leader-on-jk nil
 dotspacemacs-excluded-packages '()
 dotspacemacs-default-package-repository nil
 dotspacemacs-themes '(hc-zenburn)
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
  (progn
    (add-to-list 'exec-path "~/.OmniSharp/")
    (add-to-list 'exec-path "~/.cabal-emacs/.cabal-sandbox/bin/"))
  )

(defun dotspacemacs/config ()
  "This is were you can ultimately override default Spacemacs configuration.
This function is called at the very end of Spacemacs initialization."
  ;;(company-emacs-eclim-setup)
  (add-to-list 'exec-path "~/.cabal-emacs/.cabal-sandbox/bin/")
  ;; (progn (yas-global-mode 1)
  ;;        (setq yas-snippet-dirs (append '("~/.emacsprivate/private/snippets") yas-snippet-dirs)))
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

   (progn
     (yas-global-mode 1)
     (define-key yas-minor-mode-map (kbd "<tab>") nil)
     (define-key yas-minor-mode-map (kbd "TAB") nil)
     (define-key yas-minor-mode-map (kbd "<backtab>") 'yas-expand))

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

  (defun haskell/enable-eldoc ()
    (setq-local eldoc-documentation-function
                (lambda ()
                  (haskell/haskell-show-type)))
    (eldoc-mode +1))

  (defun haskell/haskell-show-type ()
    (interactive)
    (if haskell-enable-ghci-ng-support
        (haskell-mode-show-type-at)
      (haskell-process-do-type)))

      (add-hook 'haskell-mode-hook 'haskell/enable-eldoc)


  ;; (defun neotree-find-project-root ()
  ;;   (interactive)
  ;;   (if (neo-global--window-exists-p)
  ;;       (neotree-hide)
  ;;     (neotree-find (projectile-project-root))))

  ;; (evil-leader/set-key "pt" 'neotree-find-project-root)

  (setq helm-prevent-escaping-from-minibuffer t)

  (pcase window-system
    (`x    (progn
             (menu-bar-mode 0)
             ))
    (other (progn
             ;; (setq mac-command-modifier 'meta)
             ;; (setq mac-option-modifier nil)
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
    "oq" 'ielm
    "of" 'make-frame
    "os" 'helm-yas-create-snippet-on-region
    "oe" 'yas-visit-snippet-file
    "or" 'yas-reload-all
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
 '(company-auto-complete-chars (quote (32 41 46)))
 '(company-idle-delay 0.0)
 '(ensime-company-case-sensitive t)
 '(ensime-goto-test-config-defaults
   (quote
    (:test-class-names-fn ensime-goto-test--test-class-names :test-class-suffixes
                          ("Test" "Spec" "Specification" "Check")
                          :impl-class-name-fn ensime-goto-test--impl-class-name :impl-to-test-dir-fn ensime-goto-test--impl-to-test-dir :is-test-dir-fn ensime-goto-test--is-test-dir :test-template-fn ensime-goto-test--test-template-scalatest-2)))
 '(ensime-inf-default-cmd-line (quote ("sbt" "console")))
 '(evil-search-highlight-persist t t)
 '(flycheck-idle-change-delay 0.5)
 '(global-evil-search-highlight-persist t)
 '(gud-gdb-command-name "gdb --annotate=1")
 '(guide-key/idle-delay 0.4)
 '(haskell-interactive-popup-error nil)
 '(haskell-notify-p t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-type (quote auto))
 '(haskell-stylish-on-save nil)
 '(haskell-tags-on-save t)
 '(helm-ag-fuzzy-match t)
 '(helm-ag-use-grep-ignore-list nil)
 '(hindent-style "chris-done")
 '(large-file-warning-threshold nil)
 '(org-agenda-files
   (quote
    ("~/ITM/plzcome/plzcome-clocks.org" "~/Google Drive/School/IPD/ipd.org" "~/Google Drive/School/FA/fa.org" "~/ITM/plzcome/plzcome.org" "~/Google Drive/notes.org" "~/Google Drive/School/AI/ai.org" "~/Google Drive/School/2.org")))
 '(org-clock-continuously nil)
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
 '(sp-cancel-autoskip-on-backward-movement nil)
 '(yas-prompt-functions
   (quote
    (yas-ido-prompt yas-dropdown-prompt yas-x-prompt yas-no-prompt))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:foreground "#DCDCCC" :background "#313131"))))
 '(company-tooltip-annotation ((t (:inherit company-tooltip :foreground "Brown"))))
 '(company-tooltip-common ((t (:inherit company-tooltip :weight bold :underline nil))))
 '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :weight bold :underline nil))))
 '(evil-search-highlight-persist-highlight-face ((t (:background "selectedMenuItemColor"))))
 '(region ((t (:inverse-video t))))
 '(sp-pair-overlay-face ((t (:background "#444455")))))

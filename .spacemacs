
;;; -*- mode: emacs-lisp -*-

(setq-default
 dotspacemacs-configuration-layer-path '("~/.emacsprivate/private/")
 ;;dotspacemacs-smooth-scrolling t
 dotspacemacs-feature-toggle-leader-on-jk nil
 dotspacemacs-excluded-packages '()
 dotspacemacs-default-package-repository nil
 dotspacemacs-themes '(hc-zenburn)
 dotspacemacs-configuration-layers '(
                                     (auto-completion :variables
                                                      auto-completion-enable-help-tooltip t
                                                      auto-completion-enable-sort-by-usage t)

                                     (syntax-checking :variables
                                                      syntax-checking-enable-tooltips nil)

                                     (haskell :variables
                                              ;; haskell-enable-ghci-ng-support t
                                              ;; haskell-enable-shm-support t
                                              ;; haskell-enable-stack-support t
                                              haskell-enable-hindent-style "chris-done")

                                     (shell :variables
                                            shell-default-shell 'ansi-term
                                            shell-default-position "bottom"
                                            shell-default-height 30
                                            shell-default-term-shell "/usr/bin/zsh"
                                            )

                                     ;; (c-c++ :variables
                                     ;;        c-c++-enable-clang-support t
                                     ;;        )

                                     ;; (clojure :variables clojure-enable-fancify-symbols)

                                     ;; scala

                                     latex
                                     emacs-lisp
                                     javascript
                                     sql
                                     html

                                     sematic
                                     git
                                     version-control
                                     org
                                     themes-megapack
                                     markdown
                                     misc
                                     ;; pandoc
                                     ;; extra-langs
                                     ;; fasd
                                     ;; html
                                     ;; javascript
                                     )
 )

(pcase window-system
  (`x
   (pcase system-name
     ("mbp"
      (setq-default
       dotspacemacs-default-font '("Terminus"
                                   :size 20
                                   :weight normal
                                   :width normal
                                   :powerline-offset 2)))
     ("desktop"
      (setq-default
       dotspacemacs-default-font '("Terminus"
                                   :size 12
                                   :weight normal
                                   :width normal
                                   :powerline-offset 2)))
     )
   )
  (`mac
   (setq-default
    dotspacemacs-fullscreen-use-non-native t
    dotspacemacs-fullscreen-at-startup t
    dotspacemacs-default-font '("Source Code Pro"
                                :size 12
                                :weight normal
                                :width normal
                                :powerline-offset 2))))

(pcase window-system
  (`x    (progn
           (menu-bar-mode 0)))
  (other (progn
           ;; (setq mac-command-modifier 'meta)
           ;; (setq mac-option-modifier nil)
           (menu-bar-mode 1)
           ;;(spacemacs/mode-line-battery-info-toggle)
           ))
  )

(defun dotspacemacs/init ()
  "User initialization for Spacemacs. This function is called at the very
 startup."

   (progn
    (add-to-list 'exec-path "~/.cabal/bin/")
    (add-hook 'haskell-mode-hook 'haskell-auto-insert-module-template)
  ;; (autoload 'haskell-indentation-enable-show-indentations "haskell-indentation")
  ;; (autoload 'haskell-indentation-disable-show-indentations "haskell-indentation")
   )

(defun language/clojure()
  (add-hook 'clojure-mode-hook (lambda ()
                                 (prettify-symbols-mode)
                                 )))
(defun language/latex()
  (progn
   (add-hook 'latex-mode-hook 'linum-mode)
   (add-hook 'LaTeX-mode-hook 'linum-mode)
  (setq-default TeX-engine 'xetex)
  (evil-leader/set-key-for-mode 'latex-mode
    "mv" 'TeX-view
    "mpC" 'preview-clearout-document))
    )

  ;; SQL
  ;; (add-hook 'sql-mode-hook 'edbi-minor-mode)
  (defun language/sql ()
    (progn
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
    )))

(defun language/rsl()
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
          "mr" 'rsltc-m-and-run
          )))

(defun language/haskell()
  (progn
    (add-to-list 'exec-path "~/.cabal/bin/")
    (setq ghc-debug t)
    (defvar ghc-interactive-command "ghc-modi")

  (defun haskell/enable-eldoc ()
    (setq-local eldoc-documentation-function
                (lambda ()
                  (if (haskell-session-maybe)
                      (haskell/haskell-show-type))))
    (eldoc-mode +1))

  (defun haskell/haskell-show-type ()
    (interactive)
    (if haskell-enable-ghci-ng-support
        (haskell-mode-show-type-at)
      (haskell-process-do-type)))

  ;; (add-hook 'haskell-mode-hook 'haskell/enable-eldoc)
    (evil-leader/set-key-for-mode 'haskell-mode
      "msr" 'haskell-process-restart)
    ))

(defun language/org ()
  (progn
    (evil-define-key 'normal evil-org-mode-map "O" 'evil-open-above)
    (evil-leader/set-key-for-mode 'org-mode
      "mp" 'org-preview-latex-fragment
      "mI" 'org-toggle-inline-images
      "mc" 'org-ctrl-c-ctrl-c
      )
    ))

(defun language/scala()
  (progn

    (defun gen-ensime ()
      (interactive)
      (sbt-command "gen-ensime")
      )

    (evil-leader/set-key-for-mode 'scala-mode
      "mnq" 'ensime-shutdown
      "mng" 'gen-ensime
      )))


(defun language/dot ()
  (progn
    (evil-leader/set-key-for-mode 'graphviz-dot-mode
      "mp" 'graphviz-dot-preview
      "mc" 'compile
      )))

(defun dotspacemacs/config ()
  "This is were you can ultimately override default Spacemacs configuration.
This function is called at the very end of Spacemacs initialization."
  ;;(company-emacs-eclim-setup)

  (language/latex)
  (language/haskell)
  (language/org)

  (setq powerline-default-separator 'arrow)

  (add-hook 'prog-mode-hook 'linum-mode)
  (linum-relative-toggle)
  (spacemacs/toggle-mode-line-battery-on)
  (spacemacs/toggle-mode-line-minor-modes-off)

  ;; (set-face-attribute 'fringe nil :background "#3F3F3F" :foreground "#3F3F3F")
  ;; (set-face-attribute 'linum nil :background "#3F3F3F")

  ;; (add-to-list 'evil-emacs-state-modes 'helm-mode)

  (evil-leader/set-key
    "oq" 'ielm
    "of" 'make-frame
    "os" 'helm-yas-create-snippet-on-region
    "oe" 'yas-visit-snippet-file
    "or" 'yas-reload-all
    "gF" 'magit-pull
    "gf" 'magit-fetch
    "gp" 'magit-push
    )
  )
)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-selection
   (quote
    (((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "xdg-open")
     (output-pdf "xdg-open")
     (output-html "xdg-open"))))
 '(ac-ispell-requires 4 t)
 '(ahs-case-fold-search nil)
 '(ahs-default-range (quote ahs-range-whole-buffer))
 '(ahs-idle-interval 0.25)
 '(ahs-idle-timer 0 t)
 '(ahs-inhibit-face-list nil)
 '(auto-revert-interval 0.1)
 '(blink-cursor-mode nil)
 '(ccm-ignored-commands
   (quote
    (mouse-drag-region mouse-set-point widget-button-click scroll-bar-toolkit-scroll evil-mouse-drag-region)))
 '(ccm-recenter-at-end-of-file t)
 '(ensime-company-case-sensitive t)
 ;; '(ensime-goto-test-config-defaults
 ;;   (:test-class-names-fn ensime-goto-test--test-class-names :test-class-suffixes
 ;;                         ("Test" "Spec" "Specification" "Check")
 ;;                         :impl-class-name-fn ensime-goto-test--impl-class-name :impl-to-test-dir-fn ensime-goto-test--impl-to-test-dir :is-test-dir-fn ensime-goto-test--is-test-dir :test-template-fn ensime-goto-test--test-template-scalatest-2))
 '(ensime-inf-default-cmd-line (quote ("sbt" "console")))
 '(evil-search-highlight-persist t t)
 '(flycheck-display-errors-delay 0)
 '(flycheck-idle-change-delay 0.5)
 '(global-evil-search-highlight-persist t)
 '(gud-gdb-command-name "gdb --annotate=1")
 '(guide-key/idle-delay 0.4)
 '(haskell-interactive-popup-error nil)
 '(haskell-notify-p t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-tags-on-save t)
 '(helm-ag-fuzzy-match t)
 '(helm-ag-use-grep-ignore-list nil)
 '(large-file-warning-threshold nil)
 '(org-agenda-files
   (quote
    ("~/Copy/ITM/nxtoff/plzcome-clocks.org" "~/Copy/ITM/nxtoff/plzcome.org" "~/Copy/School/IPD/ipd.org" "~/Copy/School/FA/fa.org" "~/Copy/notes.org" "~/Copy/School/AI/ai.org" "~/Copy/School/2.org")))
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
 '(company-tooltip-common ((t (:inherit company-tooltip :weight bold :underline nil))))
 '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :weight bold :underline nil)))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ahs-case-fold-search nil)
 '(ahs-default-range (quote ahs-range-whole-buffer))
 '(ahs-idle-interval 0.25)
 '(ahs-idle-timer 0 t)
 '(ahs-inhibit-face-list nil)
 '(paradox-github-token t)
 '(ring-bell-function (quote ignore) t))

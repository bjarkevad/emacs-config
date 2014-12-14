(defvar haskell-packages
  '(
    haskell-mode
    company-ghc
    ghci-completion
    ghc
    )
  )

(defvar haskell-excluded-packages '())

;((defun haskell/init-ghc ()
 ;  (use-package ghc)
  ; :init 
  ; ))

(defun haskell/init-haskell-mode ()
  (use-package haskell-mode 
    :init
    (progn 
      (custom-set-variables
       '(haskell-process-type 'cabal-repl)
       '(haskell-process-suggest-remove-import-lines t)
       '(haskell-process-auto-import-loaded-modules t)
       '(haskell-process-log t)
       '(haskell-interactive-popup-error nil)
       '(haskell-stylish-on-save t))
      )

    (autoload 'ghc-init "ghc" nil t)
    (autoload 'ghc-debug "ghc" nil t)

    (add-hook 'haskell-mode-hook (lambda () (ghc-init)))
    (add-hook 'haskell-mode-hook 'turn-on-haskell-indention)
    (add-hook 'haskell-mode-hook 'interactive-haskell-mode)

    (evil-define-key 'insert haskell-interactive-mode-map (kbd "RET") 'haskell-interactive-mode-return)
    (evil-define-key 'normal haskell-interactive-mode-map (kbd "RET") 'haskell-interactive-mode-return)

    (setq spacemacs/key-binding-prefixes '(("mc" . "cabal")))
    (evil-leader/set-key-for-mode 'haskell-mode
      "mC"  'haskell-compile
      "ml"  'haskell-process-load-or-reload
      "mt"  'haskell-process-do-type
      "mi"  'haskell-process-do-info
      "mb"  'haskell-process-cabal-build
      "mcc" 'haskell-process-cabal
      "mcv" 'haskell-cabal-visit-file
      "m`"  'haskell-interactive-bring
      "mk"  'haskell-interactive-mode-clear
      "mz"  'haskell-interactive-switch
      "mj"  'haskell-mode-jump-to-def-or-tag
      "md"  'inferior-haskell-find-haddock
      "mh"  'hoogle
      "mH"  'hayoo
      )
    (evil-leader/set-key-for-mode 'interactive-haskell-mode
      "mz"  'haskell-interactive-switch
      )

    (evil-leader/set-key-for-mode 'haskell-cabal
      "mC"  'haskell-compile
      )

    (evil-leader/set-key-for-mode 'haskell-cabal-mode
      "md" 'haskell-cabal-add-dependency
      "mb" 'haskell-cabal-goto-benchmark-section
      "me" 'haskell-cabal-goto-executable-section
      "mt" 'haskell-cabal-goto-test-suite-section
      "mm" 'haskell-cabal-goto-exposed-modules
      "ml" 'haskell-cabal-goto-library-section
      "mn" 'haskell-cabal-next-subsection
      "mp" 'haskell-cabal-previous-subsection
      "mN" 'haskell-cabal-next-section
      "mP" 'haskell-cabal-previous-section
      "mf" 'haskell-cabal-find-or-create-source-file
      ;; "m="  'haskell-cabal-subsection-arrange-lines ;; Does a bad job, 'gg=G' works better
      )

    ;; Heist templates
    (add-to-list 'auto-mode-alist '("\\.tpl\\'" . web-mode))
    )
  )

(defun haskell/init-company-ghc ()
  (use-package ghc
    :init 
    (add-to-list 'company-backends 'company-ghc)
    (ghc-comp-init)
    ))

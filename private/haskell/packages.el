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
      "mj"  'haskell-mode-jump-to-def-or-tag
      "md"  'inferior-haskell-find-haddock
      )

    (evil-leader/set-key-for-mode 'haskell-cabal
      "mC"  'haskell-compile
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

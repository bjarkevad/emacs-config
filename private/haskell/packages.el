(defvar haskell-packages
  '(
    haskell-mode
    company-ghc
    ghci-completion
    )
  "List of all packages to install and/or initialize. Built-in packages
which require an initialization must be listed explicitly in the list.")

(defvar haskell-excluded-packages '()
  "List of packages to exclude.")

;; For each package, define a function haskell/init-<package-haskell>
;;
(defun haskell/init-haskell-mode ()
  ;;   "Initialize my package"
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

      (add-hook 'haskell-mode-hook 'turn-on-haskell-indention)
      (add-hook 'haskell-mode-hook 'interactive-haskell-mode)

      (evil-define-key 'insert haskell-interactive-mode-map (kbd "RET") 'haskell-interactive-mode-return)
      (evil-define-key 'normal haskell-interactive-mode-map (kbd "RET") 'haskell-interactive-mode-return)

      (setq spacemacs/key-binding-prefixes '(("mc" . "cabal")))
      (evil-leader/set-key
        "ml" 'haskell-process-load-or-reload
        "mt" 'haskell-process-do-type
        "mi" 'haskell-process-do-info
        "mb" 'haskell-process-cabal-build
        "mcc" 'haskell-process-cabal

        "mcv" 'haskell-cabal-visit-file

        "m`" 'haskell-interactive-bring
        "mk" 'haskell-interactive-mode-clear

        "mj" 'haskell-mode-jump-to-def-or-tag

        "md" 'inferior-haskell-find-haddock
        )

      (eval-after-load "haskell-mode"
        '(progn
           (evil-leader/set-key "mC" 'haskell-compile)
           (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)))

      (eval-after-load "haskell-cabal"
        (evil-leader/set-key "mC" 'haskell-compile))


      ;; SNAP
      (add-to-list 'auto-mode-alist '("\\.tpl\\'" . xml-mode))
      )
    ))
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package

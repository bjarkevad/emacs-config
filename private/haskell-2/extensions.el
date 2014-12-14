(defvar haskell-pre-extensions
  '(
    ;; pre extension haskells go here
    )
  "List of all extensions to load before the packages.")

(defvar haskell-post-extensions
  '(
    ;; post extension haskells go here
    )
  "List of all extensions to load after the packages.")

;; For each extension, define a function haskell/init-<extension-haskell>
;;
;; (defun haskell/init-my-extension ()
;;   "Initialize my extension"
;;   )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package

(defvar themes-pre-extensions
  '(
    ;; pre extension themess go here
    )
  "List of all extensions to load before the packages.")

(defvar themes-post-extensions
  '(
    ;; post extension themess go here
    )
  "List of all extensions to load after the packages.")

;; For each extension, define a function themes/init-<extension-themes>
;;
;; (defun themes/init-my-extension ()
;;   "Initialize my extension"
;;   )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package

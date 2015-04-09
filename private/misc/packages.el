(defvar misc-packages
  '(
    ;;org-trello
    ;; edbi
    ;; company-edbi
;;    edbi-database-url
    ;; edbi-minor-mode
    ;; butler ;; jenkins
    yaml-mode
    graphviz-dot-mode
    )
  "List of all packages to install and/or initialize. Built-in packages
which require an initialization must be listed explicitly in the list.")

(defvar misc-excluded-packages '()
  "List of packages to exclude.")

;; (defun misc/init-butler()
;;   (add-to-list 'butler-server-list
;;              '(jenkins "build.bjarkevad.dk"
;;                        (server-address . "https://build.bjarkevad.dk")
;;                        (server-user . "bva")
;;                        (server-password . "dinmor123")
;;                        ))

;;     )

(defun misc/init-yaml-mode ()
  (use-package yaml-mode
    :defer t
    :config
    (progn
      (evil-define-key 'normal yaml-mode-map
        (kbd "=") 'yaml-indent-line)
      )
  )
  )

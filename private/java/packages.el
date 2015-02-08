;;; packages.el --- java Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defvar java-packages
  '(
    ;; package javas go here
    emacs-eclim
    )
  "List of all packages to install and/or initialize. Built-in packages
which require an initialization must be listed explicitly in the list.")

(defvar java-excluded-packages '()
  "List of packages to exclude.")

;; For each package, define a function java/init-<package-java>
;;
;; (defun java/init-my-package ()
;;   "Initialize my package"
;;   )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package


(defun java/init-emacs-eclim ()
  (require 'eclimd)
  (require 'company-emacs-eclim)

  (add-hook 'java-mode-hook 'eclim-mode)
  ;; (eval-after-load 'company 'company-emacs-eclim-setup)
  (setq eclim-eclipse-dir "~/Applications/eclipse")
  (setq eclim-executable "~/Applications/eclipse/eclim")
  (setq help-at-pt-display-when-idle t)
  (setq help-at-pt-timer-delay 0.1)
  (help-at-pt-set-timer)
  (print "LOADED ECLIM MODE"))

  ;; (use-package emacs-eclim
    ;; :defer t
    ;; :config (evil-leader/set-key-for-mode 'eclim-mode)
    ;; (setq eclim-eclipse-dir "~/Applications/eclipse")
    ;; (setq eclim-executable "~/Applications/eclipse/eclim")
    ;; (setq help-at-pt-display-when-idle t)
    ;; (setq help-at-pt-timer-delay 0.1)
    ;; (help-at-pt-set-timer)))

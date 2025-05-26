(load-file "~/.emacs.d/config/helm_bindings.el")
(helm-posframe-enable)

(defun t--before-helm ()
  (setq debug-on-error nil)
  (ignore-errors
    (t--mini-frame-mode -1)
    (lsp-ui-sideline-mode -1)
    )
  (setq debug-on-error nil)
  (setq t--pre-helm-win (selected-window))
  )

(defun t--after-helm ()
  (select-window t--pre-helm-win)
  )



(setq t--parent-frame (selected-frame))

(cl-defun t-save-format (&optional (do-save nil got-do-save))
  (interactive)
  (setq indent-tabs-mode nil)
  (cond (nil
         (lsp-format-buffer)
         (py-isort-buffer))
        (t
         (spacemacs/indent-region-or-buffer)))
  (if do-save (ci 'evil-write-all))
  )

(defun t-helm-rg-display (buf)
  (t--show-buf buf t--help-win))
(setq helm-full-frame nil)

(setq helm-rg-display-buffer-normal-method #'switch-to-buffer)
(setq helm-rg-display-buffer-alternate-method #'switch-to-buffer)
(setq helm-ff-skip-boring-files t)
(setq helm-boring-file-regexp-list '("\\.~undo-tree~$" "\#.*$"))

(setq py-isort-options 'nil)

(key "<f2>" '(t--before-helm) '(spacemacs/rename-current-buffer-file) '(t--after-helm))
(key "C-M-s-i" '(t-save-format))
(print (eq major-mode 'python-mode))
(key "C-M-s-S-d" 'spacemacs/delete-current-buffer-file)
(key "C-M-s-S-r" 'revert-buffer)

(key "C-M-s-d" 'spacemacs/find-dotfile)


(key "C-o" '(t--before-helm)
     '(ci 'spacemacs/helm-find-files)
     '(t--after-helm))
(key "C-S-o" '(t--before-helm) '(helm-mini) '(t--after-helm))
(load-file "~/.emacs.d/config/projectile.el")


(setq t-helm-width 160)
(setq t-helm-height 73)

(custom-set-variables
 '(helm-posframe-width t-helm-width)
 '(helm-posframe-min-width t-helm-width)
 '(helm-posframe-height t-helm-height)
 '(helm-posframe-min-height t-helm-height)
 '(helm-posframe-poshandler #'posframe-poshandler-frame-bottom-center)
 )

(key "C-S-t" 'helm-resume)
(key "C-t" 'helm-resume)
;; When user option ‘helm-findutils-search-full-path’ is non-nil,
;; match against complete paths, otherwise, against file names
;; without directory part.
(setq find-file-visit-truename t)
(add-hook 'dired-mode-hook 'dired-omit-mode)

(setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-bottom-window-center)))

;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(ivy-posframe-mode 1)

(key "C-o" '(t--before-helm) '(counsel-find-file) '(t--after-helm))
(key "C-S-o" '(t--before-helm) '(list-buffers) '(t--after-helm))

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
  (t--mini-frame-mode 1)
  (select-window t--pre-helm-win)
  )



(setq t-ivy-width 160)
(setq t-ivy-height 45)
(setq t-ivy-height 55)
(setq t-ivy-height 75)

(custom-set-variables
 '(ivy-posframe-width t-ivy-width)
 '(ivy-posframe-min-width t-ivy-width)
 '(ivy-posframe-height t-ivy-height)
 '(ivy-posframe-min-height t-ivy-height)
 )

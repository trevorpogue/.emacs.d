(defun t--move-adjust-buf (winum)
  (interactive)
  (winum-select-window-by-number winum)
  (centercursor-recenter)
  )

(defun t--adjust-buf (winum)
  (interactive)
  (save-selected-window
    (winum-select-window-by-number winum)
    (off-window-dedicated)
    (evil-goto-first-line)
    (centercursor-recenter)
    )
  )

(defun t--show-buf (buf winum &optional dir)
  (interactive)
  (save-selected-window
    (winum-select-window-by-number winum)
    (when dir (dired dir))
    (off-window-dedicated)
    (get-buffer-create buf)
    (set-window-buffer (selected-window) buf)
    (evil-emacs-state)
    (if (or
         (string= buf "*Messages*")
         (string= buf t--log-buffer-name)
         )
        (progn
          (evil-goto-line)
          (end-of-line)
          )
      (progn
        (evil-goto-first-line)
        ))
    (when dir (dired dir) (kill-this-buffer))
    ))

(defun t--help (&optional task)
  (t--mini-frame-mode -1)
  (save-selected-window
    (t--show-buf "*Help*" t--help-win2)
    (t--show-buf "*Help*" t--help-win)
    (when task (ci task))
    (off-window-dedicated)
    )
  )

(define-key evil-emacs-state-map (kbd "M-s-*") 'current-keymap)
(key "M-s-*" 'current-keymap)
(key "M-s-&" 'current-keymap)
(key "M-s-*" '(t--show-buf '"*t--log*" 1))

(defun t-helpful-switch-buffer-function (buf)
  (t--mini-frame-mode -1)
  (t--show-buf buf t--help-win)
  (off-window-dedicated))
(setq helpful-switch-buffer-function #'t-helpful-switch-buffer-function)
(key "M-s-(" '(t--help 'find-variable))
(key "M-s-*" '(t--help 'find-function))
(key "M-s-$" '(t--help 'describe-key))
(key "M-s-%" '(ignore-errors (ci 'helpful-function)
                             (t--adjust-buf t--help-win)))
(key "M-s-^" '(ignore-errors (ci 'helpful-variable)
                             (t--adjust-buf t--help-win)))
(key "M-s-&" 'helpful-function)
(key "M-s-#" '(t--move-adjust-buf t--help-win))
(key "M-s-@" '(t--adjust-buf t--help-win))
(key "M-s-!" '(t--help 'describe-keymap))

(key "M-s-S-<iso-lefttab>" '(ignore-errors
                              (flycheck-next-error)
                              (lsp-ui-sideline-mode -1)
                              (t-flycheck-enable-messages)
                              (centercursor-recenter)
                              ))


(defun off-window-dedicated ()
  "Control whether or not Emacs is allowed to display another
buffer in current window."
  (interactive)
  (set-window-dedicated-p (selected-window) nil)
  )


(defun toggle-window-dedicated ()
  "Control whether or not Emacs is allowed to display another
buffer in current window."
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
         (set-window-dedicated-p window (not (window-dedicated-p window))))
       "%s: Can't touch this!"
     "%s is up for grabs.")
   (current-buffer)))

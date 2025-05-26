(require 'magit-mode)
(require 'magit-diff)

(defun t-magit-hook (&rest args) (magit-section-cycle-global))

(defun t--show-buf2 (buf winum)
  (interactive)
  (save-selected-window
    (winum-select-window-by-number winum)
    (set-window-buffer (selected-window) buf)))

;; (defun magit-display-buffer-same-window-except-diff-v1 (buffer)
;;   "Display BUFFER in the selected window except for some modes.
;; If a buffer's `major-mode' derives from `magit-diff-mode' or
;; `magit-process-mode', display it in another window.  Display all
;; other buffers in the selected window."
;;   (display-buffer
;;    buffer (if (with-current-buffer buffer
;;                 (derived-mode-p 'magit-diff-mode 'magit-process-mode))
;;               '(nil (inhibit-same-window . t))
;;             '(display-buffer-same-window))))

(defun t-magit-display-buffer-same-window (buffer)
  "Display BUFFER in the selected window except for some modes.
If a buffer's `major-mode' derives from `magit-diff-mode' or
`magit-process-mode', display it in another window.  Display all
other buffers in the selected window."

  (condition-case nil
      (if (with-current-buffer buffer
            (derived-mode-p 'magit-diff-mode 'magit-process-mode))
          (t--show-buf2 buffer (1+ (winum-get-number)))
        (display-buffer buffer '(display-buffer-same-window))
        )
    (error (magit-display-buffer-traditional buffer))
    )
  )

(setq magit-display-buffer-function #'magit-display-buffer-traditional)
(setq magit-display-buffer-function #'t-magit-display-buffer-same-window)

(key "M-C-s-r" 'magit)
(key "C-M-z" 'magit)

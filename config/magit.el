(require 'magit-mode)
(require 'magit-diff)

(defun t-magit-hook (&rest args)
  ;; (end-of-buffer)
  ;; (next-line -1)
  ;; (ci 'magit-section-hide-children)
  ;; (beginning-of-buffer)
  ;; (magit-section-cycle-diffs)
  (magit-section-cycle-global)
  )

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
          ;; (display-buffer-in-direction buffer (direction . right))
          ;; (display-buffer buffer '(display-buffer-use-some-window))
          (t--show-buf2 buffer (1+ (winum-get-number)))
        (display-buffer buffer '(display-buffer-same-window))
        )
    (error (magit-display-buffer-traditional buffer))
    )
  ;; (display-buffer buffer '(display-buffer-same-window))
  )

;; (setq magit-diff-mode-hook nil)
;; (add-to-list 'magit-diff-mode-hook #'t-magit-section-hide-children)
;; (add-to-list 'magit-diff-mode-hook #'magit-section-cycle-global)
;; (add-to-list 'magit-diff-sections-hook #'magit-section-cycle-global t)
;; (add-to-list 'magit-post-display-buffer-hook #'t-magit-hook t)
;; (add-to-list 'magit-diff-mode-hook #'magit-section-cycle-diffs)
;; most recent (uncomment this one below to set it back):
;; (add-to-list 'magit-diff-sections-hook #'magit-section-cycle-global t)
;; (custom-set-variables
;; '(magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1)
;; '(magit-display-buffer-function 'magit-display-buffer-traditional)
(setq magit-display-buffer-function #'magit-display-buffer-traditional)
(setq magit-display-buffer-function #'t-magit-display-buffer-same-window)
;; )

(key "M-C-s-r" 'magit)
(key "C-M-z" 'magit)

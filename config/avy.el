(require 'avy)
(key "C-M-s-l" 'avy-goto-char-in-line)
(define-key evil-motion-state-map (kbd "i") 'avy-goto-char-in-line)
(define-key evil-motion-state-map (kbd "u") 'avy-goto-char-2)
(key "C-M-l" 'avy-goto-char-2)
(key "C-M-i" 'avy-pop-mark)
(define-key evil-motion-state-map (kbd "j") 'avy-goto-line-above)
(define-key evil-motion-state-map (kbd "k") 'avy-goto-line-below)
(setq display-line-numbers-mode-set-explicitly nil)
(setq display-line-numbers-width nil)
(setq topspace--log-target '(file . "~/elisp/t.log"))

(defun tlog (message)
  "Log MESSAGE."
  (when topspace--log-target
    (let ((log-line (format "%s\n"
                            message))
          (target-type (car topspace--log-target))
          (target-name (cdr topspace--log-target)))
      (pcase target-type
        ('buffer
         (with-current-buffer (get-buffer-create target-name)
           (goto-char (point-max))
           (insert log-line)))
        ('file
         (let ((save-silently t))
           (append-to-file log-line nil target-name)))
        (_
         (error "Unrecognized log target type: %S" target-type))))))

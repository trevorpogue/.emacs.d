;; windows

;; buffer top/bottom
(key "C-<home>" '(my-set-marker2) '(ci 'evil-goto-first-line)
     '(recenter (centercursor-recenter)))
(key "C-<end>" '(my-set-marker1) '(goto-char (point-max))
     '(recenter (centercursor-recenter)))

(define-key evil-motion-state-map (kbd "C-<home>") 'evil-goto-first-line)
(define-key evil-motion-state-map (kbd "C-<end>") 'evil-goto-line)

;; begin end of line
(key "C-S-<end>" 'end-of-line)
(key "C-'" 'end-of-line)
(key "<end>" 'end-of-visual-line)
(define-key evil-motion-state-map (kbd "<end>") 'end-of-line)
(key "<home>" 'beginning-of-visual-line)

(key "<up>" 'previous-line)

(key "<down>" 'next-line)

;; www back forward fwd
;; TODO: make these work on *buffers*
(key "M-<left>" 'previous-buffer)
(key "M-<right>" 'next-buffer)
(key "C-M-s-8" '(evil-backward-WORD-begin))
(key "C-M-s-9" '(evil-forward-WORD-end) '(right-char))
(key "C-M-s--" '(evil-backward-WORD-begin))
(key "C-M-s-b" '(evil-forward-WORD-end) '(right-char))


(defun select-text-in-delimiters (arg)
  "Select text between the nearest left and right delimiters."
  (interactive "p")
  (let ((ppss (syntax-ppss)))
    (cond ((elt ppss 3)
           (goto-char (elt ppss 8))
           (backward-up-sexp (1- arg)))
          ((backward-up-list arg)))))

(defun t-left-word ()
  (interactive)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "_" table)
    (modify-syntax-entry ?` "_" table)
    (with-syntax-table table
      (ci 'left-word)
      ))
  )

(defun t-right-word ()
  (interactive)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "_" table)
    (modify-syntax-entry ?` "_" table)
    (with-syntax-table table
      (ci 'right-word)
      ))
  )

(define-key evil-motion-state-map (kbd "f") 'right-word)
(key "C-<left>" 't-left-word)
(key "C-<right>" 't-right-word)

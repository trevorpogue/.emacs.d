;; windows

;; buffer top/bottom
(key "C-<home>" '(my-set-marker2) '(ci 'evil-goto-first-line)
     '(recenter (centercursor-recenter)))
(key "C-<end>" '(my-set-marker1) '(goto-char (point-max))
     '(recenter (centercursor-recenter)))
;; (key "C-<end>" '(evil-goto-line))
;; (key "C-<end>" '(end-of-buffer))
;; (key "C-<end>" '(goto-char (point-max)))

(define-key evil-motion-state-map (kbd "C-<home>") 'evil-goto-first-line)
(define-key evil-motion-state-map (kbd "C-<end>") 'evil-goto-line)

;; begin end of line
;; (global-set-key (kbd "<home>") 'beginning-of-visual-line)
;; (global-set-key (kbd "<end>") 'end-of-visual-line)
(key "C-S-<end>" 'end-of-line)
(key "C-'" 'end-of-line)
(key "<end>" 'end-of-visual-line)
(define-key evil-motion-state-map (kbd "<end>") 'end-of-line)
(key "<home>" 'beginning-of-visual-line)

(key "<up>" 'previous-line)
     ;; '(progn
     ;;    (ci 'previous-line)
     ;;    (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
     ;;         (t--update-adaptive-wrap-extra-indent)
     ;;       )))

(key "<down>" 'next-line)
     ;; '(progn
        ;; (ci 'next-line)
        ;; (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
        ;;      (t--update-adaptive-wrap-extra-indent))
        ;; ))

;; (define-key latex-mode-map (kbd "<end>") 'end-of-visual-line)
;; (define-key LaTeX-mode-map (kbd "<home>") 'beginning-of-visual-line)
;; www back forward fwd
;; TODO: make these work on *buffers*
;; (key "C-M-s-<left>" 'previous-buffer)
;; (key "C-M-s-<right>" 'next-buffer)
(key "M-<left>" 'previous-buffer)
(key "M-<right>" 'next-buffer)
;; (key "C-<left>" 'previous-buffer)
;; (key "C-<right>" '(ci 'forward-to-word))
;; (key "<XF86Back>" 'previous-buffer)
;; (key "<XF86Forward>" 'next-buffer)
(key "C-M-s-8" '(evil-backward-WORD-begin))
(key "C-M-s-9" '(evil-forward-WORD-end) '(right-char))
(key "C-M-s--" '(evil-backward-WORD-begin))
(key "C-M-s-b" '(evil-forward-WORD-end) '(right-char))

;; (key "<f6>" 'evil-jump-item)

(defun select-text-in-delimiters (arg)
  "Select text between the nearest left and right delimiters."
  (interactive "p")
  (let ((ppss (syntax-ppss)))
    (cond ((elt ppss 3)
           (goto-char (elt ppss 8))
           (backward-up-sexp (1- arg)))
          ((backward-up-list arg)))))

;; (defadvice forward-to-word (around underscore-as-word activate)

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
      ;; (evil-forward-word-end)
      ))
  )

(define-key evil-motion-state-map (kbd "f") 'right-word)
(key "C-<left>" 't-left-word)
(key "C-<right>" 't-right-word)

;; (defun t-common-cancels-then-up ()
;; )

;; (key "<up> '")

;; (define-key evil-motion-state-map (kbd "C-M-s-S-B") 'select-text-in-delimiters)

;; (define-key evil-emacs-state-map (kbd "<return>") 'evil-search-next)
;; (define-key evil-emacs-state-map (kbd "S-<return>") 'evil-search-previous)
;; (define-key compilation-mode-map (kbd "<return>") 'evil-search-next)
;; (define-key compilation-mode-map (kbd "S-<return>") 'evil-search-previous)

;; (global-set-key (kbd "<up>")
;;																	(lambda () (interactive)
;;																					(when (bound-and-true-p centercursor-mode)
;;																					;; (run-hook-with-args 'topspace-scroll-hook 1)
;;																					)
;;																			(call-interactively 'previous-line)
;;																			))
;; (global-set-key (kbd "<down>")
;;																	(lambda () (interactive)
;;																			(call-interactively 'next-line)
;;																					(when (bound-and-true-p centercursor-mode)
;;																					;; (run-hook-with-args 'topspace-scroll-hook -1)
;;																					)
;;																			))

;; (global-set-key (kbd "<up>") 'previous-line)
;; (global-set-key (kbd "<down>") 'next-line)

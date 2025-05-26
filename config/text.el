
(key "C-M-s-w" 'evil-join)
(key "C-M-s-w" '(ci 'evil-join))
(key "C-M-s-b" 'my-begin-end)
(key "C-/" 'comment-line)
(define-key evil-emacs-state-map (kbd "M-s-c") 'comment-line)
(key "C-M-s-o" (lambda ()
								 (interactive)
								 (ci 'evil-open-above)
								 (save-excursion
                   (ci 'esc))))

;; TODO add blabk text above line
(key "C-M-g"
		 '(ci 'evil-open-below)
		 '(save-excursion (ci 'esc)))

(key "M-s-S-<down>"
		 (lambda () (interactive)
			 (ci 'evil-yank-line)
			 (evil-paste-before 1)
			 (ci 'comment-line)
			 ))

(key "M-s-S-<up>"
		 (lambda () (interactive)
			 (ci 'evil-yank-line)
			 (ci 'next-line)
			 (previous-line)
			 (evil-paste-after 1)
			 (ci 'comment-line)
			 (ci 'previous-line)
			 (previous-line)
			 ))

(key "C-M-s-<up>"
		 '(ci 'evil-yank-line)
		 '(evil-paste-before 1)
		 )

(key "C-M-s-<down>"
		 '(ci 'evil-yank-line)
		 '(ci 'next-line)
		 '(previous-line)
		 '(evil-paste-after 1)
		 )

(defun t-invert-var-case ()
  ;; (interactive)
	;; (save-excursion
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?/ "_" table)
    (modify-syntax-entry ?` "_" table)
    (when (eq major-mode 'latex-mode)
      (modify-syntax-entry ?- "w" table)
      (modify-syntax-entry ?: "w" table))
    (if (or (eq major-mode 'emacs-lisp-mode) (eq major-mode 'sh-mode))
        (modify-syntax-entry ?- "w" table)
      t)
    ;; (save-excursion
    (with-syntax-table table
      (right-char)
      (left-word)
      (push-mark)
      (right-word)
			(evil-invert-case (mark) (point))
      ))
	(right-word))


(key "C-M-s" '(t-invert-var-case))

(key "C-y" 'undo-tree-redo)
(key "C-z" 'undo-tree-undo)

(defun t-delete-word-backward- ()
	(interactive "*")
	(push-mark)
	(t-left-word)
	(delete-region (mark) (point)))

(defun t-delete-word-backward (arg)
  "Unindents.
Bound to `M-backspace' key. Searches lines backward, finds the one that
is indented less than the current one. Unindents current line to
align with that smaller indentation"
  (interactive "p")
  (if (not (clean-aindent--inside-indentp))
      (t-delete-word-backward-)  ;; Original "C-backspace" key function
    ;; else: cursor is inside indent space, do unindent
    (let*
        ((ln (clean-aindent--line-point))
				 (c (current-indentation))
				 (n (clean-aindent--find-u-indent c))  ;; compute new indent
				 (s (+ ln n)))  ;; start of region to delete
      (if (not (= s c))
					(progn
						;; (message "new unindent %d" n)
						;; Delete characters between s to c
						(clean-aindent--goto-column c)
						(backward-delete-char-untabify (- c n)))))))

(defun t-delete-word-forward ()
	(interactive "*")
	(push-mark)
	(t-right-word)
	(delete-region (point) (mark)))

(defun t-copy-right-word ()
	(interactive)
	(save-mark-and-excursion
		(push-mark)
		(t-right-word)
		(copy-region-as-kill (point) (mark))
		))

(key "C-<backspace>" 't-delete-word-backward)
;; (key "C-<backspace>" 'clean-aindent--bsunindent)
(key "C-<delete>" 't-delete-word-forward)
;; clean-aindent--bsunindent
;; kill-word
;; I had copied this Emacs macro just for doing that.

;; Writing One Sentence per Line:
;; https://news.ycombinator.com/item?id=31808093
;; i think this splits up paragraph to make one sentence per line:
;; (defun wrap-at-sentences () "Fills the current paragraph, but starts each sentence on a new line." (interactive) (save-excursion ;; Select the entire paragraph. (mark-paragraph) ;; Move to the start of the paragraph. (goto-char (region-beginning)) ;; Record the location of the end of the paragraph. (setq end-of-paragraph (region-end)) ;; Wrap lines with 'hard' newlines (i.e., real line breaks). (let ((use-hard-newlines 't)) ;; Loop over each sentence in the paragraph. (while (< (point) end-of-paragraph) ;; Determine the region spanned by the sentence. (setq start-of-sentence (point)) (forward-sentence) ;; Wrap the sentence with hard newlines. (fill-region start-of-sentence (point)) ;; Delete the whitespace following the period, if any. (while (char-equal (char-syntax (preceding-char)) ?\s) (delete-char -1)) ;; Insert a newline before the next sentence. (insert "\n")))))
;; (global-set-key (kbd "M-j") 'wrap-at-sentences)
( key "C-S-t" '(text-scale-set 2))

(defun t--text-mode-hooks (&optional arg1)
  (toggle-truncate-lines -1)
  (adaptive-wrap-prefix-mode 1)
  (visual-line-mode 1)
	)


(add-hook 'text-mode-hook 't--text-mode-hooks)

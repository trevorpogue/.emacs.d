
;; old latex-mode paragraph-start "[ 	]*\\(\\$\\$\\|\\\\[][]\\|\\\\\\(b\\(?:egin\\|ibitem\\)\\|c\\(?:aption\\|hapter\\)\\|end\\|footnote\\|item\\|label\\|marginpar\\|n\\(?:ew\\(?:\\(?:lin\\|pag\\)e\\)\\|oindent\\)\\|par\\(?:agraph\\|box\\|t\\)\\|s\\(?:ection\\|ub\\(?:paragraph\\|s\\(?:\\(?:ubs\\)?ection\\)\\)\\)\\)\\>\\|\\\\[a-z]*\\(page\\|s\\(?:kip\\|pace\\)\\)\\>\\)"

;; old latex-mode paragraph-separate "\\([ 	]*%\\)\\|[\f]\\|[ 	]*\\($\\|\\\\[][]\\|\\\\\\(begin\\|chapter\\|end\\|label\\|par\\(?:agraph\\|t\\)\\|s\\(?:ection\\|ub\\(?:paragraph\\|s\\(?:\\(?:ubs\\)?ection\\)\\)\\)\\)\\>\\|\\\\\\(\\(?:bibitem\\|caption\\|footnote\\|item\\|marginpar\\|n\\(?:ew\\(?:\\(?:lin\\|pag\\)e\\)\\|oindent\\)\\|parbox\\)\\|\\$\\$\\|[a-z]*\\(space\\|skip\\|page[a-z]*\\)\\>\\)[][0-9 	]*\\($\\|%\\)\\)"

(defun t-set-paragraph-start ()
  (setq paragraph-start "\f\\|[ 	]*$")
  (setq paragraph-separate "[ 	\f]*$")
  )


;; (setq TeX-auto-save t)
;; (setq TeX-parse-self t)
;; (setq-default TeX-master nil)
;; (setq TeX-master nil)
;; (setq reftex-plug-into-AUCTeX t)
;; (setq reftex-default-bibliography '("bibliography.bib"))
;; (setq reftex-bibliography-commands '("bibliography" "nobibliography" "addbibresource"))


(defun t-visual-line-mode () (visual-line-mode 1))
(defun t-auto-fill-mode () (auto-fill-mode -1))
;; (defun t-visual-line-mode () (visual-line-mode -1))
;; (defun t-auto-fill-mode () (auto-fill-mode 1))

(defun t-prettify-symbols-mode () (prettify-symbols-mode 1))
;; (add-hook 'plain-tex-mode-hook 'flyspell-mode)
;; (add-hook 'plain-tex-mode-hook 'turn-on-reftex)



(setq t--tex-hook-alist
  '(
				smartparens-mode
				t-visual-line-mode
				t-prettify-symbols-mode
				t-set-paragraph-start
        t-auto-fill-mode
    )
		)

(dolist (func t--tex-hook-alist)
		(add-hook 'plain-tex-mode-hook func)
		(add-hook 'latex-mode-hook func)
		)


(defun my-auctex (script)
		(interactive)
		(evil-write-all nil)
		(evil-force-normal-state)
		(let ((prev (selected-window)))
				(let ((window (get-buffer-window "pgm\.tex" t)))
						(evil-force-normal-state)
						(eshell-interrupt-process)
						(insert script)
						(eshell-send-input)
						(select-window prev t)))
		)

(defun guess-TeX-master (filename)
		"Guess the master file for FILENAME from currently open .tex files."
		(let ((candidate nil)
								(filename (file-name-nondirectory filename)))
				(save-excursion
						(dolist (buffer (buffer-list))
								(with-current-buffer buffer
										(let ((name (buffer-name))
																(file buffer-file-name))
												(if (and file (string-match "\\.tex$" file))
																(progn
																		(goto-char (point-min))
																		(if (re-search-forward (concat "\\\\input{" filename "}") nil t)
																						(setq candidate file))
																		(if (re-search-forward (concat "\\\\include{" (file-name-sans-extension filename) "}") nil t)
																						(setq candidate file))))))))
				(if candidate
								(message "TeX master document: %s" (file-name-nondirectory candidate)))
				candidate))
(setq TeX-master (guess-TeX-master "master"))
(defun my-preview-buffer-1 ()
		(interactive)
		(evil-write-all nil)
		(preview-buffer)
		)

(defun t--comp (&optional n)
  ;; (ci 'beginning-of-line)
  (let ((comp-win (get-buffer-window t--comp-buffer-name)))
    (setq t--comp-win
          (if comp-win
              (winum-get-number (get-buffer-window t--comp-buffer-name))
            (length (window-list)))))
  ;; (setq debug-on-error t)tl/mem/layeriomem_memclk.sv
  ;; (evil-write-all nil)
  ;; (select-frame-set-input-focus t-comp-frame)
  (t--show-buf "*Backtrace*" t--backtrace-win)
  (t--show-buf "*Messages*" t--messages-win)
  (evil-write-all nil)
  ;; (ignore-errors (ci 'kill-grep))
  (setq debug-on-error nil)
  (setq t--comp-n n)
  ;; (ignore-errors (kill-buffer t--comp-buffer-name))
		(setq t--comp-win
								(if (and (= (winum-get-number (get-buffer-window t--comp-buffer-name))
																				(winum-get-number))
																	(not (eq (get-buffer-window)
																										(get-buffer-window t--comp-buffer-name))))
								;; (1+ (winum-get-number))
								(car (last (winum--available-numbers)))
								(winum-get-number (get-buffer-window t--comp-buffer-name))))
		;; (setq t--comp-win (car (last (winum--available-numbers))))
  (t--show-buf t--comp-buffer-name t--comp-win)
  (setq compilation-directory t--comp-dir)
  (setq compile-command t--comp-command)
  (recompile)
  (esc)
  ;; (save-selected-window
    ;; (winum-select-window-by-number t--comp-win)
    ;; (with-current-buffer t--comp-buffer-name (t-python-mode)))
  )

(defun t-after-comp (&optional buffer desc)
  ;; (setq t-do-search-error t) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq t-do-search-error nil) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; (interactive)
  (ignore-errors
    (ci 'esc)
    (ci 'esc)
    (posframe-delete-all)
    (select-frame t--frame)
    (ci 'esc)
    (ci 'esc)
    )
  ;; (select-frame t--frame)
  ;; (select-window)
  (let ((comp-win (get-buffer-window t--comp-buffer-name)))
    (setq t--comp-win
          (if comp-win
              (winum-get-number (get-buffer-window t--comp-buffer-name))
            (length (window-list)))))
  (t--show-buf t--comp-buffer-name t--comp-win)
  (setq t--log-win (winum-get-number (get-buffer-window t--log-buffer-name)))

  (let ((search-error t-do-search-error))
    ;; (let ((search-error nil))

    (setq t-pre-comp-window (selected-window))
    (save-selected-window
      (winum-select-window-by-number t--comp-win)
      (end-of-buffer)
      (centercursor-recenter)
        (condition-case nil
            (evil-search "error" t)
          (:success
											(when search-error
													(ci 't-quick-search)
													(kmacro "C-f e r r o r")))
          (error))
      (select-window t-pre-comp-window)))
  (message "t--log-win")
  ;; + number moves text down:
  ;; (t-setup-buf t--log-buffer-name t--log-win nil 10)
  (message "t--log-win2")
  ;; (if t--log-win2
  ;; (t-setup-eww t--log-buffer-name2 t--log-win2 t--logfile-fullname2))
  (message "t--comp-win")
  ;; (if t--comp-win
  (t-setup-buf t--comp-buffer-name t--comp-win nil 25 t)
  ;; )
  ;; (message "errors")
  ;; (with-current-buffer t--comp-buffer-name
  ;; (t--center-after-comp)
  ;; )
  (message "done compilation")
  )


(cl-defun t-setup-eww (buffer win &optional fullname)
  (save-selected-window
    (winum-select-window-by-number win)
    (eww-open-file t--logfile-fullname2)
    (t-python-mode)
    (scroll-up-line 60)
    ))

(cl-defun t-setup-buf (buffer win &optional fullname n switch-to-buf
                              &aux (for-comp (not fullname))
                              (for-log (not for-comp)))
  (save-selected-window
    (winum-select-window-by-number win)
    (let ((previous-buffer (current-buffer)))
      (if fullname (switch-to-buffer (find-file-noselect fullname t))
        (switch-to-buffer buffer))
      (with-current-buffer buffer
        (ignore-errors
          (if for-log (revert-buffer nil t t)))
        (t-python-mode)
        (t--center-after-comp n))
      (unless switch-to-buf (message "here") (switch-to-buffer
                                              previous-buffer)))))

(defun t-python-mode ()
  (interactive)
  (ignore-errors
    (lsp-disconnect)
    ;; (if flycheck-mode (ci 'flycheck-mode))
    (unless (eq major-mode 'python-mode)
      (message "---- enabling python-mode for buffer:")
      (print buffer)
      (setq lsp-enable-links nil)
      (let ((prev-hook python-mode-hook))
        (setq python-mode-hook nil)
        (python-mode)
        (setq python-mode-hook prev-hook))
      (flycheck-mode -1))))

(defun t--center-after-comp (n)
  (toggle-truncate-lines t)
  (cond (t-do-search-error
         (evil-goto-line)
         (t-search-previous)
         (beginning-of-visual-line)
         )
        (t
         (evil-goto-line)
         (if (> n 0)
             (ignore-errors (dotimes (i n) (previous-line)))
           (ignore-errors (dotimes (i n) (next-line)))
           )
         ;; (end-of-line)
         (beginning-of-visual-line)
         ))
  (end-of-buffer)
		(previous-line)
		(backward-paragraph)
		(backward-paragraph)
  (esc)
  ;; (evil-motion-state)
  (ci 'read-only-mode)
  ;; (goto-char (point-max))
  (centercursor-recenter)
  ;; (topspace-recenter-buffer)
  ;; (centercursor-goto-center-buffer-line)
  )

(load-file "~/.emacs.d/config/comp_bindings.el")


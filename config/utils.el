(setq tp-global-unset
      '("C-x" "<return>"))

(defun ci (task)
  (interactive)
  (call-interactively task)
  )

(defun kmacro (macro-str) (execute-kbd-macro (kbd macro-str)))
(defun t-kmacro (macro-str) (execute-kbd-macro (kbd macro-str)))

;; mode or state
(defun esc (&optional &rest args)
  (interactive)
  (evil-search-highlight-persist-remove-all)
  (evil-escape)
  (evil-emacs-state))

(defun t--mini-frame-mode (n)
  (ignore-errors (mini-frame-mode n))
  )

(defun cu (&optional num)
  (interactive)
  (if current-prefix-arg
      (progn (digit-argument current-prefix-arg))
    (progn
      (setq-local tp-str (concat "C-u " (number-to-string num)))
      (execute-kbd-macro (kbd tp-str))
      )))

(defun t--log (in-str &rest vars)
  (when (bound-and-true-p t--debug)
    (with-current-buffer (get-buffer-create t--log-buffer-name)
      (evil-goto-line)
      (insert in-str)
      (insert "\n"))))

(cl-defun logp (&rest x &aux (prev-t--debug t--debug))
  (t--show-buf '"*Messages*" t--messages-win)
  (t--show-buf t--log-buffer-name t--log-win)
  (-map (lambda (x)
          (princ x (get-buffer t--log-buffer-name)))
        x)
  (princ "\n" (get-buffer t--log-buffer-name))
  (evil-echo-area-restore)
  )

(cl-defun logt (&rest x &aux (prev-t--debug t--debug))
  (t--show-buf '"*Messages*" t--messages-win)
  (t--show-buf t--log-buffer-name t--log-win)
  (-map (lambda (x)
          (princ x (get-buffer t--log-buffer-name))
          (princ " " (get-buffer t--log-buffer-name))
          (princ (eval x) (get-buffer t--log-buffer-name))) x)
  (princ "\n" (get-buffer t--log-buffer-name))
  (evil-echo-area-restore)
  )


(defmacro logq (var) `(logt ',var))

(setq t--log-buffer-name "*tlog*")
(get-buffer-create "*Help*")
(get-buffer-create t--log-buffer-name)


(defun key (binding &rest cmd) (_key binding cmd nil))
(defun key2 (binding &rest cmd) (_key binding cmd t))

(require 'compile)
(defun _key (binding cmd not-interactive)
  (when cmd
    (setq cmd (func cmd (not not-interactive)))
    (t--log "key: cmd:%s" cmd)
    (define-key evil-emacs-state-map (kbd binding) cmd)
    (define-key evil-normal-state-map (kbd binding) cmd)
    (define-key shell-mode-map (kbd binding) cmd)
    (define-key compilation-mode-map (kbd binding) cmd)
    (define-key evil-motion-state-map (kbd binding) cmd)
    (define-key evil-visual-state-map (kbd binding) cmd)
    (define-key visual-line-mode-map (kbd binding) cmd)
    (when (not (member binding tp-global-unset))
      (define-key evil-insert-state-map (kbd binding) cmd)
      (define-key help-mode-map (kbd binding) cmd)
      (global-set-key (kbd binding) cmd)))
  (unless cmd
    (unbind-key binding global-map)
    (unbind-key binding evil-emacs-state-map)
    (unbind-key binding evil-insert-state-map)
    (unbind-key binding evil-normal-state-map)
    (unbind-key binding shell-mode-map)
    )
  )

(cl-defun func (cdr interactive)
  (t--log "func: input cdr:%s" cdr)
  (cond
   ;; branch a
   ((and (eq (type-of (first cdr)) 'cons) (eq (first (first cdr)) 'lambda))
    (setq cdr (first cdr))
    (t--log "func: branch a cdr:%s" cdr)
    )
   ;; branch b
   ((eq (type-of (first cdr)) 'cons)
    (setq cdr (t--lambda cdr interactive))
    (t--log "func: branch b cdr:%s" cdr)
    )
   ;; branch c
   ;; 'function
   (t
    (setq cdr (first cdr))
    (t--log "func: branch c cdr:%s" cdr)
    )
   )
  cdr)

(defun t--lambda (cdr interactive)
  (if interactive
      (push '(interactive) cdr))
  (push '() cdr)
  (push 'lambda cdr)
  (t--log "t--lambda: cdr:%s" cdr)
  cdr)

(defun t--keymap-symbol (keymap)
  ;; https://stackoverflow.com/questions/14489848/emacs-name-of-current-local-keymap
  ;; usage: (t--keymap-symbol (current-local-map))
  "Return the symbol to which KEYMAP is bound, or nil if no such symbol exists."
  (catch 'gotit
    (mapatoms (lambda (sym)
                (and (boundp sym)
                     (eq (symbol-value sym) keymap)
                     (not (eq sym 'keymap))
                     (throw 'gotit sym))))))


;; in *scratch*:
(defun t-current-keymap (&optional &rest args)
  (interactive)

  ;; in *scratch*:
  (print 'current-local-map)
  (print (t--keymap-symbol (current-local-map)))
  (print (current-local-map))
  )

(setq mini-frame-show-parameters '((left . 200.5)
                                   (top . 0.0)
                                   (width . 1.0)
                                   (height . 1)))

(custom-set-variables
 '(mini-frame-show-parameters
   '((top . 700)
     (width . 0.22)
     (left . 1400)
     (height . 1))))

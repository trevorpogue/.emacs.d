(setq u-mid-normal "C-s-S-p")
(setq i-mid-normal "C-M-w")
(setq u-normal "<S-return>")
(setq i-normal "<return>")
(setq t--search-backward-center  u-mid-normal)
(setq t--search-forward-center  i-mid-normal)
(setq t--search-backward  u-normal)
(setq t--search-forward  i-normal)

(defun t-search-next ()
  (interactive)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?/ "_" table)
    (modify-syntax-entry ?` "_" table)
    (when (eq major-mode 'latex-mode)
      (modify-syntax-entry ?- "w" table)
      (modify-syntax-entry ?: "w" table))
    (if (or (eq major-mode 'emacs-lisp-mode) (eq major-mode 'sh-mode))
        (modify-syntax-entry ?- "w" table)
      1)
    (with-syntax-table table
      (ci 'evil-search-next)
      ))
  )

(defun t-search-previous ()
  (interactive)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?/ "_" table)
    (modify-syntax-entry ?` "_" table)
    (when (eq major-mode 'latex-mode)
      (modify-syntax-entry ?- "w" table)
      (modify-syntax-entry ?: "w" table))
    (with-syntax-table table
      (ci 'evil-search-previous)
      ))
  )

(defun t-isearch-yank (&optional &rest args)
  (interactive)
  (save-excursion
    (let ((table (copy-syntax-table (syntax-table))))
      (modify-syntax-entry ?_ "w" table)
      (modify-syntax-entry ?/ "_" table)
      (modify-syntax-entry ?` "_" table)
      (when (eq major-mode 'latex-mode)
        (modify-syntax-entry ?- "w" table)
        (modify-syntax-entry ?: "w" table))
      (if (or (eq major-mode 'emacs-lisp-mode) (eq major-mode 'sh-mode))
          (modify-syntax-entry ?- "w" table)
        1)
      (with-syntax-table table
        (right-char)
        (left-word)
        (push-mark)
        (right-word)
        (copy-region-as-kill (point) (mark))
        (execute-kbd-macro (kbd "C-f \\b C-v \\b"))
        ))))

(defun t-quick-search () (interactive)
       (ci 'esc)
       (save-excursion
         (let ((table (copy-syntax-table (syntax-table))))
           (modify-syntax-entry ?_ "w" table)
           (modify-syntax-entry ?/ "_" table)
           (modify-syntax-entry ?` "_" table)
           (when (eq major-mode 'latex-mode)
             (modify-syntax-entry ?- "w" table)
             (modify-syntax-entry ?: "w" table))
           (if (or (eq major-mode 'emacs-lisp-mode) (eq major-mode 'sh-mode))
               (modify-syntax-entry ?- "w" table)
             1)
           (with-syntax-table table
             (right-char)
             (left-word)
             (push-mark)
             (right-word)
             (copy-region-as-kill (point) (mark))
             (execute-kbd-macro (kbd "C-f \\b C-y \\b"))
             ))
         (execute-kbd-macro (kbd t--search-forward)))
       )

(defun t-quick-search-no-b () (interactive)
       (ci 'esc)
       (save-excursion
         (let ((table (copy-syntax-table (syntax-table))))
           (modify-syntax-entry ?_ "w" table)
           (modify-syntax-entry ?/ "_" table)
           (modify-syntax-entry ?` "_" table)
           (when (eq major-mode 'latex-mode)
             (modify-syntax-entry ?- "w" table)
             (modify-syntax-entry ?: "w" table))
           (if (or (eq major-mode 'emacs-lisp-mode) (eq major-mode 'sh-mode))
               (modify-syntax-entry ?- "w" table)
             1)
           (with-syntax-table table
             (right-char)
             (left-word)
             (push-mark)
             (right-word)
             (copy-region-as-kill (point) (mark))
             (execute-kbd-macro (kbd "C-f C-y"))
             ))
         (execute-kbd-macro (kbd t--search-forward)))
       )

(defun t-quick-search-error () (interactive)
       (save-excursion
         (let ((table (copy-syntax-table (syntax-table))))
           (modify-syntax-entry ?_ "w" table)
           (modify-syntax-entry ?/ "_" table)
           (modify-syntax-entry ?` "_" table)

           (if (or (eq major-mode 'emacs-lisp-mode) (eq major-mode 'sh-mode))
               (modify-syntax-entry ?- "w" table)
             1)
           (when (eq major-mode 'latex-mode)
             (modify-syntax-entry ?- "w" table)
             (modify-syntax-entry ?: "w" table))
           (with-syntax-table table
             (right-char)
             (left-word)
             (push-mark)
             (right-word)
             (copy-region-as-kill (point) (mark))
             (execute-kbd-macro (kbd "C-f \\b C-y \\b"))
             ))
         (execute-kbd-macro (kbd t--search-forward)))
       )

(defun quick-search2 () (interactive)
       (execute-kbd-macro (kbd "C-S-c C-f C-y"))
       (execute-kbd-macro (kbd t--search-backward))
       )

(evil-define-command cust-search-rplc ()
  :keep-visual t
  :repeat nil
  :type line
  :jump t
  (setq t-from-visual nil)
  (evil-set-marker ?z)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?/ "_" table)
    (modify-syntax-entry ?` "_" table)
    (when (eq major-mode 'latex-mode)
      (modify-syntax-entry ?- "w" table)
      (modify-syntax-entry ?: "w" table)
      )
    (if (or (eq major-mode 'emacs-lisp-mode) (eq major-mode 'sh-mode))
        (modify-syntax-entry ?- "w" table)
      1)
    (with-syntax-table table
      (execute-kbd-macro (kbd "<right>"))
      (left-word)
      (execute-kbd-macro (kbd "C-S-c f"))
      ))
  (evil-search-highlight-persist-remove-all)
  (evil-ex "%s///g")
  )

(defun t-turn-on-search-highlight-persist ()
  "Enable search-highlight-persist in the current buffer."
  (evil-search-highlight-persist
   1))

(advice-add #'turn-on-search-highlight-persist
            :override #'t-turn-on-search-highlight-persist)


(setq-local topspace-auto t)
(key "C-h" 'cust-search-rplc)
(key "M-s-<return>"
     (defun t-after-search-replace ()
       (interactive)
       (if t-from-visual
           (kmacro "<left> <left> <left>")
         (kmacro "<left> <left> <left> \\b C-S-v <right> \\b <right>")
         )
       ))

(define-key evil-visual-state-map (kbd "C-h")
  (defun srch-rplc-3 ()
    (interactive)
    (setq t-from-visual t)
    (evil-search-highlight-persist-remove-all)
    (evil-ex "'<,'>s///g")
    )
  )

;; describe-function
;; C-h
(define-key evil-visual-state-map (kbd "C-f")
  (defun srch-rplc-4 () (interactive)
         (execute-kbd-macro (kbd "\C-c\C-f\C-y"))
         (execute-kbd-macro (kbd t--search-backward))
         (call-interactively 'evil-search-highlight-persist-remove-all)
         (evil-ex "%s///g")
         (t--mini-frame-mode -1)
         )
  )

(key "C-f" '(evil-search-forward))

(key t--search-backward 't-search-previous)
(key t--search-forward 't-search-next)


(key t--search-backward-center 'cust-search-rplc)
(key t--search-forward-center 't-quick-search)
(key "C-M-s-q" 't-quick-search)
(key "C-l" 't-quick-search)

(define-key evil-emacs-state-map (kbd "<escape>") 't-quick-search)

(key "C-M-S-s-e" 't-quick-search-no-b)
(define-key evil-visual-state-map (kbd t--search-forward-center) 'quick-search2)
(define-key evil-visual-state-map (kbd "C-l") 'quick-search2)

(key "<return>" '(cond (current-prefix-arg
                        (ci 'evil-goto-line))
                       (t (ci 't-search-next))))

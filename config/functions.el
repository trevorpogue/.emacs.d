(with-eval-after-load 'evil
  (defalias #'forward-evil-word #'forward-evil-symbol))
(add-hook 'python-mode-hook
          (lambda ()
            (setq-default indent-tabs-mode t)
            (setq-default tab-width 1)
            (setq-default py-indent-tabs-mode t)
            (add-to-list 'write-file-functions 'delete-trailing-whitespace)))
(setq scroll-preserve-screen-position t)

(defun comment-line (n)
  "Comment or uncomment current line and leave point after it.
With positive prefix, apply to N lines including current one.
With negative prefix, apply to -N lines above.  Also, further
consecutive invocations of this command will inherit the negative
argument.
If region is active, comment lines in active region instead.
Unlike `comment-dwim', this always comments whole lines."
  (interactive "p")
  (if (use-region-p)
      (comment-or-uncomment-region
       (save-excursion
         (goto-char (region-beginning))
         (line-beginning-position))
       (save-excursion
         (goto-char (region-end))
         (previous-line)
         (line-end-position)))
    (when (and (eq last-command 'comment-line-backward)
               (natnump n))
      (setq n (- n)))
    (let ((range (list (line-beginning-position)
                       (goto-char (line-end-position n)))))
      (comment-or-uncomment-region
       (apply #'min range)
       (apply #'max range)))
    (beginning-of-line)
    (unless (natnump n) (setq this-command 'comment-line-backward)))
  (font-lock-fontify-buffer)
  )

;; *eshell*
(setq eshell-cmpl-compare-entry-function
      (function
       (lambda (left right)
         (let ((exts completion-ignored-extensions) found)
           (while exts
             (if (string-match (concat "\\" (car exts) "$") right)
                 (setq found t exts nil))
             (setq exts (cdr exts)))
           (if found
               nil
             (file-newer-than-file-p left right))))))

(defun my-middle-of-line ()
  "Put cursor at the middle point of the line."
  (interactive)
  (goto-char (/ (+ (point-at-bol) (point-at-eol)) 2)))


(defun ergoemacs-forward-open-bracket (&optional number)
  "Move cursor to the next occurrence of left bracket/ quotation mark.
With prefix NUMBER, move forward to the next NUMBER left bracket
or quotation mark.
With a negative prefix NUMBER, move backward to the previous
NUMBER left bracket or quotation mark."
  (interactive "p")
  (if (and number
           (> 0 number))
      (ergoemacs-backward-open-bracket (- 0 number))
    (forward-char 1)
    (search-forward-regexp
     (eval-when-compile
       (regexp-opt
        '("\"" "(" "{" "[" "<" "〔" "【" "〖" "〈" "《"
          "「" "『" "“" "‘" "‹" "«"))) nil t number)
    (backward-char 1)))

(defun ergoemacs-backward-open-bracket (&optional number)
  "Move cursor to the previous occurrence of left bracket or quotation mark.
With prefix argument NUMBER, move backward NUMBER open brackets.
With a negative prefix NUMBER, move forward NUMBER open brackets."
  (interactive "p")
  (if (and number
           (> 0 number))
      (ergoemacs-forward-open-bracket (- 0 number))
    (search-backward-regexp
     (eval-when-compile
       (regexp-opt
        '("\"" "(" "{" "[" "<" "〔" "【" "〖" "〈" "《" "「"
          "『" "“" "‘" "‹" "«"))) nil t number)))

(defun ergoemacs-forward-close-bracket (&optional number)
  "Move cursor to the next occurrence of right bracket or quotation mark.
With a prefix argument NUMBER, move forward NUMBER closed bracket.
With a negative prefix argument NUMBER, move backward NUMBER closed brackets."
  (interactive "p")
  (if (and number
           (> 0 number))
      (ergoemacs-backward-close-bracket (- 0 number))
    (search-forward-regexp
     (eval-when-compile
       (regexp-opt '("\"" ")" "]" "}" ">" "〕" "】" "〗" "〉" "》" "」" "』" "”" "’" "›" "»"))) nil t number))
  )

(defun ergoemacs-backward-close-bracket (&optional number)
  "Move cursor to the previous occurrence of right bracket or quotation mark.
With a prefix argument NUMBER, move backward NUMBER closed brackets.
With a negative prefix argument NUMBER, move forward NUMBER closed brackets."
  (interactive "p")
  (if (and number
           (> 0 number))
      (ergoemacs-forward-close-bracket (- 0 number))
    (backward-char 1)
    (search-backward-regexp
     (eval-when-compile
       (regexp-opt '("\"" ")" "]" "}" ">" "〕" "】" "〗" "〉" "》" "」" "』" "”" "’" "›" "»"))) nil t number)
    (forward-char 1)))

(defun my-begin-end ()
  (interactive)
  (evil-end-of-line)
  (forward-char)
  (insert " begin\nend")
  (indent-for-tab-command)
  (evil-beginning-of-line)
  )
(setq-default evil-escape-key-sequence "fd")
(setq-default evil-escape-delay 0.4)
(setq auto-window-vscroll nil)

(evil-define-command my-paste-after-0 (count &optional register yank-handler)
  :suppress-operator t
  (interactive "P<x>")
  (if (not (= (current-column) 0)) (left-char))
  (if (not my-paste-mode) (let ((register ?b)) (evil-paste-after count register yank-handler)))
  (if my-paste-mode (evil-paste-after count register yank-handler))
  (if (eq major-mode 'verilog-mode)
      (execute-kbd-macro (kbd "TAB"))
    )
  )

(evil-define-command my-paste-before-0 (count &optional register yank-handler)
  :suppress-operator t
  (interactive "P<x>")
  (if (not my-paste-mode) (let ((register ?b)) (evil-paste-before count register yank-handler)))
  (if my-paste-mode (evil-paste-before count register yank-handler))
  )

(evil-define-operator my-yank-0 (beg end type register yank-handler)
  :move-point nil
  :repeat nil
  (interactive "<R><x><y>")
  (evil-yank beg end type register yank-handler)
  (let ((register ?b))
    (evil-yank beg end type register yank-handler)
    )

  )
(evil-define-operator my-yank-line-0 (beg end type register yank-handler)
  :motion evil-line-or-visual-line
  :move-point nil
  (interactive "<R><x>")
  (evil-yank-line beg end type register)
  (let ((register ?b))
    (evil-yank-line beg end type register)
    )
  )

(defun my-top-space ()
  (interactive)
  (call-interactively 'evil-goto-first-line)
  (let ((x (line-number-at-pos)))
    (while (> 10 x)
      (progn
        (evil-goto-first-line)
        (evil-open-above nil)
        (insert "~")
        (call-interactively 'comment-line)
        (evil-goto-line x)
        (cl-incf x)
        )
      (call-interactively 'evil-next-visual-line)
      )
    (call-interactively 'evil-previous-visual-line)
    )
  )


(defun t--next-line ()
  (interactive)
  (> 64 (line-number-at-pos))
  (progn
    (let ((r (line-number-at-pos)))
      (evil-goto-first-line)
      (call-interactively 'comment-line)
      (call-interactively 'evil-previous-visual-line)
      (evil-beginning-of-visual-line)
      (if (save-excursion (looking-at-p "~"))
          (progn
            (call-interactively 'evil-delete-whole-line)
            (evil-goto-line r)
            )
        (progn
          (call-interactively 'comment-line)
          (evil-goto-line r)
          (call-interactively 'evil-next-visual-line)
          )
        )
      )
    )
  )

(defun my-set-marker1 () (interactive) (evil-set-marker ?x))
(defun my-set-marker2 () (interactive) (evil-set-marker ?y))
(defun my-set-marker3 () (interactive) (evil-set-marker ?z))

(evil-define-command my-goto-marker1 ()
  "Go to the line of the marker specified by ?x."
  :keep-visual t
  :repeat nil
  :type line
  :jump t
  (call-interactively 'my-set-marker2)
  (evil-goto-mark ?x)
  )

(evil-define-command my-goto-marker2 ()
  "Go to the line of the marker specified by ?b."
  :keep-visual t
  :repeat nil
  :type line
  :jump t
  (call-interactively 'my-set-marker1)
  (evil-goto-mark ?y)
  )

(evil-define-command my-goto-marker3 ()
  "Go to the line of the marker specified by ?b."
  :keep-visual t
  :repeat nil
  :type line
  :jump t
  (evil-goto-mark ?z)
  )

(defun set-spacemacs-command ()
  (interactive)
  ;; TODO: weird paste effect with c-u
  (call-interactively 'evil-end-of-visual-line)
  (call-interactively 'eval-last-sexp)
  )


(setq avy-timeout-seconds 0.7)
(bind-key* "<backspace>" 'delete-backward-char)
(bind-key* "<delete>" 'delete-char)
(define-key evil-normal-state-map (kbd "<backspace>") 'evil-delete-backward-char)
(define-key evil-normal-state-map (kbd "<delete>") 'evil-delete-char)
(define-key evil-visual-state-map (kbd "<backspace>") 'evil-delete-backward-char)
(define-key evil-visual-state-map (kbd "<delete>") 'evil-delete-char)
(define-key evil-normal-state-map (kbd "<S-return>") 'evil-search-previous)
(delete-selection-mode 1)
(evil-set-initial-state 'pdf-view-mode 'normal)

(setq save-interprogram-paste-before-kill t)
(setq x-select-enable-clipboard t)
(setq my-paste-mode t)

(define-key evil-visual-state-map (kbd "M-m") 'spacemacs/align-repeat-equal)
(define-key evil-visual-state-map (kbd "M-,") 'spacemacs/align-repeat-left-paren)
(define-key evil-visual-state-map (kbd "M-.") 'spacemacs/align-repeat)

(require 'cc-mode)
(add-hook 'ecmascript-mode-hook
          (lambda ()
            (c-set-offset 'arglist-intro '1)
            (c-set-offset 'arglist-close 0)))

(defun my-init-fun ()
  (global-display-line-numbers-mode 0)
  )
(defun inverse-init-fun ()
  )
(my-init-fun)

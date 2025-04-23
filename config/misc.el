;; don't know what this is, or maybe obsolete
(global-set-key (kbd "C-M-s-:") 'evil-ex)

(key "<escape>" 'esc)
;; (define-key evilified-state--normal-state-map (kbd "<escape>") 'esc)
(global-set-key (kbd "C-M-n") 'evil-normal-state)
(define-key evil-visual-state-map (kbd "C-M-s-v") 'evil-emacs-state)
(global-set-key (kbd "C-M-S-i")    'evil-visual-block)
(define-key evil-visual-state-map (kbd "C-M-S-i") 'evil-insert)
(global-set-key (kbd "M-C-S-a") 'evil-append)
(setq evil-default-state 'emacs)

;; visual
;; (key (kbd "C--"))
;; (key (kbd "C-="))
;; (global-set-key (kbd "C--") 'zoom-frm-out)
;; (global-set-key (kbd "C-=") 'zoom-frm-in)
(global-set-key (kbd "C-M-s-c") 'evil-search-highlight-persist-remove-all)
(global-set-key (kbd "C-M-s-j") (lambda () (interactive)
                                  (topspace 0)))
(global-set-key (kbd "M-s-S-j") (lambda () (interactive)
                                  (topspace 1)))

;; utilities
;; (unbind-key (kbd "&") evil-visual-state-map)
;; (unbind-key (kbd "M-s-i") global-map)
;; (unbind-key (kbd ".") evil-visual-state-map)
;; (global-unset-key (kbd ""))
;; (local-unset-key (kbd "&"))
(global-set-key (kbd "C-M-s-q") #'(lambda () (t--show-buf "*Backtrace*" 1)))


(setq debug-on-error nil)
(key "<f7>"
      ;; '(setq debug-on-error t)
      ;; '(t--show-buf "*Backtrace*" t--backtrace-win)
      ;; '(t--show-buf "*Messages*" t--messages-win)
     '(progn
        (end-of-line)
      (set-spacemacs-command)
      ;; (next-logical-line)
      ;; '(setq debug-on-error nil)
      ))
(key "C-S-s-l" 'set-spacemacs-command)

(key "C-s-S-q"
      ;; '(setq debug-on-error t)
      ;; '(t--show-buf "*Backtrace*" t--backtrace-win)
      ;; '(t--show-buf "*Messages*" t--messages-win)
      'eval-buffer
      ;; '(setq debug-on-error nil)
      )

;; (key "C-s-S-q" '(eval-buffer))
(global-set-key (kbd "C-S-t")
                (lambda () (interactive)
                  (call-interactively 'set-spacemacs-command)
                  (call-interactively 'next-line)
                  ))
(global-set-key (kbd "C-M-s-S-q")
                (lambda () (interactive)
                  (dotspacemacs/sync-configuration-layers)
                  (inverse-init-fun)
                  ))
(global-set-key (kbd "C-M-s-k") 'describe-key)
;; (global-set-key (kbd "C-s") 't-save-format)
(key "C-s"
          ;; '(ignore-errors (spacemacs/indent-region-or-buffer))
      '(ci 'evil-write-all)
          )
(global-set-key (kbd "M-s-x") 'my-set-marker1)
(global-set-key (kbd "M-s-z") 'my-set-marker2)
(key "C-M-s-x" '(my-goto-marker1))
(key "C-M-s-n" '(my-goto-marker2))
(key "C-M-S-x" '(my-set-marker3))
(key "C-M-x" '(my-goto-marker3))

(key "C-M-S-t" '
     (evil-record-macro ?t)
     )
;; (key "C-t")
(key "C-M-s-t" '(evil-execute-macro current-prefix-arg (get-register ?t)))

;; misc
;; (helm-posframe-enable)
;; (key "C-M-s-S-a" 'anaconda-mode-complete)
;; (lsp-rename)
;; (key "C-M-s-S-a" '(evil-write-all nil)
;; '(t--show-buf "*Elpy Edit Usages*" t--refactor-win)
;; '(elpy-multiedit-python-symbol-at-point))
(key "C-M-s-S-a"
      ;; '(t--mini-frame-mode 1)
      '())
;; (key "M-s-r" '(print (buffer-name)))
;; (key "M-<up>" 'elpy-nav-indent-shift-left)
;; (key "M-<down>" 'elpy-nav-indent-shift-right)

(custom-set-variables
 '(mouse-avoidance-banish-position '((frame-or-window . frame)
                                     (side . right)
                                     (side-pos . -4)
                                     (top-or-bottom . top)
                                     (top-or-bottom-pos . -1)))
 )
;; (mouse-avoidance-mode 'banish)
(mouse-avoidance-mode -1)
;; f12 run
                                                                                ; macros

(defun my-let-add (var)
  (interactive "swhat do add? ")
  (save-excursion
    (beginning-of-defun)
    (search-forward "(let" nil t)
    (search-forward ")" nil t)
    (left-char)
    (unless (looking-back "(")
      (insert " "))
    (insert var)))

;; (setq-default auto-fill-function 'do-auto-fill)
(setq-default auto-fill-function 'nil)

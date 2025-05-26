;; don't know what this is, or maybe obsolete
(global-set-key (kbd "C-M-s-:") 'evil-ex)

(key "<escape>" 'esc)
(key "<escape>" 'esc)
(define-key evil-normal-state-map (kbd "<escape>") 'esc)
(key "<f1>" 'esc)

(define-key evil-emacs-state-map (kbd "<f7>") 'torg-insert)

(global-set-key (kbd "C-M-n") 'evil-normal-state)
(define-key evil-visual-state-map (kbd "C-M-s-v") 'evil-emacs-state)
(global-set-key (kbd "C-M-S-i")    'evil-visual-block)
(define-key evil-visual-state-map (kbd "C-M-S-i") 'evil-insert)

(global-set-key (kbd "M-C-S-a") 'evil-append)
(setq evil-default-state 'emacs)

;; visual
(global-set-key (kbd "C-M-s-c") 'evil-search-highlight-persist-remove-all)
(global-set-key (kbd "C-M-s-j") (lambda () (interactive)
                                  (topspace 0)))
(global-set-key (kbd "M-s-S-j") (lambda () (interactive)
                                  (topspace 1)))

;; utilities


(setq debug-on-error nil)
(key "C-S-s-l" 'set-spacemacs-command)

(key "C-s-S-q" 'eval-buffer)

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
(key "C-s" '(ci 'evil-write-all))
(global-set-key (kbd "M-s-x") 'my-set-marker1)
(global-set-key (kbd "M-s-z") 'my-set-marker2)
(key "C-M-s-x" '(my-goto-marker1))
(key "C-M-s-n" '(my-goto-marker2))
(key "C-M-S-x" '(my-set-marker3))
(key "C-M-x" '(my-goto-marker3))

(key "C-M-S-t" '(evil-record-macro ?t))
(key "C-M-s-t" '(evil-execute-macro current-prefix-arg (get-register ?t)))

;; misc
(custom-set-variables
 '(mouse-avoidance-banish-position '((frame-or-window . frame)
                                     (side . right)
                                     (side-pos . -4)
                                     (top-or-bottom . top)
                                     (top-or-bottom-pos . -1)))
 )
(mouse-avoidance-mode -1)
;; f12 run

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

(setq-default auto-fill-function 'nil)

(defun t-set-cmd (&optional &rest args)
  (interactive)
  (save-buffer)
  (save-excursion
    (end-of-line)
    (call-interactively 'eval-last-sexp)))

(defun is-at-last-col ()
        (interactive)
        (save-excursion
                (end-of-line)
                (setq last-col (current-column))
                )
        (setq was-at-last-col 0)
        (if (eq last-col (current-column))
                        (setq was-at-last-col 1)
                )
        )

(defun t-rm-srch-highlight (&optional &rest args)
  (interactive)
  (evil-search-highlight-persist-remove-all)
  (evil-escape))

(define-key evil-visual-state-map (kbd "C-x") 'evil-delete)

(key "C-S-c" 'my-yank-0)
(key "C-M-c" 'evil-delete)
(key "C-S-x" 'evil-delete)

(key "C-y" 'undo-tree-redo)
(key "C-z" 'undo-tree-undo)

(define-key evil-visual-state-map (kbd "C-c") 'my-yank-line-0)
(define-key evil-emacs-state-map (kbd "C-c") 'my-yank-line-0)
(define-key evil-emacs-state-map (kbd "C-x") 'evil-delete-whole-line)
(key "C-S-v" 'my-paste-before-0)
(key "C-v" 'my-paste-after-0)
(define-key isearch-mode-map (kbd "C-v") 'isearch-yank-kill)
(define-key isearch-mode-map (kbd "C-S-v") 't-isearch-yank)
(define-key isearch-mode-map (kbd "C-S-v") nil)
(define-key isearch-mode-map (kbd "<escape>") 't-rm-srch-highlight)
(define-key isearch-mode-map (kbd "C-f") 't-rm-srch-highlight)


(global-set-key (kbd "C-M-s-a") 'spacemacs/copy-whole-buffer-to-clipboard)
(global-set-key (kbd "C-M-s-p") 'spacemacs/copy-clipboard-to-whole-buffer)

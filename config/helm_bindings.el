(require 'helm)
(require 'helm-rg)

(setq header-line-format '(:eval "test2"))
;; C-c a
;; (helm-buffers-toggle-show-hidden-buffers)
;; C-x b
;; helm-ag-base-command
(key "M-s-<left>" 'helm-resume-previous-session-after-quit)
(key "M-s-<right>" 'helm-resume-list-buffers-after-quit)
(define-key helm-buffer-map (kbd "<return>")
    (lambda () (interactive) (execute-kbd-macro (kbd "RET"))))
(define-key helm-rg-map (kbd "<tab>")
  (lambda () (interactive)
    ;; (setq helm-persistent-action-display-window
          ;; (winum-select-window-by-number (1- t--help-win)))
    (helm-execute-persistent-action 'persistent-action t)))

(define-key helm-find-files-map (kbd "<left>")
  (lambda () (interactive) (execute-kbd-macro (kbd "C-h"))))
(define-key helm-find-files-map (kbd "S-<return>")
    (lambda () (interactive)
      (execute-kbd-macro (kbd "<return> M-<left> C-w"))
      (ci 'previous-buffer)
      (ci 'kill-this-buffer)
      ))

(define-key helm-find-files-map (kbd "<right>")
    (lambda () (interactive)
        (execute-kbd-macro (kbd "C-l"))
        ))

(define-key helm-find-files-map (kbd "<return>")
    (lambda () (interactive) (execute-kbd-macro (kbd "RET"))))

(define-key helm-find-files-map (kbd "S-<return>")
    (lambda () (interactive) (execute-kbd-macro (kbd "C-h"))))

(setq helm-buffer-max-length 40)

(key "C-M-f"
     '(let ((table (copy-syntax-table (syntax-table))))
        (when (eq major-mode 'latex-mode)
          (modify-syntax-entry ?- "w" table)
          (modify-syntax-entry ?: "w" table))
          (t--before-helm)
          ;; '(spacemacs/helm-dir-smart-do-search)
          ;; '(evil-emacs-state)
          (ci 'helm-rg)
          ;; '(ci 'helm-ag)
          ;; '(ci 'helm-do-grep-ag)
          (t--after-helm)
          ))

(key "C-M-d"
          '(t--before-helm)
          ;; '(ci 'helm-find)
          ;; '(ci 'ffip)
          '(ci 'find-file-in-current-directory)
          '(t--after-helm))

(setq ffip-use-rust-fd t)
(setq ffip-find-options "-H -I")
(setq ffip-find-options "-H -I")
;; (setq find-program "fd")

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; skip dots in helm
(defun helm-skip-dots (old-func &rest args)
    "Skip . and .. initially in helm-find-files.  First call OLD-FUNC with ARGS."
    (apply old-func args)
    (let ((sel (helm-get-selection)))
        (if (and (stringp sel) (string-match "/\\.$" sel))
                (helm-next-line 2)))
    (let ((sel (helm-get-selection))) ; if we reached .. move back
        (if (and (stringp sel) (string-match "/\\.\\.$" sel))
                (helm-previous-line 1))))

(advice-add #'helm-preselect :around #'helm-skip-dots)
(advice-add #'helm-ff-move-to-first-real-candidate :around #'helm-skip-dots)

(use-package helm
    :init
    (helm-icons-enable)
    :defer
    t
    )

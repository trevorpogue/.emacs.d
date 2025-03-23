(require 'helm)

(setq header-line-format '(:eval "test2"))
;; C-c a
;; (helm-buffers-toggle-show-hidden-buffers)
;; C-x b
;; helm-ag-base-command
(key "M-s-<left>" 'helm-resume-previous-session-after-quit)
(key "M-s-<right>" 'helm-resume-list-buffers-after-quit)
(define-key helm-buffer-map (kbd "<return>")
		(lambda () (interactive) (execute-kbd-macro (kbd "RET"))))

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

;; (define-key helm-buffer-map (kbd "<escape>") 'keyboard-escape-quit)
;; (define-key helm-find-files-map (kbd "<escape>") 'keyboard-escape-quit)
(define-key helm-find-files-map (kbd "<prior>") 'esc)

(key "C-M-f"
					'(t--before-helm)
					;; '(spacemacs/helm-dir-smart-do-search)
					;; '(evil-emacs-state)
					'(ci 'helm-rg)
					;; '(ci 'helm-ag)
					;; '(ci 'helm-do-grep-ag)
					'(t--after-helm)
					)

(key "C-M-d"
					'(t--before-helm)
					'(ci 'helm-find)
					'(t--after-helm)
					)

;; (setq)
;; (custom-set-variables
;; '(helm-ag-base-command
;; "~/anaconda3/bin/rg --no-heading --smart-case --color=ansi --colors=match:fg:red --colors=match:style:bold"))
;; "ag --vimgrep")

;; `(helm-ag-success-exit-status '(0 2))
;; )

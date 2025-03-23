(defun use-main-project (&rest args)
	"Skip calling `projectile-project-root' when there is a main project defined."
	(when projectile-main-project

		projectile-main-project))
(setq t--projectile-project-1 "~/.emacs.d/config")
(setq t--projectile-project-2 "~/")
;; (setq projectile-main-project "~/elisp")
;; (setq projectile-main-project nil)
;; (defun use-main-project (&rest args)
;;			"Skip calling `projectile-project-root' when there is a main project defined."
;;			(when projectile-main-project
;;					projectile-main-project))
;; (advice-add #'projectile-project-root :before-until #'use-main-project)

;; (key "M-C-s-r" '(t--before-helm) '(projectile-find-file) '(t--after-helm))
(key "M-S-<prior>" '(t--before-helm)
		 '(projectile-switch-project-by-name t--projectile-project-2)
		 '(t--after-helm))
;; (key "M-S-<next>" '(t--before-helm) '(projectile-switch-project-by-name
;; t--projectile-project-2)
;; (key "M-S-<prior>" '(t--before-helm) '(projectile-switch-project)
;; '(t--after-helm))
(key "M-S-<next>" '(t--before-helm) '(projectile-find-file)
		 '(t--after-helm))

;; (key "M-S-<prior>" '(t--mini-frame-mode -1) '(projectile-switch-project))
;; (key "M-S-<next>" '(t--mini-frame-mode -1) '(projectile-find-file))
;; (setq projectile-switch-project-action 'projectile-recentf)
(setq projectile-switch-project-action 'projectile-find-file)
;; (setq projectile-switch-project-action nil)
;; (setq projectile-indexing-method 'native)
(setq projectile-indexing-method 'alien)
(setq projectile-indexing-method 'hybrid)

(setq projectile-sort-order 'modification-time)
(setq projectile-sort-order 'access-time)
(setq projectile-sort-order 'recently-active)
(setq projectile-sort-order 'recentf)
(setq projectile-sort-order 'default)

(setq projectile-enable-caching nil)
(setq projectile-enable-caching t)


(defun t-invalidate-cache (&rest args)
	(interactive)
	(ci 'projectile-invalidate-cache)
	)
(defun t-invalidate-caches ()
	(interactive)
	(setq projectile-switch-project-action 't-invalidate-cache)
	(dolist (project (projectile-open-projects))
		(projectile-switch-project-by-name project)
		;; (ci 'projectile-invalidate-cache)
		)
  (setq projectile-switch-project-action 'projectile-find-file)
  )
;; (t-invalidate-caches)

;; (add-to-list 'projectile-globally-ignored-directories "article")
;; (delete "article" projectile-globally-ignored-directories)

(projectile-mode +1)
(key "M-x" '(t--mini-frame-mode -1) '(spacemacs/helm-M-x-fuzzy-matching))
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
;; (setq projectile-project-search-path '("~/dla/python" "~/elisp"))
(setq projectile-auto-discover t)
;; (setq projectile-project-search-path '("~/dla/"))
;; (projectile-discover-projects-in-search-path)
;; (dired-jump) open current dir
(setq projectile-mode-line "Projectile")

;; (defvar projectile-main-project "~/projects/foo")
;; (key "M-C-s-r" '(t--before-helm) '(projectile-switch-project) '(t--after-helm))

(defun t-dired-hook ()
  (dired-hide-details-mode 1))

(add-hook 'dired-mode-hook 't-dired-hook)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Buffer Switching ;;;;

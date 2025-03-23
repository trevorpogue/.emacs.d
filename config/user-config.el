(setq debug-on-error t)
(setq frame-title-format "glitch")
(setq frame-title-format "Emacs %b")
(setq frame-title-format "Emacs")
(setq t--comp-dir "~/dla2")
(setq t--comp-dir "~/dla")
(setq t--debug nil)
(load-file "~/.emacs.d/config/conda.el")
(setq t--comp-command "bash ~/run2")
(setq t--comp-command "bash ~/run")
(setq t--log-buffer-name "*outlog2*")
(setq t--comp-dir "~/dla")
(setq t--logfile-fullname (concat t--comp-dir "/*outlog2*"))
(setq t--log-buffer-name "*outlog*")
(setq t--logfile-fullname (concat t--comp-dir "/*outlog*"))
(scroll-bar-mode -1)
(setq explicit-shell-file-name "~/miniconda3/envs/env0/bin/xonsh")
(setq t-topspace-dev nil)
;; (setq t-topspace-dev t)
(setenv "T_RUN" "3")
(setenv "T_RUN" "2")
(setenv "T_RUN" "1")
(setenv "RIPGREP_CONFIG_PATH" "~/.rg")

(when t-topspace-dev
  (use-package topspace
    :load-path "~/topspace"
    :config (global-topspace-mode)))
(use-package centercursor
  :load-path "~/.emacs.d/config/centercursor"
  :config (global-centercursor-mode)
  )
(custom-set-variables
 ;; '(topspace-center-position 0.5)
 ;; '(topspace-active #'t-topspace-active)
 )

;; (setq topspace-center-position 0.4)
;; (defun my-topspace-active () (not (eq major-mode 'shell-mode)))
;; (setq topspace-active #'my-topspace-active)

(load-file "~/.emacs.d/config/main.el")
(setq debug-on-error t)
;; (setq evil-default-state 'emacs)
(load-file "~/.emacs.d/config/utils.el")
(eval-when-compile
  (add-to-list 'load-path "~/.emacs.d/config/facemenu.el")
  (require 'use-package))

(unless t-topspace-dev (global-topspace-mode 1))
;; (load-file "~/.emacs.d/config/theme.el")
(load-file "~/.emacs.d/config/flycheck.el")
(load-file "~/.emacs.d/config/functions.el")
(load-file "~/.emacs.d/config/helm.el")
;; (load-file "~/.emacs.d/config/ivy.el")
;; (load-file "~/.emacs.d/config/file.el")
;; (load-file "~/.emacs.d/config/topspace/test/director.el")
(load-file "~/.emacs.d/config/shift.el")
(load-file "~/.emacs.d/config/search_replace.el")
(load-file "~/.emacs.d/config/scroll.el")
(load-file "~/.emacs.d/config/copy_paste.el")
(load-file "~/.emacs.d/config/navigation.el")
(load-file "~/.emacs.d/config/avy.el")
(load-file "~/.emacs.d/config/eshell.el")
(load-file "~/.emacs.d/config/windows.el")
(load-file "~/.emacs.d/config/misc.el")
(load-file "~/.emacs.d/config/buffer.el")
(load-file "~/.emacs.d/config/help.el")
(load-file "~/.emacs.d/config/avy.el")
(load-file "~/.emacs.d/config/text.el")
(load-file "~/.emacs.d/config/compilation.el")
(load-file "~/.emacs.d/config/eshell-posframe.el")
(load-file "~/.emacs.d/config/tramp.el")
(load-file "~/.emacs.d/config/lsp.el")
(load-file "~/.emacs.d/config/latex.el")
(load-file "~/.emacs.d/config/magit.el")
;; (load-file "~/.emacs.d/config/emacs-director/director.el")
(define-key evil-insert-state-map (kbd "<up>") 'eshell-previous-input)
(define-key evil-insert-state-map (kbd "<down>") 'eshell-next-input)
(define-key evil-visual-state-map (kbd "C-v")
  (lambda () (interactive) (ci 'evil-yank) (esc) (ci 'evil-paste-before)))
(autoload 'View-scroll-half-page-forward "view")
(autoload 'View-scroll-half-page-backward "view")
(find-file-noselect "~/.emacs.d/config/compilation.el" t)
(find-file-noselect "~/.emacs.d/config/comp_bindings.el" t)
(find-file-noselect "~/.emacs.d/config/help.el" t)

;; magit-display-buffer-function : control magit popup window position


;; (use-package flycheck-posframe
;; :ensure t
;; :after flycheck
;; :config (add-hook 'flycheck-mode-hook #'flycheck-posframe-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; treemacs
(setq treemacs-position 'right)
(treemacs-icons-dired-mode)

(global-company-mode 1)
(load-file "~/.emacs.d/config/verilog.el")

(use-package org :config (org-mode))

(load-file "~/.emacs.d/config/org.el")
(add-hook 'org-mode-hook 't--org-mode-hooks 100)
;; (add-hook 'org-cycle-hook
;;           (lambda (state)
;;             (when (eq state 'children)
;;               (setq org-cycle-subtree-status 'subtree))))
;; (add-hook 'org-cycle-hook
;;           (lambda (state)
;;             (when (eq state 'folded)
;;               (setq org-cycle-subtree-status 'children))) 100)
;; ;; (use-package coverage-mode
;; :load-path "~/.emacs.d/config/coverage-mode.el")
;; (setq anaconda-mode-use-posframe-show-doc t)
(use-package facemenu)
(global-evil-search-highlight-persist 1)
;; (global-undo-tree-mode -1)

(define-globalized-minor-mode my-global-undo-tree-mode undo-tree-mode
  (lambda () (undo-tree-mode 1)))
(my-global-undo-tree-mode 1)

(spacemacs/toggle-fill-column-indicator-globally)
;; TODO: duplication keys not binded
(setq dired-recursive-deletes 'top)

;; optionally if you want to use debugger
(use-package dap-mode)
;; (use-package dap-LANGUAGE);; to load the dap adapter for your language----+--

;; optional if you want which-key integration
(use-package which-key
  :config
  (which-key-mode))
(which-key-posframe-mode)
(setq-default indent-tabs-mode nil)
;; (infer-indentation-style)

;; (key "C-M-f" )
;; (aggressive-indent-global-mode 1)
;; (load-file "~/.emacs.d/config/test.el")

(key "C-S-t" '(print (frames-on-display-list)))
(key "C-M-s-S-l" '(kmacro "<kp-enter>"))
(key "M-s-l" '(kmacro "<kp-enter>"))
(key "C-S-t" 'which-key-show-major-mode)
(key "C-S-t" 'which-key-show-major-mode)
;; (key "C-S-t" '(setq my-paste-mode (not my-paste-mode)))
(defun t-toggle-copy-paste-mode ()
  (interactive)
  (setq my-paste-mode (not my-paste-mode))
  )
;; (key "C-S-t" '(setq my-paste-mode (not my-paste-mode)))
(key "C-M-e" '(ci 'evil-goto-line) '(centercursor-recenter))

(setq eldoc-echo-area-use-multiline-p 'truncate-sym-name-if-fit)
(custom-set-variables
 '(flycheck-posframe-position 'window-top-left-corner)
 '(evil-escape-key-sequence "qwertyu")
 ;; '(ccm-vpos 50)
 '(ccm-vpos-init (integer :tag "Lines from top" :value 60))
 '(ccm-step-delay 0)
 ;; '(topspace-empty-line-indicator #'topspace-default-empty-line-indicator)
 '(company-global-modes '(not lisp-data-mode))
 )
;; (custom-set-variables '(topspace-autocenter-buffers t))
(setq ccm-vpos 60)
;; '(eldoc-overlay-delay 1000)
;; '(eldoc-x)

(global-hl-line-mode 1)
;; (set-face-background 'hl-line "#101010")
(set-face-background 'hl-line "#000000")
(set-face-foreground 'highlight nil)

(transient-posframe-mode)
;; (progn
;; keep for compilation:
(unless (display-graphic-p)
  (switch-to-buffer (find-file-noselect "~/.emacs.d/config/main.el" t)))
;; (set-frame-size (selected-frame) 3825 (- 2160 0) t)
(when (display-graphic-p)
  (set-frame-position (selected-frame) 0 0)
  (switch-to-buffer (find-file-noselect "~/.emacs.d/config/main.el" t))
  (switch-to-buffer (find-file-noselect "~/.emacs.d/config/user-config.el" t))
  ;; (split-window-right 59)
  (split-window-right 200)
  (split-window-below 1)
  (split-window-right)
  (split-window-right)
  (switch-to-buffer "*Warnings*")
  (windmove-right)
  (switch-to-buffer "*Messages*")
  (windmove-right)
  (switch-to-buffer "*Backtrace*")
  (windmove-down)
  (t-set-window-width 35)
  (windmove-right)
  (switch-to-buffer (find-file-noselect "~/dla/" t))
  (split-window-right t-window-width)
  (windmove-right)
                                        ;
  (switch-to-buffer (find-file-noselect "~/dla/" t))
  (split-window-right t-window-width)
  (windmove-right)
                                        ;
  (switch-to-buffer (find-file-noselect "~/dla/" t))
  (split-window-right t-window-width)
  (windmove-right)
                                        ;
  (switch-to-buffer (find-file-noselect "~/dla/" t))
  (split-window-right t-window-width)
  (windmove-right)
  (split-window-right t-window-width)
                                        ;
  ;; (switch-to-buffer (find-file-noselect "~/dla/" t))
  ;; (split-window-right t-window-width)
  ;; (windmove-right)
                                        ;
  ;; (switch-to-buffer "*Messages*")
  ;; (split-window-right t-window-width)
  ;; (windmove-right);
  (dotimes (i 2) (windmove-left))
  )

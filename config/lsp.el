;; (use-package lsp-pyright
;;			:straight t
;;			:defer t
;;			:diminish eldoc-mode
;;			:hook ((python-mode . (lambda () (require 'lsp-pyright)))
;;										(python-mode . lsp-deferred))
;;			:config
;;			;; these hooks can't go in the :hook section since lsp-restart-workspace
;;			;; is not available if lsp isn't active
;;			(add-hook 'conda-postactivate-hook (lambda () (lsp-restart-workspace)))
;;			(add-hook 'conda-postdeactivate-hook (lambda () (lsp-restart-workspace))))

;; (use-package lsp-pyright
;;				:ensure t
;;				:hook (python-mode . (lambda ()
;;																											(require 'lsp-pyright)
;;																											(lsp)))
;;							:config
;;							(add-to-list 'lsp-disabled-clients 'pyls)
;;							(add-to-list 'lsp-disabled-clients 'jedi)
;;							(add-to-list 'lsp-enabled-clients 'pyright)
;;				)  ; or lsp-deferred

;; (use-package lsp-python-ms
;;   :ensure t
;;   :init (setq lsp-python-ms-auto-install-server t)
;;   :hook (python-mode . (lambda ()
;;                          (require 'lsp-python-ms)
;;                          (lsp))))  ; or lsp-deferred

;; (use-package lsp-pyright
;;   :ensure t
;;   :hook (python-mode . (lambda ()
;;                          (require 'lsp-pyright)
;;                          (lsp))))  ; or lsp-deferred


;; (require 'lsp-python-ms)
;; (setq lsp-python-ms-auto-install-server t)
;; (add-hook 'python-mode-hook #'lsp) ; or lsp-deferred


(add-hook 'python-mode-hook 'turn-on-auto-fill)

;; (use-package lsp-python-ms
;;			:ensure t
;;			:init (setq lsp-python-ms-auto-install-server t)
;;			:hook (python-mode . (lambda ()
;;																										(require 'lsp-python-ms)
;;																										(lsp))))  ; or lsp-deferred

;; (defun t-lsp-headerline-breadcrumb-mode (&rest _args)
  ;; (lsp-headerline-breadcrumb-mode -1))

;; (use-package lsp-jedi
;; 							:ensure t
;; 							:config
;; 														(add-to-list 'lsp-disabled-clients 'pyls)
;; 														(add-to-list 'lsp-disbled-clients 'pyright)
;; 														(add-to-list 'lsp-disbled-clients 'mspyls)
;; 														(add-to-list 'lsp-disabled-clients 'pylsp)
;; 														(add-to-list 'lsp-enabled-clients 'jedi)
;; 							)

;; (add-hook 'lsp-mode-hook #'t-lsp-headerline-breadcrumb-mode)
(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration)
         ;; (verilog-mode . lsp)
         ;; (vhdl-mode . lsp)
         ;; (sh-mode . nil)
         )
  :commands lsp
  :config
  (setq lsp-headerline-breadcrumb-enable nil)
  (add-to-list 'lsp-disabled-clients 'bash-ls)
  (add-to-list 'lsp-disabled-clients 'pyright)
  (add-to-list 'lsp-disabled-clients 'mspyls)
  ;; (add-to-list 'lsp-enabled-clients 'pyls)
  ;; (add-to-list 'lsp-disabled-clients 'jedi)
  ;; (add-to-list 'lsp-disabled-clients 'pylsp)
  ;; (add-to-list 'lsp-enabled-clients 'pyls)
  ;; (add-to-list 'lsp-enabled-clients 'hdl-checker)
  ;; (add-to-list 'lsp-enabled-clients 'svlangserver)
  )
(custom-set-variables
'(lsp-jedi-diagnostics-enable t)
'(lsp-jedi-diagnostics-did-open t)
'(lsp-jedi-diagnostics-did-change t)
)
;; (setq lsp-pylsp-plugins-flake8-ignore '("E303"))

;; (setq lsp-pylsp-plugins-flake8-ignore t)
;; (setq lsp-pylsp-plugins-flake8-enabled t)
;; (setq lsp-pylsp-plugins-pycodestyle-enabled t)
;; (setq lsp-pylsp-plugins-pydocstyle-enabled t)
;; (setq lsp-pylsp-plugins-autopep8-enabled t)
;; (setq lsp-pylsp-plugins-yapf-enabled t)
;; (setq lsp-pylsp-plugins-pyflakes-enabled t)
;; (setq lsp-pylsp-plugins-pylint-enabled t)
;; (setq lsp-pylsp-plugins-mccabe-enabled t)

;; (setq lsp-pylsp-plugins-flake8-ignore nil)
;; (setq lsp-pylsp-plugins-flake8-enabled nil)
;; (setq lsp-pylsp-plugins-pycodestyle-enabled nil)
(setq lsp-pylsp-plugins-pydocstyle-enabled nil)
;; (setq lsp-pylsp-plugins-autopep8-enabled nil)
;; (setq lsp-pylsp-plugins-yapf-enabled nil)
;; (setq lsp-pylsp-plugins-pyflakes-enabled nil)
;; (setq lsp-pylsp-plugins-pylint-enabled nil)
(setq lsp-pylsp-plugins-mccabe-enabled nil)

;; (setq lsp-pylsp-plugins-flake8-ignore nil)
;; (setq lsp-pylsp-plugins-flake8-enabled nil)
;; (setq lsp-pylsp-plugins-pycodestyle-enabled nil)
;; (setq lsp-pylsp-plugins-pydocstyle-enabled nil) ;; missing docstring
;; (setq lsp-pylsp-plugins-autopep8-enabled nil)  ;; import unused
;; (setq lsp-pylsp-plugins-yapf-enabled nil)
;; (setq lsp-pylsp-plugins-pyflakes-enabled nil)
;; (setq lsp-pylsp-plugins-pylint-enabled nil)
;; (setq lsp-pylsp-plugins-mccabe-enabled nil)

(setq lsp-pylsp-plugins-flake8-ignore ["F401" "E704" "E225" "E226" "E126" "W503" "E121" "E127" "E501" "E128" "F541" "E129" "E402" "E221" "E303" "W293" "E116" "F841" "E722" "E241" "E203" "E125" "E302" "E305" "E131" "E301" "E117" "E201" "E202"])

;; "F841" assigned but never used
;; "E722" except
;; "E241" multiple spaces
;; "E203" whitespace before ,
;; "E125" inden same as next logical line
;; "E302" expected 2 blank lines
;; "E30" expected 2 blank lines after class
;; "E131" cont line misaligned for hanging indent
;; "E301" expected 1 blank line (above method)
;; E117 comment over-indented

(setq lsp-pyls-plugins-flake8-enabled nil)
(setq lsp-pyls-plugins-pycodestyle-enabled nil)
(setq lsp-pyls-plugins-pydocstyle-enabled nil)
(setq lsp-pyls-plugins-autopep8-enabled nil)
(setq lsp-pyls-plugins-yapf-enabled nil)
(setq lsp-pyls-plugins-pyflakes-enabled nil)
(setq lsp-pyls-plugins-pylint-enabled nil)
(setq lsp-pyls-plugins-mccabe-enabled nil)

;; (setq lsp-pylsp-plugins-pyflakes-enabled nil)
;; (setq lsp-enabled-clients nil)
;; (setq lsp-disabled-clients nil)

(custom-set-variables
 ;; '(lsp-vhdl-server 'svlangserver)
 ;; '(lsp-vhdl-server 'hdl-checker)
 )

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are helm user
(use-package helm-lsp :commands helm-lsp-workspace-symbol)

(with-eval-after-load 'lsp-mode
  ;; (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.my-folder\\'")
  ;; (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\..cookiecutters\\'")
  ;; or
  ;; (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]\\.*outlog*\\'")
  (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]outlog")
  (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]compilation")
  (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]outlog\\'")
  (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]compilation\\'")
  )

;; (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]\\.my-files\\'"))
(key "M-<return>"
     ;; '(t--mini-frame-mode 1)
     '(my-set-marker1)
     '(my-set-marker2)
     '(ci 'lsp-find-references)
					)
(key "M-S-<return>"
     ;; '(t--mini-frame-mode 1)
     '(my-set-marker1)
     '(my-set-marker2)
     '(ci 'lsp-find-definition)
					)
(key "M-C-<return>"
     ;; '(t--mini-frame-mode 1)
     '(ci 'lsp-rename)
					)

(setq lsp-ui-doc-include-signature t)
(custom-set-variables '(lsp-signature-posframe-params
                        '(:poshandler
                          ;; posframe-poshandler-point-bottom-left-corner-upward
                          ;; posframe-poshandler-point-bottom-left-corner
                          posframe-poshandler-window-bottom-right-corner
                          :height 6 :width 60 :border-width 10 :min-width 60))
                      ;; '(lsp-eldoc-render-all nil)
                      '(lsp-signature-doc-lines 0)
                      '(lsp-ui-doc-show-with-mouse t)
                      '(lsp-ui-doc-show-with-cursor nil)
                      '(lsp-ui-doc-position 'at-point)
                      '(lsp-signature-auto-activate nil)
                      '(lsp-eldoc-enable-hover nil)
                      ;; '(lsp-python-ms-guess-env t)
                      )
;; (setenv "WORKON_HOME" "~/miniconda3/bin/")

;; (setq read-process-output-max (* 1024 1024))
;; (setq lsp-log-io nil) ; if set to true can cause a performance hit
;; (lsp-ui-sideline-enable -1)

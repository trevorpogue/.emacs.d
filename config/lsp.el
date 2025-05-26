(add-hook 'python-mode-hook 'turn-on-auto-fill)
(use-package lsp-mode
  :init
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
  )
(custom-set-variables
'(lsp-jedi-diagnostics-enable t)
'(lsp-jedi-diagnostics-did-open t)
'(lsp-jedi-diagnostics-did-change t)
)
(setq lsp-pylsp-plugins-pydocstyle-enabled nil)
(setq lsp-pylsp-plugins-mccabe-enabled nil)

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

(custom-set-variables)

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are helm user
(use-package helm-lsp :commands helm-lsp-workspace-symbol)

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]outlog")
  (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]compilation")
  (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]outlog\\'")
  (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]compilation\\'")
  )

(key "M-<return>"
     '(my-set-marker1)
     '(my-set-marker2)
     '(ci 'lsp-find-references))
(key "M-S-<return>"
     '(my-set-marker1)
     '(my-set-marker2)
     '(ci 'lsp-find-definition))
(key "M-C-<return>"
     '(ci 'lsp-rename))

(setq lsp-ui-doc-include-signature t)
(custom-set-variables '(lsp-signature-posframe-params
                        '(:poshandler
                          posframe-poshandler-window-bottom-right-corner
                          :height 6 :width 60 :border-width 10 :min-width 60))
                      '(lsp-signature-doc-lines 0)
                      '(lsp-ui-doc-show-with-mouse t)
                      '(lsp-ui-doc-show-with-cursor nil)
                      '(lsp-ui-doc-position 'at-point)
                      '(lsp-signature-auto-activate nil)
                      '(lsp-eldoc-enable-hover nil))

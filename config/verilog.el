(require 'verilog-mode)
(setq verilog-indent-level             4
						verilog-indent-level-declaration 4
						verilog-indent-level-behavioral  4
						verilog-indent-level-module      4
						verilog-indent-level-directive   0
						verilog-case-indent              0
						verilog-auto-newline             nil
						verilog-auto-indent-on-newline   t
						verilog-tab-always-indent        t
						verilog-auto-endcomments         t
						verilog-minimum-comment-distance 40
						verilog-indent-begin-after-if    nil
						verilog-auto-lineup              'declarations
						verilog-linter                   "my_lint_shell_command"
						python-indent-offset 4
						)

(add-to-list 'company-keywords-alist (cons 'verilog-mode verilog-keywords))

;; (defun t-verilog-modify-syntax (&rest r)
		;; (interactive)
				;; (modify-syntax-entry ?_ "w")
				;; (modify-syntax-entry ?` "w")
		;; )

;; (add-hook 'after-change-functions #'t-verilog-modify-syntax)

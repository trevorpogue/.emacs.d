(use-package conda
    :ensure t
    :init
    (setq conda-anaconda-home (expand-file-name "~/miniconda3"))
    (setq conda-env-home-directory (expand-file-name "~/miniconda3"))
    :config
    (conda-env-activate "env0")
    (conda-env-initialize-interactive-shells)
    (conda-env-initialize-eshell)
    (add-hook 'conda-postactivate-hook (lambda () (lsp-restart-workspace)))
    (add-hook 'conda-postdeactivate-hook (lambda () (lsp-restart-workspace))))

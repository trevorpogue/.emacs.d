(setq tramp-default-method "ssh")
;; (setq tramp-default-user "")
(setq tramp-default-host "pc-nicolici-6.local")

(setq tramp-default-user "")
(setq tramp-default-host nil)

(add-hook 'helm-tramp-pre-command-hook
          #'(lambda () (global-aggressive-indent-mode 0)
             (projectile-mode 0)
             (editorconfig-mode 0)))
(add-hook 'helm-tramp-quit-hook #'(lambda () (global-aggressive-indent-mode 1)
                                   (projectile-mode 1)
                                   (editorconfig-mode 1)))
(setq remote-file-name-inhibit-cache nil)
(setq vc-ignore-dir-regexp
      (format "\\(%s\\)\\|\\(%s\\)"
              vc-ignore-dir-regexp
              tramp-file-name-regexp))
(setq tramp-verbose 1)

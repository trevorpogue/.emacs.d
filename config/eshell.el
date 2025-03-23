(defun run-prev (&optional t--prev-window buffer-dur)
  (interactive)
  (kill-task)
  (execute-kbd-macro (kbd "<up> <kp-enter>"))
  (when (bound-and-true-p centercursor-mode)
    (sit-for 0.1)
    (centercursor-mode)
    (centercursor-mode)
    )
  (when t--prev-window (select-window t--prev-window t))
  )

(defun eshell-task (&optional pre-task post-task session-num buf-name)
  ;; (interactive)
  (setq t--buffer-directory (buffer-file-name))
  (when t--buffer-directory
    (setq t--buffer-directory (file-name-directory t--buffer-directory)))
  (evil-write-all nil)

  (when current-prefix-arg
    (setq t--shell-prefix-arg current-prefix-arg)
    )
  (setq buf-sess-num "")
  (when (boundp 't--shell-prefix-arg)

    (when (not session-num)
      (setq session-num t--shell-prefix-arg)
      )
    )
  (when session-num
    (setq
     buf-sess-num
     (concat (string ?<) (number-to-string session-num) (string ?>))))

  (when pre-task (funcall pre-task))
  (setq t--prev-window (selected-window))
  (setq t--buffer-name
        (concat "\*eshell\*" buf-sess-num))
  (setq t--bd t--buffer-directory)

  (setq t--window (get-buffer-window t--buffer-name t))

  (when t--window (select-window t--window t))
  ;; (shell t--buffer-name)
  (eshell session-num)
  (unless t--window
    ;; (spacemacs/delete-window)
    (select-window t--prev-window)
    (switch-to-buffer t--buffer-name)
    )
  (when post-task (funcall post-task t--prev-window t--bd)
        )
  ;; (esc)
  (evil-goto-line)
  (end-of-line)
  (centercursor-recenter)
  (when (bound-and-true-p topspace)
    (topspace-recenter-keep-scroll))
  )


(defun move-shell (pre-task post-task session-num)
  (setq t--prev-winn nil)
  (makunbound 't--prev-winn)
  (setq t--prev-winn (selected-window))
  (eshell-task pre-task post-task session-num)
  (previous-buffer)
  (select-window t--prev-winn t)
  (eshell-task nil nil session-num)
  (setq t--prev-winn nil)
  (makunbound 't--prev-winn)
  )

(defun get-prev (t--prev-window t--buffer-directory)
  ;; (interactive)
  (evil-write-all nil)
  ;; (evil-force-normal-state)
  (eshell-kill-process)
  (sit-for 0.02)
  (eshell-kill-input)
  (end-of-buffer)
  (eshell-previous-input 1)
  )

(defun kill-task (&optional t--prev-window t--buffer-directory)
  (interactive)
  ;; least harsh:
  ;; (comint-interrupt-subjob)
  (eshell-kill-process)
  ;; 2nd least harsh:
  ;; (term-quit-subjob)

  ;; (comint-quit-subjob)
  ;; (comint-stop-subjob)
  ;; This one caused issues i think:
  ;; (comint-kill-subjob)
  ;; (execute-kbd-macro (kbd "C-c C-c"))
  )

(defun t--cd (t--prev-window t--buffer-directory)
  (when t--buffer-directory
    (evil-goto-line)
    (end-of-line)
    (execute-kbd-macro (kbd "cd"))
    (execute-kbd-macro (kbd "SPC"))
    (execute-kbd-macro (kbd t--buffer-directory))
    (execute-kbd-macro (kbd "<kp-enter>"))
    ))

(define-key evil-normal-state-map (kbd "s-a") (defun my-shell ()
                                                (interactive)
                                                (eshell)))
(define-key evil-normal-state-map (kbd "s-A") (defun my-new-shell ()
                                                (interactive)
                                                (setq current-prefix-arg '(4))
                                                (call-interactively 'eshell)
                                                ))
(defun helm-shell ()
  ;; (helm-ff-RET)
  (kill-buffer "*eshell*<0>")
  (kmacro "<return>"))


(defun t--after-change (&optional arg0 arg1 arg2)
  (when (string-match "\\*.*shell\\*.*" (buffer-name))
    (when (bound-and-true-p centercursor-mode)
    ;; (spacemacs/toggle-centered-point)
    ;; (spacemacs/toggle-centered-point)
    ;; (previous-line)
    ;; (evil-goto-line)
    (centercursor-recenter)
    ;; (message "hi")
    )
    ))

(add-hook 'after-change-functions 't--after-change)
;; (remove-hook 'after-change-functions 't--after-change)
;; (add-hook 'shell-dynamic-complete-functions 't--after-change)
;; (remove-hook 'shell-dynamic-complete-functions 't--after-change)
;; (add-hook 'eshell-post-command-hook 't--after-change)

;; (key "C-M-s-1" (lambda () (interactive) (eshell-task 'run-prev 1)))
;; (key "C-M-s-2" (lambda () (interactive) (eshell-task nil 'run-prev)))

;; (key "C-M-s-4" 'move-shell)
(key "C-M-s-7" (lambda () (interactive) (move-shell)))
;; (key "C-M-s-8" (lambda () (interactive) (eshell-task nil nil)))
;; (key "C-M-s-9" '(eshell-task nil 't--cd))

;; (key "C-r" '(eshell-task nil 'run-prev))
;; (key "C-r" '(eshell-task nil 'comp-py nil "*compilation*"))
;; (key "C-M-s-[" (lambda () (interactive) (eshell-task nil 'kill-task)))

(key "C-M-#" '(eshell-task nil 'kill-task))
(key "C-M-s-]" 'kill-task)
(key "C-M-s-]" '(kill-task))

(key "M-s-1" '(move-shell nil 't--cd 0))
(key "M-s-1" '(cu 1))
(key "M-s-2" '(cu 2))
;; (key "C-2" '(cu 5))
(key "M-s-3" '(cu 3))
;; (key "C-8" '(cu 4))
(key "M-s-4" '(cu 4))
(key "M-s-5" '(cu 5))
(key "M-s-6" '(cu 6))
(key "M-s-7" '(cu 7))
(key "M-s-8" '(cu 8))
(key "M-s-9" '(cu 9))
(key "C-M-s-0" '(cu 0))
(key "M-s-0"
     '(eshell 0)
     )
(key "C-M-)" '(helm-shell))
(key "C-s-)" '(move-shell nil 't--cd 0))
;; (move-shell nil 't--cd 0)

;; ----------------------------------------------------------------------------
;; L-Palm-normal
;; M
(key "s-M" '(let ((frame-to-enter nil))
              (if (eq (selected-frame) t--parent-frame)
                  (setq frame-to-enter t--posframe)
                (setq frame-to-enter t--parent-frame)
                )
              (select-frame frame-to-enter)
              (x-focus-frame frame-to-enter)))

;; B
;; (key "C-s-b" 'eshell-posframe-enable)
(key "C-s-o"
     '(eshell-task nil 't--cd 0)
     '(esc)
     )
     ;; '(helm-ff-run-switch-to-shell))

;;(eshell-task nil nil 0)

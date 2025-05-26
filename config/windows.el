(require 'magit)
(key "C-s--" '(split-window-below (+ (centercursor-center-line) 4)))
(key "C-M-/" '(split-window-right 245))
(key "C-M-/" '(split-window-right t-window-width))
(key  "C-M-s-z" 'spacemacs/rotate-windows-forward)
(key  "C-M-s-S-z" 'spacemacs/rotate-windows-backward)
(key "C-M-S-a" 'ace-swap-window)
(key "C-M-s-s" 'evil-switch-to-windows-last-buffer)
(key "C-S-w" 'spacemacs/delete-window)
(key "C-M-S-g" '(t-set-window-width))
(key "C-M-^" '(t-set-window-width))

(defun t-set-window-width-n (&optional n)
  (interactive "P")
  (adjust-window-trailing-edge
   (selected-window)
   (- (- n (window-width)) 2) t))

(defun t--get-window-width ()
  (interactive) (print (window-width)))

(defun t-set-window-width (&optional n)
  (interactive "P")
  (setq n (or n t-window-width))
  (let ((pw (window-width)) (lw))
    (condition-case nil
        (adjust-window-trailing-edge
         (selected-window) (- (- n (window-width)) 3) t)
      (:success)
      (error
       (windmove-left)
       (setq lw (window-width))
       (t-set-window-width-n (+ 4 lw (- pw n)))
       (windmove-right)
       ))
    ))

(key "C-M-?"
     '(progn
        (enlarge-window-horizontally t-win-adjust-resolution)
        (windmove-right)
        (enlarge-window-horizontally (+(* t-win-adjust-resolution -1)1))
        (windmove-left)))

(key "C-s-_" '(progn
                (enlarge-window-horizontally (* t-win-adjust-resolution -1))
                (windmove-right)
                (enlarge-window-horizontally (- t-win-adjust-resolution 1))
                (windmove-left)))

(key "C-M-&" 'windmove-up)
(key "C-M-*" 'windmove-down)

(key "C-<prior>" 'windmove-up)
(key "C-<next>" 'windmove-down)

(key "C-<mouse-4>" 'windmove-up)
(key "C-<mouse-5>" 'windmove-down)

(key "C-=" 'windmove-up)
(key "C--" 'windmove-down)

(key "C-S-<iso-lefttab>" 'windmove-up)
(key "C-<tab>" 'windmove-down)

(key "C-<tab>"
     '(windmove-right)
     '(when flycheck-mode
        (t-flycheck-enable-messages) (t-flycheck-disable-messages)))

(key  "C-S-<iso-lefttab>"
     '(windmove-left)
     '(when flycheck-mode
        (t-flycheck-enable-messages) (t-flycheck-disable-messages)))

(key "C-<next>"
     '(aw-copy-window (winum-get-window-by-number (1+ (winum-get-number))))
     '(windmove-left)
     '(ci 'windmove-right))

(key "C-<prior>"
     '(aw-copy-window (winum-get-window-by-number (1- (winum-get-number))))
     '(windmove-right)
     '(ci 'windmove-left))

(define-key magit-mode-map (kbd "C-<tab>") 'windmove-right)

(require 'ace-window)

(setq t-win-adjust-resolution 3)
(defun t-win-adjust-resolution2 ()
  (- winum--window-count -1 (winum-get-number)))

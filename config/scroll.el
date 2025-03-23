(setq-local topspace-auto t)


;; (defun t-scroll) TODO: make fn to incrementally scroll then prev line for n times
;; (defun t-scroll) TODO: make fn to incrementally scroll then prev line for n times

(defun my-page (move-cursor ratio)
  (interactive)
  ;; (if (eq 'ratio nil) (setq-local ratio 1))
  (when (bound-and-true-p centercursor-mode)
    (setq move-cursor t))
  (let (
        ;; (lines (count-screen-lines (window-start) (window-end)))
        (lines (window-height))
        (pos (count-screen-lines (window-start) (point)))
        ;; (pos (evil-ex-current-line))
        )
    (setq lines (round (/ lines 4)))
    (setq lines (* ratio lines))
    (when move-cursor
      ;; (evil-scroll-line-down lines)
      ;; (previous-line lines t)
      ;; (next-line lines t)
      ;; (setq lines (* lines -1))
      ;; ()
      )
    (setq pos (+ pos (topspace-height)))
    (scroll-up lines)
    (when move-cursor
      (goto-char (window-start))
      (setq pos (- pos (topspace-height)))
      (evil-next-visual-line (round pos))
      )
    ))

(defun t-shuffle-center-pos ()
  (let ((positions '(0.36 0.39 0.42)) total-positions)
    (setq total-positions (length positions))
    (when (not (boundp 't-pos-i)) (setq t-pos-i 0))
    (setq t-pos-i (1+ t-pos-i))
    (when (>= t-pos-i total-positions) (setq t-pos-i 0))
    (setq centercursor-center-position (nth t-pos-i positions))
    (setq t-helm-height (round
                         (- (topspace--frame-height)
                            (topspace--center-line
                             centercursor-center-position)
                            1)))
    (custom-set-variables
     '(helm-posframe-height t-helm-height)
     '(helm-posframe-min-height t-helm-height))
    ))

(defun t-inc-center-pos (inc)
  (setq centercursor-center-position (+ inc centercursor-center-position))
  (setq topspace-center-position centercursor-center-position)
  (setq t-helm-height (round
                       (- (topspace--frame-height)
                          (topspace--center-line
                           centercursor-center-position)
                          1)))
  (custom-set-variables
   '(helm-posframe-height t-helm-height)
   '(helm-posframe-min-height t-helm-height)))


;; (key "C-M-S-z" '(t-inc-center-pos (* -1 t-center-pos-inc)))
;; (key "C-M-z" '(t-inc-center-pos t-center-pos-inc))
;; (key "C-l" '(t-shuffle-center-pos))
(key "C-l" '(print (topspace-height)))
(key "C-l" '(ci 'profiler-stop) '(profiler-report))
(key "C-M-S-x" '(centercursor-recenter))
;; (key "C-l" '(print (line-number-at-pos (window-end))))
;; (key "C-l" '(print (cdr (window-absolute-pixel-position (point)))))
;; (key "C-l" '(print (topspace--total-lines-past-max)))
;; (key "C-l" '(print (window-screen-lines)))
;; (key "C-l" 'magit-dispatch)
;; (key "C-l" 'which-key-show-major-mode)
;; (key "C-l" 'helm-ls-git-server-edit)

(key "C-l"
     ;; '(print (count-screen-lines (- (point) 3) (+ (point) 1)))
     '(ci 'centercursor-mode)
     ;; '(ci 'recenter-top-bottom)
     ;; '(print
     ;; (posn-at-point)
     ;; (nth 0 (nth 6 (posn-at-point)))
     ;; )
     )

;; (display-monitor-attributes-list) ;; (display-monitor-attributes-list) ;; (display-monitor-attributes-list) ;; (display-monitor-attributes-list) ;; (display-monitor-attributes-list) ;; (display-monitor-attributes-list)
(setq t--frame (selected-frame))

;; ----------------------------------------------------------------------------
;; Scroll quarter
;; arrow mid
;; M
(defun small-pgup (&optional a b c)
  (interactive)
  (if (bound-and-true-p t-scroll-mode)
      ;; (topspace-scroll-down-line)
      (backward-paragraph)
    (my-page t 1)
    ;; (my-page nil -1)
    ))

;; B
(defun small-pgdn ()
  (interactive)
  (if (bound-and-true-p t-scroll-mode)
      ;; (topspace-scroll-down-line)
      (forward-paragraph)
    (my-page t -1)
    ;; (my-page nil 1)
    ))

;; M
(key "<prior>"
     '(if (bound-and-true-p t-scroll-mode)
          ;; (my-page t 1)
          (scroll-down-line)
        (backward-paragraph)
        ))

;; (let ((scroll-up #'scroll-down))
;;   (setq t--prev-scroll-up t--scroll-up)
;;   (setq t--scroll-up 'scroll-down-line)
;;   (t--scroll-up)
;;   (setq t--scroll-up t--prev-scroll-up)
;; )

(defun t--scroll-up () (scroll-up 1))

;; B
(key "<next>"
     '(if (bound-and-true-p t-scroll-mode)
          ;; (my-page t -1)
          (scroll-up-line)
        (forward-paragraph)
        ))

(key "C-M-s-S-<prior>" 'View-scroll-half-page-backward)
(key "C-M-s-S-<next>" 'View-scroll-half-page-forward)
;; (key "C-M-s-S-<prior>" 'scroll-down)
;; (key "C-M-s-S-<next>" 'scroll-up)
;; (key "C-M-s-S-<prior>" 'scroll-down-command)
;; (key "C-M-s-S-<next>" 'scroll-up-command)
;; (key "C-M-s-S-<prior>" 'evil-scroll-up)
;; (key "C-M-s-S-<next>" 'evil-scroll-down)

;; ----------------------------------------------------------------------------
;; arrow
;; G
(global-set-key (kbd "C-M-s-_") 'spacemacs/toggle-centered-point-globally)
;;

;; (define-key helm-find-files-map (kbd "C-M-s-S-<prior>") 'small-pgdn)
;; (define-key helm-find-files-map (kbd "C-M-s-S-<next>")
;; (lambda () (interactive)
;; (next-line)
;; ))
;; ----------------------------------------------------------------------------
;; Scrolling single line
;; L-Palm-normal
;; M
;; (key "C-s-j" 'scroll-down-line)
(setq t-scroll-amount 1)
(setq t-scroll-amount-lp 2)
(setq t-scroll-amount-rp 4)
(setq t-scroll-move-cursor nil)
(key "<prior>" '(my-page t-scroll-move-cursor (* t-scroll-amount -1)))
(key "<next>" '(my-page t-scroll-move-cursor t-scroll-amount))
(key "S-<prior>" '(my-page t-scroll-move-cursor (* t-scroll-amount-rp -1)))
(key "S-<next>" '(my-page t-scroll-move-cursor t-scroll-amount-rp))
(key "C-<prior>" '(my-page t-scroll-move-cursor (* t-scroll-amount-lp -1)))
(key "C-<next>" '(my-page t-scroll-move-cursor t-scroll-amount-lp))

(key "C-M-u" '(my-page t-scroll-move-cursor -4))
(key "C-M-i" '(my-page t-scroll-move-cursor 4))
;; (key "C-s-S-p" ')
;; (key "C-M-s-S-p" ')
;; (key "M-C-<return>"
;;      '(my-page t 1)
;;      )
;; (key "M-S-<return>"
;;      '(my-page t -1)
;;      )
;; B

(defun t-setcenter-pos-inc ()
  (setq t-center-pos-inc (/ 1.0 (topspace--frame-height))))

(t-setcenter-pos-inc)

(key "C-M-k"
     ;; '(centercursor-mode 0)
     '(cond (centercursor-mode
             (t-setcenter-pos-inc)
             (t-inc-center-pos (* -1 t-center-pos-inc)))
            ((ci 'scroll-up-line))))

(key "C-M-j"
     ;; '(centercursor-mode 0)
     '(cond (centercursor-mode
             (t-setcenter-pos-inc)
             (t-inc-center-pos t-center-pos-inc))
            ((ci 'scroll-down-line)))
     )

;; ----------------------------------------------------------------------------
;; Scroll half page
;; L-palm-normal
;; u
;; (key "C-s-u" '(my-page -1 t 2))
;; (key "C-s-i" '(my-page 1 t 2))


;; ----------------------------------------------------------------------------
;; shift-arrow
;; M
(setq mouse-wheel-tilt-scroll t)

;; (defun t-mwheel-scroll-up-function (&rest args)
;; (let ((buffer
;; (with-current-buffer (window-buffer ))
;; ))
;; (let ((func (if centercursor-mode #'scroll-up #'next-line)))
;; (apply func args))))

;; (defun t-mwheel-scroll-down-function (&rest args)
;; (let ((func (if centercursor-mode #'scroll-down #'previous-line)))
;; (apply func args)))

;; (setq mwheel-scroll-up-function #'t-mwheel-scroll-up-function)
;; j(setq mwheel-scroll-down-function #'t-mwheel-scroll-down-function)

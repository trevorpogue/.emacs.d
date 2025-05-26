(setq-local topspace-auto t)


(defun my-page (move-cursor ratio)
  (interactive)
  (when (bound-and-true-p centercursor-mode)
    (setq move-cursor t))
  (let (
        (lines (window-height))
        (pos (count-screen-lines (window-start) (point)))
        )
    (setq lines (round (/ lines 4)))
    (setq lines (* ratio lines))
    (when move-cursor
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


(key "C-M-S-x" '(centercursor-recenter))

(key "M-S-<next>" '(ci 'centercursor-mode))

(setq t--frame (selected-frame))

;; ----------------------------------------------------------------------------
;; Scroll quarter
;; arrow mid
;; M
(defun small-pgup (&optional a b c)
  (interactive)
  (if (bound-and-true-p t-scroll-mode)
      (backward-paragraph)
    (my-page t 1)
    ))

;; B
(defun small-pgdn ()
  (interactive)
  (if (bound-and-true-p t-scroll-mode)
      (forward-paragraph)
    (my-page t -1)
    ))

;; M
(key "<prior>"
     '(if (bound-and-true-p t-scroll-mode)
          (scroll-down-line)
        (backward-paragraph)
        ))

(defun t--scroll-up () (scroll-up 1))

;; B
(key "<next>"
     '(if (bound-and-true-p t-scroll-mode)
          (scroll-up-line)
        (forward-paragraph)
        ))

(key "C-M-s-S-<prior>" 'View-scroll-half-page-backward)
(key "C-M-s-S-<next>" 'View-scroll-half-page-forward)

;; ----------------------------------------------------------------------------
;; arrow
;; G
(global-set-key (kbd "C-M-s-_") 'spacemacs/toggle-centered-point-globally)
;;

;; ----------------------------------------------------------------------------
;; Scrolling single line
;; L-Palm-normal
;; M
(setq t-scroll-amount 1)
(setq t-scroll-amount-lp 2)
(setq t-scroll-amount-rp 4)
(setq t-scroll-move-cursor nil)
(key "<prior>" '(my-page t-scroll-move-cursor (* t-scroll-amount -1)))
(key "<next>" '(my-page t-scroll-move-cursor t-scroll-amount))
(key "M-<prior>" '(my-page t-scroll-move-cursor (* t-scroll-amount-rp -1)))
(key "M-<next>" '(my-page t-scroll-move-cursor t-scroll-amount-rp))

(key "C-M-u" '(my-page t-scroll-move-cursor -4))
(key "C-M-i" '(my-page t-scroll-move-cursor 4))

(defun t-setcenter-pos-inc ()
  (setq t-center-pos-inc (/ 1.0 (topspace--frame-height))))

(t-setcenter-pos-inc)

(defun t-down (&optional &rest args)
  (interactive)
  (cond (centercursor-mode
         (t-setcenter-pos-inc)
         (t-inc-center-pos (* -1 t-center-pos-inc)))
        ((ci 'scroll-up-line))))

(defun t-up (&optional &rest args)
  (interactive)
  (cond (centercursor-mode
         (t-setcenter-pos-inc)
         (t-inc-center-pos t-center-pos-inc))
        ((ci 'scroll-down-line))))

(key "M-<up>" 't-up)
(key "M-<down>" 't-down)

;; ----------------------------------------------------------------------------
;; shift-arrow
;; M
(setq mouse-wheel-tilt-scroll t)

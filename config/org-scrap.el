(defun t--org-mode-hooks (&optional arg1)
  (org-indent-mode)
  (toggle-truncate-lines -1)
  (adaptive-wrap-prefix-mode 1)
  (visual-line-mode 1)
  ;; (lambda () (setq captain-predicate (lambda () (not (org-in-src-block-p)))))
  ;; (setq captain-predicate (lambda () t))
  ;; (captain-mode 1)
  (company-mode -1)
  )

;; (setq org-level-faces
;;       '(org-level-1
;;         org-level-2
;;         org-level-3
;;         org-level-4
;;        org-level-5
;;         org-level-6
;;         org-level-7
;;         org-level-8
;;         ))

;; (add-hook
;;  'org-mode-hook
;;  (lambda ()
;;    (setq captain-predicate
;;          (lambda () (not (org-in-src-block-p))))))

;; (add-hook 'org-mode-hook (lambda () (setq captain-predicate
;; (lambda () (not (org-in-src-block-p))))))

;; (setq captain-predicate #'captain--default-predicate)
;; (defun captain--default-predicate ()
;; "The default predicate for determining whether the captain should work.
;; He does nothing by default."
;; t)

(setq org-adapt-indentation nil
      org-hide-leading-stars t
      org-odd-levels-only nil)

(defun t--update-adaptive-wrap-extra-indent ()
  (setq adaptive-wrap-extra-indent
        (if (eq (org-current-level) nil) 0
          (* (org-current-level) org-indent-indentation-per-level))))

(setq org-hide-emphasis-markers t)
(setq org-indent-indentation-per-level 2)


(add-hook 'org-mode-hook 't--org-mode-hooks 100)

(defun t--toggle-bullet ()
  (setq t--bullet (if (string= t--bullet "+") "-" "+"))
  (org-cycle-list-bullet t--bullet)
  )
;; )

(defun t--reset-org ()
  (org-indent-mode t)
  )

;; (key "C-s-0" '(print (org-current-level)))
;; (key "C-s-0" '(print adaptive-wrap-extra-indent))
;; (key "M-9" '(print adaptive-wrap-extra-indent))
(key "C-s-0" '(print (if (eq (org-current-level) nil)
                         0
                       (* (org-current-level) org-indent-indentation-per-level)
                       )))
(key "C-s-1" '(progn  (let ((current-prefix-arg '(4)))
                        (ci 'org-toggle-checkbox)
                        (next-logical-line))))
(key "C-s-7" '(progn  (let ((current-prefix-arg '(4))) (ci 'org-toggle-checkbox))))
(key "C-s-x" 'org-toggle-checkbox)
;; (key "C-s-8" 'org-outdent-item-tree)
;; (key "C-s-9" 'org-indent-item-tree)
(key "C-s-8" 'org-promote-subtree)
(key "C-s-9" 'org-demote-subtree)
(key "C-s-0" '(t--toggle-bullet))

;; (key "C-s-7" '(progn  (let ((current-prefix-arg '(1))) (ci 'org-toggle-heading))))
;; (key "C-s-7" '(if (org-at-heading-p) (ci 'org-toggle-item) (let ((current-prefix-arg '(1))) (ci 'org-toggle-heading))))

;; Toggle parent header/item
(key "C-s-0" '(progn (if (org-at-heading-p) (ci 'org-toggle-item)
                       (progn (ci 'org-toggle-heading)
                              (ci 'org-promote-subtree)
                              (ci 'org-promote-subtree)
                              )) (ci 'next-logical-line)))

;; Toggle sibling header/item
(key "C-s-4" '(progn (if (org-at-heading-p) (ci 'org-toggle-item)
                       (progn (ci 'org-toggle-heading)
                              (ci 'org-promote-subtree)
                              )) (ci 'next-logical-line)))

;; Toggle child header/item
(key "C-s-1" '(progn (if (org-at-heading-p) (ci 'org-toggle-item)
                       (progn (ci 'org-toggle-heading)
                              ;; (ci 'org-promote-subtree)
                              )) (ci 'next-logical-line)))

(key "C-s-q" '(progn (beginning-of-line)
                     (dotimes (i 10) (t-org-prev-parent-heading))
                     (outline-hide-other)))
;; (key "C-s-2" '(progn (beginning-of-line) (outline-hide-subtree) (org-show-children)))
(key "C-s-0"
     '(progn (beginning-of-line)
             (outline-hide-subtree)
             (if current-prefix-arg
                 (outline-show-children current-prefix-arg)
               (outline-show-children 1))))
(key "C-s-1"
     '(progn (beginning-of-line)
             (outline-hide-subtree)
             (if current-prefix-arg
                 (outline-show-children current-prefix-arg)
               (outline-show-children 2))))

(defun t-org-deepest-subtree-level ()
  (let ((initial-level (org-current-level))
        (deepest-level (org-current-level)))
    (save-excursion
      (while (and
              (>= (org-current-level) initial-level)
              (outline-next-heading))
        (setq deepest-level (max deepest-level (org-current-level)))))
    deepest-level))

(defun t--org-show-n-leaves (n)
  (if (>= n 0)
      (outline-show-children (- (t-org-deepest-subtree-level)
                                (org-current-level) n))
    (outline-show-subtree)
    ))

(defun t-org-show-n-leaves (n)
  (beginning-of-line)
  (outline-hide-subtree)
  (if current-prefix-arg
      (t--org-show-n-leaves current-prefix-arg)
    (t--org-show-n-leaves n)))

(defun t-org-show-n-children (n)
  (beginning-of-line)
  (outline-hide-subtree)
  (if current-prefix-arg
      (outline-show-children current-prefix-arg)
    (outline-show-children n)))


(defun t-org-show-n-children-from-root (n)
  (beginning-of-line)
  (save-excursion
    (dotimes (i 10) (t-org-prev-parent-heading))
    (t-org-show-n-children 3)
    (if current-prefix-arg
        (outline-show-children current-prefix-arg)
      (outline-show-children n))))

(defun t-org-show-n-children-from-root-only-here (n)
  (beginning-of-line)
  (while (< (- n (- (org-current-level) 1)) 0)
    (t-org-prev-parent-heading))
  (outline-hide-subtree)
  (outline-show-children (- n (- (org-current-level) 1)) ))


(defun t-org-show-n-leaves-from-root (n)
  (beginning-of-line)
  (save-excursion
    (dotimes (i 10) (t-org-prev-parent-heading))
    (t-org-show-n-children 3)
    (t-org-show-n-leaves n)))

(defun t-org-show-n-leaves-from-root-only-here (n)
  (beginning-of-line)
  (let ((deepest-level (save-excursion
                         (t-org-prev-parent-heading)
                         (t-org-deepest-subtree-level))))
    (while (> (org-current-level) (- deepest-level n))
      ;; (print (org-current-level))
      ;; (print (- deepest-level n))
      (t-org-prev-parent-heading)))
  (t-org-show-n-leaves n))


;; (key "C-s-1" '(t-org-show-n-leaves 2))
;; (key "C-s-1" '(t-org-show-n-children 3))
(key "C-s-1" '(t-org-show-n-children-from-root 3))
(key "C-s-2" '(t-org-show-n-children-from-root-only-here 3))
(key "C-s-1" '(t-org-show-n-leaves-from-root 2))
(key "C-s-2" '(t-org-show-n-leaves-from-root 1))
(key "C-s-3" '(t-org-show-n-leaves-from-root 0))
(key "C-s-g" '(t-org-show-n-leaves-from-root -1))
;; (key "C-s-2" '(t-org-show-n-leaves-from-root-only-here 1))

;; (key "C-s-3" '(progn (beginning-of-line) (outline-show-subtree) (outline-hide-leaves)))
(key "C-s-w" '(progn (beginning-of-line) (outline-show-all)))
(key "C-s-5" '(progn (beginning-of-line) (outline-hide-subtree)))
(key "C-s-6" '(progn (beginning-of-line) (outline-show-subtree)))

(key  "C-M-s-<left>" '(if (org-at-heading-p) (ci 'org-do-promote) (ci 'org-outdent-item-tree)))
(key  "C-M-s-<right>" '(if (org-at-heading-p) (ci 'org-do-demote) (ci 'org-indent-item-tree)))
(setq t--bullet "-")
(setq t--bullet-macro "SPC * SPC")
(setq t--bullet-macro "- SPC")

(key "M-9" '(progn (ci 'evil-write-all) (revert-buffer nil t)))
(key "M-9" 'org-mode-restart)
(key "M-7" 'org-meta-return)
(key "M-8" '(progn (end-of-line)
                   (if (org-at-heading-p)
                       (progn (newline-and-indent) (kmacro t--bullet-macro))
                     (ci 'org-meta-return))))
(key "M-8" 'org-meta-return)

;; (key "M-9" '(if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
;;           (progn (end-of-line)
;;                  (ci 'org-insert-subheading))
;;         (ci 'newline-and-indent)))


;; adaptively insert child or sibling heading
(key "M-6"
     '(if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
          (progn (end-of-line)
                 (if (org-at-heading-p)
                     (ci 'org-insert-subheading)
                   (ci 'org-insert-heading)))
        (ci 'newline-and-indent)))

(defun t--org-insert-parent-header (&optional arg)
  (interactive "P")
  (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
      (progn (end-of-line) (end-of-visual-line)
             (ci 'org-insert-heading)
             (ci 'org-do-promote))
    (ci 'newline-and-indent)))

(defun t--org-insert-sibling-header (&optional arg)
  (interactive "P")
  (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
      (progn (end-of-line) (end-of-visual-line)
             (ci 'org-insert-heading))
    (ci 'newline-and-indent)))

(defun t--org-insert-child-header (&optional arg)
  (interactive "P")
  (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
      (progn (end-of-line) (end-of-visual-line)
             (ci 'org-insert-subheading))
    (ci 'newline-and-indent)))

(key "M-7" 't--org-insert-parent-header)
(key "M-8" 't--org-insert-sibling-header)
(key "M-9" 't--org-insert-child-header)
(key "M-6" 'end-of-line)
(key "M-3" 't--org-insert-child-header)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; RET ;;

;; Force insert list item at point on next line
(key "C-<enter>" ;; Up R Ring
     '(if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
          (ci 'newline-and-indent)
        (ci 'newline-and-indent)))


(key "RET" ;; Center R Ring
     '(if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
          (progn
            (if (org-at-heading-p)
                (progn (newline-and-indent)
                       (kmacro t--bullet-macro))
              (ci 'org-meta-return)))
        (ci 'newline-and-indent)))

;; end line insert item
(key "M-<enter>" ;; Down R Ring
     '(if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
          (progn (end-of-line)
                 (if (org-at-heading-p)
                     (progn (newline-and-indent) (kmacro t--bullet-macro))
                   (ci 'org-meta-return)))
        (ci 'newline-and-indent)))

;;; It is the opposite of fill-paragraph
(defun t--unfill-paragraph (&optional)
  (interactive)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (defun t--fill-buffer (&optional arg)
;;   (interactive)
;;   (save-excursion
;;     (save-restriction
;;       (widen)
;;       (fill-region (point-min) (point-max)))))

(defun t--org-fill-buffer (&optional arg)
  (interactive)
  (save-excursion
    (org-with-wide-buffer
     (cl-loop for el in (reverse
                         (org-element-map (org-element-parse-buffer)
                             '(paragraph quote-block item) #'identity))
              do
              (goto-char (org-element-property :contents-begin el))
              (org-fill-paragraph)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; NAVIGATION ;;;;

;; navigate to previous sibling heading
(key "M-<up>"
     '(if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
          (progn
            (if (org-at-heading-p)
                (org-backward-heading-same-level 1)
              (outline-previous-heading)))
        (backward-paragraph)))

;; navigate to next sibling heading
(key "M-<down>"
     '(if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
          (if (org-at-heading-p)
              (org-forward-heading-same-level 1)
            (outline-next-heading))
        (forward-paragraph)
        ))


(defun t-org-prev-parent-heading ()
  ;; navigate to previous parent heading
  (ignore-errors
    (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
        (if (org-at-heading-p)
            (outline-up-heading 1)
          (outline-previous-heading))
      (backward-paragraph))))


(defun t-org-prev-parent-heading2 ()
  ;; navigate to previous parent heading
  (ignore-errors
    (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
        (if (org-at-heading-p)
            (progn (if (= (org-current-level) 1)
                       (org-backward-heading-same-level 1)
                     (outline-up-heading 1)))
          (outline-previous-heading))
      (backward-paragraph))))

(defun t-org-prev-root-heading ()
  (if (and (org-at-heading-p) (= (org-current-level) 1))
      (previous-line))
  (dotimes (i 10) (t-org-prev-parent-heading)))

(key "C-s-e" '(t-org-prev-root-heading))
(key "C-s-z" '(t-org-prev-root-heading))
(key "C-s-y" '(t-org-prev-root-heading))
(key "C-s-j" '(t-org-prev-root-heading))
(key "M-7" '(t-org-prev-root-heading))

(key "M-4" '(t-org-prev-parent-heading2))
(key "M-0" '(org-forward-heading-same-level 1))


(defun t-org-next-parent-heading ()
  ;; navigate to next parent heading
  (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
      (ignore-errors
        (t-org-prev-parent-heading)
        (let ((prev-point (point)))
          (org-forward-heading-same-level 1)
          (while (= prev-point (point))
            (t-org-prev-parent-heading)
            (setq prev-point (point))
            (org-forward-heading-same-level 1))
          ))
    (forward-paragraph)))

(key "M-5" '(t-org-next-parent-heading))

;; navigate to previous child heading
(key "M-1" '(progn (previous-line)
                   (if (org-at-heading-p)
                       nil
                     (outline-previous-heading))))

;; navigate to next child heading
(key "M-2" '(progn (next-line)
                   (if (org-at-heading-p)
                       nil
                     (outline-next-heading))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Fill ;;;;

(defun t--org-fill-buffer (&optional arg)
  (interactive)
  (save-excursion
    (org-with-wide-buffer
     (cl-loop for el in (reverse
                         (org-element-map (org-element-parse-buffer)
                             '(paragraph quote-block item) #'identity))
              do
              (goto-char (org-element-property :contents-begin el))
              (org-fill-paragraph)))))

(defun t--unfill-paragraph (&optional)
  "It is the opposite of fill-paragraph"
  (interactive)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))


(defun torg-go-n-headings-up (&optional n)
  "Go up to previous parent heading that is `n' levels higher than current level."
  (ignore-errors
    (when (and (not (org-at-heading-p)) (org-current-level))
      (outline-previous-visible-heading 1)
      (setq n (- n 1)))
    (let ((orig-level (org-current-level)))
      (cond
       ((> (- orig-level n) 0)
        (outline-up-heading n))
       (t
        (when (> orig-level 1) (outline-up-heading (- orig-level 1)))
        (setq n (- n (- orig-level (org-current-level))))
        (outline-backward-same-level n))))))

(defun torg-previous-parent-heading (&optional n)
  "Navigate to previous parent heading if `n`' is nil.
Otherwise, go to previous parent heading at level `n'"
  (setq n (if n (n (- (org-current-level) n)) 1))
  (torg-go-n-headings-up n))

(defun torg-next-parent-heading (&optional n)
  "Navigate to next parent heading if `n`' is nil.
Otherwise, go to next parent heading at level `n'"
  (let ((orig-level (org-current-level)))
    (torg-previous-parent-heading n)
    (torg-next-sibling-heading (if (= orig-level 1) 2 1))))

(defun torg-next-parent-heading (&optional n)
  "Navigate to the `n'th next parent heading"
  (setq n (or n 1))
  (cond
   ((= 1 (org-current-level))
    (outline-forward-same-level n))
   (t
    (dotimes (i (or n 1))
      (let ((orig-line (line-number-at-pos))
            (orig-level (org-current-level))
            (final-level) (final-point ))
        (if (not (org-at-heading-p))
            (outline-next-visible-heading 1)
          (save-excursion
            (while (and
                    (not (= (line-number-at-pos) (line-number-at-pos (point-max))))
                    (or (= orig-line (line-number-at-pos))
                        (>= (org-current-level) orig-level)))
              (ignore-errors (outline-next-visible-heading 1))
              (setq final-level (org-current-level))
              (setq final-point (point))))
          (if (< final-level orig-level)
              (goto-char final-point))))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; HIDE/SHOW Subtrees ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; RING MIDDLE - LEFT Keys hand ;;;;;;;;;;;;;;;;;;;;

;; SHOW LEAVES ;;

(key "C-s-w"   '(torg-show-n-leaves 1 0))
(key "C-s-e"   '(torg-show-n-leaves 0 0))
(key "C-s-r" '(progn (outline-show-all)))

(key "C-s-S-s" '(torg-show-n-leaves 1))
(key "C-s-S-d" '(torg-show-n-leaves 0))
(key "C-s-S-f" '(torg-show-n-leaves -1))

(key "C-s-S-a" '(torg-show-n-leaves-from-root 1))
(key "C-s-S-c" '(torg-show-n-leaves-from-root 0))
(key "C-s-S-v" '(torg-show-n-leaves-from-root -1))

(key "C-s-SPC" '(torg-show-n-leaves nil))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; RING INDEX - LEFT Keys hand ;;;;;;;;;;;;;;;;;;;;

;; SHOW CHILDREN ;;

(setq torg-child-start 0)
(key "M-s-W"   '(torg-show-n-children-all (+ torg-child-start 0)))
(key "M-s-e"   '(torg-show-n-children-all (+ torg-child-start 1)))
(key "M-s-r"   '(torg-show-n-children-all (+ torg-child-start 2)))

(key "M-s-SPC" '(torg-show-n-children-cur-level 0))

(key  "M-s-s"  '(torg-show-n-children-cur-level (+ torg-child-start 0)))
(key  "M-s-d"  '(torg-show-n-children-cur-level (+ torg-child-start 1)))
(key  "M-s-f"  '(torg-show-n-children-cur-level (+ torg-child-start 2)))

(key "M-s-a"   '(torg-show-n-children-from-root (+ torg-child-start 0)))
(key "M-s-c"   '(torg-show-n-children-from-root (+ torg-child-start 1)))
(key "M-s-v"   '(torg-show-n-children-from-root (+ torg-child-start 2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Setup ;;;;

(setq t--org-root-level 3)
(setq t-org-root-level t--org-root-level)

(setq org-level-faces
      '(
        org-level-8
        org-level-1
        org-level-2

        org-level-4
        org-level-5
        org-level-3

        org-level-6
        org-level-7
        ))

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

(defun t--org-mode-hooks (&optional arg1)
  (org-indent-mode)
  (toggle-truncate-lines -1)
  (adaptive-wrap-prefix-mode 1)
  (visual-line-mode 1)
  (company-mode -1)
  (flyspell-mode-off)
  )

(setq org-adapt-indentation nil
      org-hide-leading-stars t
      org-odd-levels-only nil)

(setq org-hide-emphasis-markers t)
(setq org-indent-indentation-per-level 2)
;; (setq org-cycle-hook '(org-cycle-hide-archived-subtrees
;;        org-cycle-hide-drawers
;;        org-cycle-show-empty-lines
;;        org-optimize-window-after-visibility-change))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Promotion ;;;;

(defun t-org-promote-subtree ()
  (if (org-at-heading-p)
      (ci 'org-do-promote) (ci 'org-outdent-item-tree)))

(defun t-org-demote-subtree ()
  (if (org-at-heading-p)
      (ci 'org-do-demote) (ci 'org-indent-item-tree)))


(key  "C-M-s-<" '(t-org-promote-subtree))
(key  "C-M-s->" '(t-org-demote-subtree))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Bullet toggling ;;;;

(setq t--bullet "-")
(setq t--bullet-macro "SPC * SPC")
(setq t--bullet-macro "- SPC")

(defun t--toggle-bullet ()
  (setq t--bullet (if (string= t--bullet "+") "-" "+"))
  (org-cycle-list-bullet t--bullet))

(key "C-M-8" 'org-promote-subtree)
(key "C-M-9" 'org-demote-subtree)


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Checkbox toggling ;;;;

(key "C-M-7" '(progn  (let ((current-prefix-arg '(4))) (ci 'org-toggle-checkbox))))
(key "C-s-x" 'org-toggle-checkbox)


;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Header toggling ;;;;

(defun t-toggle-parent-header-and-item ()
  "Toggle parent header/item"
  (if (org-at-heading-p) (ci 'org-toggle-item)
    (progn (ci 'org-toggle-heading)
           (ci 'org-promote-subtree)
           (ci 'org-promote-subtree)
           )) (ci 'next-logical-line))

(defun t-toggle-sibling-header-and-item ()
  "Toggle sibling header/item"
  (if (org-at-heading-p) (ci 'org-toggle-item)
    (progn (ci 'org-toggle-heading)
           (ci 'org-promote-subtree)
           )) (ci 'next-logical-line))


(defun t-toggle-child-header-and-item ()
  "Toggle child header/item"
  (if (org-at-heading-p) (ci 'org-toggle-item)
    (progn (ci 'org-toggle-heading)
           ;; (ci 'org-promote-subtree)
           )) (ci 'next-logical-line))

(key "C-M-7" '(t-toggle-sibling-header-and-item))
(key "C-M-4" '(t-toggle-sibling-header-and-item))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Header Insertion ;;;;

(defun t-org-adaptive-child-sibling-heading-insert ()
  "adaptively insert child or sibling heading"
  (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
      (progn (end-of-line)
             (if (org-at-heading-p)
                 (ci 'org-insert-subheading)
               (ci 'org-insert-heading)))
    (ci 'newline-and-indent)))

(defun t--org-insert-parent-heading (&optional arg)
  (interactive "P")
  (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
      (progn (end-of-line) (end-of-visual-line)
             (ci 'org-insert-heading)
             (ci 'org-do-promote))
    (ci 'newline-and-indent)))

(defun t--org-insert-sibling-heading-above (&optional arg)
  (interactive "P")
  (beginning-of-line)
  (org-insert-heading)
  ;; (when (= (org-current-level) 1)
  ;;   (next-logical-line)
  ;;   (ci 'evil-delete-whole-line)
  ;;   (previous-logical-line)
  ;;   (end-of-line))
  )

(defun t--org-insert-sibling-heading (&optional arg)
  (interactive "P")
  (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
      (progn
        (t--org-insert-sibling-heading-above)
        (org-move-subtree-down))
    (ci 'newline-and-indent)))

(defun t--org-insert-sibling-of-below-heading (&optional arg)
  (interactive "P")
  (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
      (progn (next-line) (beginning-of-line)
             (ci 'org-insert-heading))
    (ci 'newline-and-indent)))

(defun t--org-insert-child-heading (&optional arg)
  (interactive "P")
  (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
      (progn (t--org-insert-sibling-heading) (t-org-demote-subtree))
    (ci 'newline-and-indent)))

(key "M-7" 't--org-insert-sibling-heading-above)
(key "M-8" 't--org-insert-sibling-heading)
(key "M-9" 't--org-insert-parent-heading)
(key "M-9" 't--org-insert-sibling-heading-above)
(key "M-6" 't--org-insert-sibling-heading)
(key "M-3" 't--org-insert-child-heading)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Item Insertion - RET ;;

(defun t-org-insert-item-at-point ()
  "Force insert list item at point on next line"
  (cond
   ((eq major-mode 'org-mode)
    (ci 'newline-and-indent)
    )
   ((eq major-mode 'dired-mode)
    (dired-find-file))
   (t
    (ci 'newline-and-indent)
    )))

(defun t-org-insert ()
  "Normal insert"
  (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
      (progn
        (if (org-at-heading-p)
            (progn (newline-and-indent)
                   (kmacro t--bullet-macro))
          (ci 'org-meta-return)))
    (ci 'newline-and-indent)))

(defun t-org-endline-insert-item ()
  "end line insert item"
  (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
      (progn (end-of-line)
             (if (org-at-heading-p)
                 (progn (newline-and-indent) (kmacro t--bullet-macro))
               (ci 'org-meta-return)))
    (ci 'newline-and-indent)))


;; Up R Ring
(key "C-<enter>" '(t-org-insert))
;; Center R Ring
(key "RET" '(t-org-insert-item-at-point))
;; Down R Ring
(key "M-<enter>" '(t-org-endline-insert-item))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; NAVIGATION ;;;;


;;;; Parent ;;;;
(defun t-org-prev-parent-heading ()
  "navigate to previous parent heading"
  (ignore-errors
    (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
        (if (org-at-heading-p)
            (outline-up-heading 1)
          (outline-previous-visible-heading 1))
      (backward-paragraph))))

(defun t-org-prev-parent-heading2 ()
  "navigate to previous parent heading"
  (ignore-errors
    (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
        (if (org-at-heading-p)
            (progn (if (= (org-current-level) 1)
                       (org-backward-heading-same-level 1)
                     (outline-up-heading 1)))
          (outline-previous-visible-heading 1))
      (backward-paragraph))))


(defun t-org-next-root-heading ()
  (setq t-org-root-level 1)
  ;; (setq t-org-root-level t--org-root-level)
  (let ((prev-t-org-root-level t-org-root-level))
    (if (and (org-at-heading-p) (= (org-current-level) 1))
        (next-line))
    ;; (dotimes (i 7) (t-org-prev-parent-heading))
    (t-org-goto-root)
    (t-org-next-sibling-heading)
    (setq t-org-root-level prev-t-org-root-level)))

(defun t-org-prev-root-heading ()
  (setq t-org-root-level 1)
  ;; (setq t-org-root-level t--org-root-level)
  (let ((prev-t-org-root-level t-org-root-level))
    (if (and (org-at-heading-p) (= (org-current-level) 1))
        (previous-line))
    ;; (dotimes (i 7) (t-org-prev-parent-heading))
    (t-org-goto-root)
    (setq t-org-root-level prev-t-org-root-level)))

(defun t-org-next-parent-heading ()
  "navigate to next parent heading"
  (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
      (ignore-errors
        (t-org-prev-parent-heading)
        (let ((prev-point (point)))
          (org-forward-heading-same-level 1)
          (unless (and (= (org-current-level) 1) (= prev-point (point)))
            ;; (goto-char (point-max))
            (while (= prev-point (point))
              (t-org-prev-parent-heading)
              (setq prev-point (point))
              (org-forward-heading-same-level 1)))
          ))
    (forward-paragraph)))


;;;; Sibling ;;;;

(defun t-org-prev-sibling-heading ()
  "navigate to previous sibling heading"
  (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
      (let ((prev-line (line-number-at-pos))
            (prev-level (org-current-level))
            (final-level)
            (final-point))
        (if (org-at-heading-p)
            (progn
              (org-backward-heading-same-level 1)
              (if (= prev-line (line-number-at-pos))
                  (progn (save-excursion
                           (ignore-errors
                             (outline-previous-visible-heading 1)
                             (while (not (= (org-current-level) prev-level))
                               (if (< (org-current-level) prev-level)
                                   (t-org-prev-child-heading0))
                               (if (> (org-current-level) prev-level)
                                   (t-org-prev-parent-heading))
                               (setq final-level (org-current-level))
                               (setq final-point (point)))))
                         (if (= final-level prev-level)
                             (goto-char final-point)
                           )
                         )))
          (outline-previous-visible-heading 1)))
    (backward-paragraph)))

(defun t-org-next-sibling-heading ()
  "navigate to next sibling heading"
  (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
      (let ((prev-line (line-number-at-pos))
            (prev-level (org-current-level))
            (final-level )
            (final-point ))
        (if (org-at-heading-p)
            (progn (org-forward-heading-same-level 1)
                   (if (= prev-line (line-number-at-pos))
                       (progn
                         (save-excursion
                           (ignore-errors
                             (outline-next-visible-heading 1)
                             (while (not (= (org-current-level) prev-level))
                               (if (< (org-current-level) prev-level)
                                   (t-org-next-child-heading0))
                               (if (> (org-current-level) prev-level)
                                   (t-org-next-parent-heading))
                               (setq final-level (org-current-level))
                               (setq final-point (point)))))
                         (if (= final-level prev-level)
                             (goto-char final-point)
                           )
                         )))
          (outline-next-visible-heading 1)))
    (forward-paragraph)))


;;;; Child ;;;;

(defun t-org-prev-child-heading ()
  "navigate to next child heading"
  (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
      (let ((prev-level (org-current-level))
            (final-level (org-current-level))
            (final-point (point)))
        (if (org-at-heading-p)
            (progn
              (save-excursion
                (ignore-errors
                  (while (not (= (org-current-level) (+ prev-level 1)))
                    (t-org-prev-child-heading0)
                    (setq final-level (org-current-level))
                    (setq final-point (point)))))
              (if (= final-level (+ prev-level 1))
                  (goto-char final-point)))
          (outline-previous-visible-heading 1)))
    (forward-paragraph)))

(defun t-org-next-child-heading ()
  "navigate to next child heading"
  (if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
      (let ((prev-level (org-current-level))
            (final-level (org-current-level))
            (final-point (point)))
        (if (org-at-heading-p)
            (progn
              (save-excursion
                (ignore-errors
                  (while (not (= (org-current-level) (+ prev-level 1)))
                    (t-org-next-child-heading0)
                    (setq final-level (org-current-level))
                    (setq final-point (point)))))
              (if (= final-level (+ prev-level 1))
                  (goto-char final-point)))
          (outline-next-visible-heading 1)))
    (forward-paragraph)))


(defun t-org-prev-child-heading0 ()
  "navigate to previous child heading"
  (previous-line)
  (if (org-at-heading-p) nil (outline-previous-visible-heading 1)))

(defun t-org-next-child-heading0 ()
  "navigate to next child heading"
  (next-line)
  (if (org-at-heading-p) nil (outline-next-visible-heading 1)))


;;;; Keybindings ;;;;

(key "C-s-e" '(t-org-prev-root-heading))
(key "C-s-z" '(t-org-prev-root-heading))
(key "C-s-y" '(t-org-prev-root-heading))
(key "C-s-j" '(t-org-prev-root-heading))
(key "M-7" '(t-org-prev-root-heading))
(key "M-8" '(t-org-next-root-heading))

;; (key "M-<up>" '(t-org-prev-sibling-heading))
;; (key "M-<down>" '(t-org-next-sibling-heading))

;; (key "M-<up>" '(outline-previous-visible-heading 1))
;; (key "M-<down>" '(outline-next-visible-heading 1))

(key "M-7" '(t-org-prev-parent-heading2))
(key "M-8" '(t-org-next-parent-heading))

(key "M-4" '(t-org-prev-sibling-heading))
(key "M-5" '(t-org-next-sibling-heading))

(key "M-1" '(t-org-prev-child-heading))
(key "M-2" '(t-org-next-child-heading))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Hide/Show Subtrees ;;;;

(defun t-org-deepest-subtree-level (&optional cur-level)
  (save-excursion
    (let ((initial-level (org-current-level))
          (deepest-level (org-current-level)))
      (save-excursion
        (t-org-goto-root cur-level)
        (outline-next-heading)
        (setq deepest-level (max deepest-level (org-current-level)))
        (while (and
                (> (org-current-level) initial-level)
                (outline-next-heading))
          (setq deepest-level (max deepest-level (org-current-level)))))
      deepest-level)))

(defun t--org-show-n-leaves (&optional n cur-level)
  (if (>= n 0)
      (outline-show-children (- (t-org-deepest-subtree-level cur-level)
                                (org-current-level) n))
    (outline-show-subtree)))

(defun t-org-show-n-leaves (&optional n cur-level)
  (interactive)
  (save-excursion
    (let ((prev-t-org-root-level t-org-root-level))
      (if (not (org-current-level))
          (progn
            (setq t-org-root-level 1)
            (t-org-show-n-leaves-all n))
        (progn
          (beginning-of-line)
          (outline-hide-subtree)
          (if current-prefix-arg
              (t--org-show-n-leaves current-prefix-arg cur-level)
            (t--org-show-n-leaves n cur-level))))
      (setq t-org-root-level prev-t-org-root-level))))

(defun t-org-show-n-children (n)
  (beginning-of-line)
  (outline-hide-subtree)
  (if current-prefix-arg
      (outline-show-children current-prefix-arg)
    (outline-show-children n)))

(defun t-org-goto-root (&optional cur-level)
  (interactive)
  ;; (if (> (org-current-level) t-org-root-level)
  (let ((root-level (or cur-level t-org-root-level)))
    (while (not (= (org-current-level) root-level))
      (if (> (org-current-level) root-level)
          (t-org-prev-parent-heading2)
        (t-org-next-child-heading)))))

(defun t-org-show-n-children-from-root1 (n)
  (let ((prev-t-org-root-level t-org-root-level))
    (setq t-org-root-level 1)
    (beginning-of-line)
    (save-excursion
      (if (not (org-current-level))
          (progn
            (setq t-org-root-level 1)
            (t-org-show-n-children-all n))
        (progn
          (while (< (org-current-level) t-org-root-level)
            (setq n (+ n (- t-org-root-level (org-current-level))))
            (setq t-org-root-level (org-current-level)))
          (t-org-goto-root)
          (outline-hide-subtree)
          (if current-prefix-arg
              (outline-show-children current-prefix-arg)
            (outline-show-children n))))
      (setq t-org-root-level prev-t-org-root-level))))

(defun t-org-show-n-children-from-root-cur-level (n)
  (setq t-org-root-level t--org-root-level)
  (let ((prev-t-org-root-level t-org-root-level))
    (beginning-of-line)
    (save-excursion
      (if (not (org-current-level))
          (progn
            (setq t-org-root-level 1)
            (t-org-show-n-children-all n))
        (progn
          (setq t-org-root-level (org-current-level))
          (t-org-goto-root)
          (outline-hide-subtree)
          (if current-prefix-arg
              (outline-show-children current-prefix-arg)
            (outline-show-children n))))
      (setq t-org-root-level prev-t-org-root-level))))

(defun t-org-show-n-children-from-root (n)
  (setq t-org-root-level t--org-root-level)
  (let ((prev-t-org-root-level t-org-root-level))
    (beginning-of-line)
    (save-excursion
      (if (not (org-current-level))
          (progn
            (setq t-org-root-level 1)
            (t-org-show-n-children-all n))
        (progn
          (while (< (org-current-level) t-org-root-level)
            (setq n (+ n (- t-org-root-level (org-current-level))))
            (setq t-org-root-level (org-current-level)))
          (t-org-goto-root)
          (outline-hide-subtree)
          (if current-prefix-arg
              (outline-show-children current-prefix-arg)
            (outline-show-children n))))
      (setq t-org-root-level prev-t-org-root-level))))

(defun t-org-show-n-children-from-root-only-here (n)
  (setq t-org-root-level t--org-root-level)
  (let ((prev-t-org-root-level t-org-root-level))
    (beginning-of-line)
    (save-excursion
      (if (not (org-current-level))
          (progn
            (setq t-org-root-level 1)
            (t-org-show-n-children-all n))
        (progn
          (while (< (org-current-level) t-org-root-level)
            (setq n (+ n (- t-org-root-level (org-current-level))))
            (setq t-org-root-level (org-current-level)))
          (while (< (- n (- (org-current-level) 1)) 0)
            (t-org-prev-parent-heading))
          (outline-hide-subtree)
          (outline-show-children (- n (- (org-current-level) 1)))))
      (setq t-org-root-level prev-t-org-root-level))))


(defun t-org-show-n-leaves-from-root-cur-level (n)
  (setq t-org-root-level (org-current-level))
  (t-org-show-n-leaves n (org-current-level)))


(defun t-org-show-n-leaves-from-root (n)
  (setq t-org-root-level t--org-root-level)
  (let ((prev-t-org-root-level t-org-root-level))
    (beginning-of-line)
    (save-excursion
      (if (not (org-current-level))
          (progn
            (setq t-org-root-level 1)
            (t-org-show-n-leaves-all n))
        (progn
          (while (< (org-current-level) t-org-root-level)
            (setq t-org-root-level (org-current-level)))
          (beginning-of-line)
          (t-org-goto-root)
          (t-org-show-n-leaves n)))
      (setq t-org-root-level prev-t-org-root-level))))

(defun t-org-show-n-leaves-from-root-only-here (n)
  (setq t-org-root-level t--org-root-level)
  (let ((prev-t-org-root-level t-org-root-level))
    (beginning-of-line)
    (save-excursion
      (if (not (org-current-level))
          (progn
            (setq t-org-root-level 1)
            (t-org-show-n-leaves-all n))
        (progn
          (while (< (org-current-level) t-org-root-level)
            (setq t-org-root-level (org-current-level)))
          (beginning-of-line)
          (let ((deepest-level (save-excursion
                                 (t-org-prev-parent-heading)
                                 (t-org-deepest-subtree-level))))
            (while (> (org-current-level) (- deepest-level n))
              (t-org-prev-parent-heading)))
          (t-org-show-n-leaves n)))
      (setq t-org-root-level prev-t-org-root-level))))


(defun t-org-show-n-leaves-all (n)
  (save-excursion
    (setq t-org-root-level t--org-root-level)
    (evil-goto-first-line)
    (ci 'outline-next-visible-heading)
    (let ((prev-t-org-root-level t-org-root-level))
      (while (< (org-current-level) t-org-root-level)
        (setq t-org-root-level (org-current-level)))
      (goto-char (point-max))
      ;; (dotimes (i 7) (t-org-prev-parent-heading))
      (t-org-goto-root)
      (dotimes (i 7) (t-org-show-n-leaves-from-root n)
               (t-org-prev-parent-heading2))
      (setq t-org-root-level prev-t-org-root-level))))


(defun t-org-show-n-children-all (n)
  (save-excursion
    (evil-goto-first-line)
    (ci 'outline-next-visible-heading)
    (setq t-org-root-level t--org-root-level)
    (let ((prev-t-org-root-level t-org-root-level))
      (while (< (org-current-level) t-org-root-level)
        (setq t-org-root-level (org-current-level)))
      (goto-char (point-max))
      ;; (dotimes (i 7) (t-org-prev-parent-heading))
      (t-org-goto-root)
      (dotimes (i 7) (t-org-show-n-children-from-root n)
               (t-org-prev-parent-heading2))
      (setq t-org-root-level prev-t-org-root-level))))

(defun t-org-cycle (&optional arg)
  "toggle visibility only between folded and subtree states"
  (interactive)
  (if (outline-invisible-p (line-end-position))
      (outline-show-subtree)
    (outline-hide-subtree)))

(defun t-org-hide-all (&optional arg)
  (interactive)
  (ci 'evil-goto-first-line)
  ;; (beginning-of-line) (dotimes (i 7) (t-org-prev-parent-heading))
  (outline-hide-other)
  )

;; (key "C-M-1" '(progn (beginning-of-line) (outline-hide-subtree)))
;; (key "C-M-2" '(t-org-show-n-leaves 1))
;; (key "C-M-3" '(progn (beginning-of-line) (outline-show-subtree)))

;; (key "C-M-2" '(t-org-show-n-leaves-all 1))
;; (key "C-M-3" '(t-org-show-n-leaves-all 0))
;; (key "C-M-1" 't-org-hide-all)


(key "TAB" '(if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
                (ci 'org-cycle) (ci 'indent-for-tab-command)))
(key "TAB" '(if (eq (t--keymap-symbol (current-local-map)) 'org-mode-map)
                (t-org-cycle) (ci 'indent-for-tab-command)))

(key "C-s-q" 't-org-hide-all)
(key "C-s-w" '(progn (beginning-of-line) (outline-show-all)))

;; (key "C-M-1" '(t-org-show-n-leaves-from-root 1))
;; (key "C-M-2" '(t-org-show-n-leaves-from-root 0))
;; (key "C-M-3" '(t-org-show-n-leaves-from-root -1))

;; w e r
;; s d f
;; a c v

;; (key "M-s-r"   '(t-org-show-n-children-from-root1 0))
(setq t-org-child-start 0)

(key "M-s-W"   '(t-org-show-n-children-all (+ t-org-child-start -2)))
(key "M-s-e"   '(t-org-show-n-children-all (+ t-org-child-start -1)))
(key "M-s-r"   '(t-org-show-n-children-all (+ t-org-child-start 0)))

(key "M-s-SPC" '(t-org-show-n-children-from-root-cur-level 0))

(key  "M-s-s"  '(t-org-show-n-children-from-root-cur-level (+ t-org-child-start 0)))
(key  "M-s-d"  '(t-org-show-n-children-from-root-cur-level (+ t-org-child-start 1)))
(key  "M-s-f"  '(t-org-show-n-children-from-root-cur-level (+ t-org-child-start 2)))

(key "M-s-a"   '(t-org-show-n-children-from-root (+ t-org-child-start 0)))
(key "M-s-c"   '(t-org-show-n-children-from-root (+ t-org-child-start 1)))
(key "M-s-v"   '(t-org-show-n-children-from-root (+ t-org-child-start 2)))



(key "C-s-w"   '(t-org-show-n-leaves-all 1))
(key "C-s-e"   '(t-org-show-n-leaves-all 0))
(key "C-s-r"   '(t-org-show-n-leaves-all -1))

(key "C-s-S-s" '(t-org-show-n-leaves-from-root-cur-level 1))
(key "C-s-S-d" '(t-org-show-n-leaves-from-root-cur-level 0))
(key "C-s-S-f" '(t-org-show-n-leaves-from-root-cur-level -1))

(key "C-s-S-a" '(t-org-show-n-leaves-from-root 1))
(key "C-s-S-c" '(t-org-show-n-leaves-from-root 0))
(key "C-s-S-v" '(t-org-show-n-leaves-from-root -1))

(key "C-s-SPC" '(t-org-show-n-leaves-all 2))



(key "C-M-0" '(t-org-show-n-children-from-root 0))
;; (key "C-M-4" '(t-org-show-n-children-from-root 1))
;; (key "C-M-5" '(t-org-show-n-children-from-root 2))
(key "C-M-1" '(t-org-show-n-children-from-root 3))
(key "C-M-2" '(t-org-show-n-leaves-from-root 1))
(key "C-M-3" '(t-org-show-n-leaves-from-root 0))
;; (key "C-M-5" '(t-org-show-n-leaves-from-root-only-here 2))
;; (key "C-M-4" '(outline-hide-subtree))
;; (key "C-M-5" '(progn (outline-hide-subtree) (outline-show-branches)))
(key "C-M-5" '(t-org-show-n-children-from-root-only-here 100))
;; (key "C-M-4" '(t-org-show-n-children-from-root-only-here 1))
;; (key "C-M-5" '(t-org-show-n-children-from-root-only-here 0))


(key "C-s-g" '(t-org-show-n-leaves-from-root -1))
(key "C-s-x" 't-org-hide-all)


;; (key "C-M-1" '(t-org-show-n-leaves-from-root 2))
;; (key "C-M-2" '(t-org-show-n-leaves-from-root 1))
;; (key "C-M-4" '(t-org-show-n-leaves-from-root-only-here 1))
(key "C-M-6" '(t-org-show-n-leaves-from-root-only-here -1))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Misc ;;;;

(key "M-0" '(print (org-subtree-end-visible-p)))
(key "M-0" 'end-of-line)
(key "M-0" '(t-org-show-n-children-all 0))
(key "C-S-s-k" '(outline-next-heading))
(key "C-S-s-p" 'end-of-line)
(key "C-s-u" 'centercursor-recenter)
(key "C-S-s-k" 'centercursor-recenter)
(key "C-S-s-j" 'centercursor-recenter)


;; u i o
;; j k l
;; m b n

;; Ring-Middle finger layer
(key "C-s-U" '(t-current-keymap))
(key "C-s-I" '(print major-mode))
(key "C-s-O" '(save-excursion (end-of-line) (set-spacemacs-command)))

(key "C-S-s-j" '(org-move-subtree-up))
(key "C-S-s-k" '(org-move-subtree-down))
(key "C-S-s-p" '(progn (ci 'evil-write-all) (ci 'eval-buffer)))

(key "C-S-s-m" '(print 'to))
(key "C-S-s-z" '(print 'to))
(key "C-S-s-n" '(save-excursion (forward-paragraph) (set-spacemacs-command)))
;; (key "" '(t-org-prev-root-heading))


;; Ring-Index finger layer
(key "M-s-U" '(t-open-file 7))
(key "M-s-I" '(t-open-file 8))
(key "M-s-O" '(t-open-file 9))

(key "M-s-J" '(t-open-file 4))
(key "M-s-K" '(t-open-file 5))
(key "M-s-L" '(t-open-file 6))

(key "M-s-M" '(t-open-file 1))
(key "M-s-B" '(t-open-file 2))
(key "M-s-N" '(t-open-file 3))


(setq t-files
      '(
        "~/.emacs.d/config/org.el"
        ;;
        "~/learning/uvm/sv_assertions_coverage_constrained_randomization_notes_practice_problems.sv"
        "~/learning/uvm/tb_ram.sv"
        "~/learning/uvm/uvm_notes.txt"
        ;;
        "~/learning/notes/learning_notes.org"
        "~/.emacs.d/config/org.el"
        "~/.emacs.d/config/user-config.el"
        ;;
        "~/.emacs.d/config/help.el"
        "~/.emacs.d/config/projectile.el"
        "~/.emacs.d/config/main.el"
        ))

(defun t-open-file (&optional n)
  (interactive)
  (let ((file (nth n t-files)))
    (switch-to-buffer (find-file-noselect file t))))

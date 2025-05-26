;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Setup ;;;;

(setq torg-root-level 3)

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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Promotion ;;;;

(defun torg-promote-subtree ()
  (save-excursion
    (kmacro "<home>")
    (if (org-at-heading-p)
        (ci 'org-do-promote) (ci 'org-outdent-item-tree))))

(defun torg-demote-subtree ()
  (save-excursion
    (kmacro "<home>")
    (if (org-at-heading-p)
        (ci 'org-do-demote) (ci 'org-indent-item-tree))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Bullet toggling ;;;;

(setq t--bullet "-")
(setq t--bullet-macro "SPC * SPC")
(setq t--bullet-macro "- SPC")

(defun t--toggle-bullet ()
  (setq t--bullet (if (string= t--bullet "+") "-" "+"))
  (org-cycle-list-bullet t--bullet))



;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Checkbox toggling ;;;;

;; (key "C-M-7" '(progn  (let ((current-prefix-arg '(4))) (ci 'org-toggle-checkbox))))
;; (key "C-s-x" 'org-toggle-checkbox)


;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Header toggling ;;;;

(defun t-toggle-parent-header-and-item ()
  "Toggle parent header/item"
  (kmacro "<home>")
  (if (org-at-heading-p) (ci 'org-toggle-item)
    (progn (ci 'org-toggle-heading)
           (ci 'org-promote-subtree)
           (ci 'org-promote-subtree))))

(defun t-toggle-sibling-header-and-item (&optional &rest args)
  "Toggle sibling header/item"
  (cond ((eq major-mode 'org-mode)
         (kmacro "<home>")
         (if (org-at-heading-p) (ci 'org-toggle-item)
           (progn (ci 'org-toggle-heading)
                  (ci 'org-promote-subtree))))
        (t (t-set-cmd) (next-line))))


(defun t-toggle-child-header-and-item ()
  "Toggle child header/item"
  (kmacro "<home>")
  (if (org-at-heading-p) (ci 'org-toggle-item)
    (progn (ci 'org-toggle-heading))))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Header Insertion ;;;;

(defun t--org-insert-parent-heading (&optional arg)
  (interactive "P")
  (if (eq major-mode 'org-mode)
      (progn (end-of-line) (end-of-visual-line)
             (ci 'org-insert-heading)
             (ci 'org-do-promote))
    (ci 'newline-and-indent)))


(defun t--org-insert-sibling-heading-above (&optional arg)
  (interactive "P")
  (kmacro "<home>")
  (ci 'outline-insert-heading)
  (end-of-line)
  (kmacro "SPC"))

(defun t--org-insert-sibling-heading (&optional arg)
  (interactive "P")
  (if (eq major-mode 'org-mode)
      (progn
        (t--org-insert-sibling-heading-above)
        (ci 'evil-delete-whole-line)
        (ci 'evil-paste-after)
        (end-of-line))
    (ci 'newline-and-indent)))


(defun t--org-insert-child-heading (&optional arg)
  (interactive "P")
  (if (eq major-mode 'org-mode)
      (progn (t--org-insert-sibling-heading)
             (torg-demote-subtree)
             (end-of-line))
    (ci 'newline-and-indent)))


(defun t-open-elisp (&optional &rest args)
  )

(defun t-jump-brace-area (&optional &rest args)

  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Item Insertion - RET ;;

(defun torg-insert (&optional &rest body)
  "Normal insert"
  (interactive)
  (cond
   ((eq major-mode 'org-mode)
    (cond ((= (point)
              (save-excursion
                (end-of-line)
                (point)))
           (torg-insert-item-at-point))
          (t (ci 'newline-and-indent))))
   (t (ci 'newline-and-indent))))

(defun torg-insert-item-at-point ()
  "Force insert list item at point on next line"
  (cond ((eq major-mode 'org-mode)
         (cond ((org-at-heading-p) (newline-and-indent) (kmacro t--bullet-macro))
               (t (ci 'org-meta-return))))
        ((eq major-mode 'dired-mode) (dired-find-file))
        (t (t-set-cmd) (next-line))))

(defun torg-insert-sibling-heading-below (&optional &rest body)
  "Normal insert"
  (interactive)
  (cond
   ((eq major-mode 'org-mode)
    (t--org-insert-sibling-heading))
   (t (ci 'evil-jump-item))))

(defun torg-endline-insert-item ()
  "end line insert item"
  (cond
   ((eq major-mode 'org-mode)
    (end-of-line)
    (if (org-at-heading-p)
        (progn (newline-and-indent) (kmacro t--bullet-macro))
      (ci 'org-meta-return)))
   (t
    (t-set-cmd) (next-line)
    )))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; NAVIGATION ;;;;

(defun torg-forward-same-level (&optional n)
  (setq n (or n 1))
  (ignore-errors (outline-forward-same-level n)))
(defun torg-backward-same-level (&optional n)
  (setq n (or n 1))
  (ignore-errors (outline-backward-same-level n)))
(defun torg-next-visible-heading (&optional n)
  (setq n (or n 1))
  (ignore-errors (outline-next-visible-heading n)))
(defun torg-previous-visible-heading (&optional n)
  (setq n (or n 1))
  (ignore-errors (outline-previous-visible-heading n)))

;;;; Parent ;;;;

(defun torg--moveto-heading (&optional n direction level)
  "Navigate to the `n'th previous parent heading. `n' is 1 by default."
  (kmacro "<home>")
  (let ((orig-line (line-number-at-pos))
        (orig-n n)
        (orig-level (org-current-level)))
    (setq n (or n 1))
    (let ((target-level (cond ((eq level 'parent) (- (org-current-level) n))
                              ((eq level 'sibling) (org-current-level))
                              ((eq level 'child) (+ (org-current-level) n))))
          (final-level (org-current-level)) (final-point (point)))
      (setq direction (or direction 'previous))
      (setq level (or level 'parent))
      (cond
       ((and orig-n (= target-level orig-level)))
       ((and (= 1 (org-current-level)) (not (eq level 'child)))
        (if (eq direction 'previous)
            (torg-backward-same-level n)
          (torg-forward-same-level n)))
       (t
        (when (and (not orig-n) (not (org-at-heading-p)) (eq level 'parent))
          (setq target-level (+ 1 target-level))
          (if (eq direction 'previous) (torg-previous-visible-heading 1)
            (torg-next-visible-heading 1)))
        (save-excursion
          (while
              (and
               (not (= (line-number-at-pos)
                       (line-number-at-pos (if (eq direction 'previous)
                                               (point-min) (point-max)))))
               (or
                (= orig-line (line-number-at-pos))
                (cond
                 ((eq level 'parent) (> (org-current-level) target-level))
                 ((eq level 'sibling) (not (= (org-current-level) target-level)))
                 ((eq level 'child) (< (org-current-level) target-level)))))
            (if (eq direction 'previous)
                (torg-previous-visible-heading 1)
              (torg-next-visible-heading 1))
            (setq final-level (org-current-level))
            (setq final-point (point))
            ))
        (if (cond ((eq level 'parent) (<= final-level target-level))
                  ((eq level 'sibling) (= final-level target-level))
                  ((eq level 'child) (>= final-level target-level)))
            (goto-char final-point)))))))


(defun torg-previous-parent-heading (&optional n direction level)
  "Navigate to the `n'th previous parent heading. `n' is 1 by default."
  (interactive) (torg--moveto-heading n 'previous 'parent))

(defun torg-next-parent-heading (&optional n)
  "Navigate to the `n'th next parent heading. `n' is 1 by default."
  (interactive) (torg--moveto-heading n 'next 'parent))

(defun torg-goto-previous-parent-heading-level (&optional n)
  "Navigate to previous parent heading if `n`' is nil.
Otherwise, go to previous parent heading at level `n'"
  (interactive) (torg--moveto-heading
                 (if n (- (org-current-level) n) torg-root-level) 'previous 'parent))

(defun torg-goto-next-parent-heading-level (&optional n)
  "Navigate to next parent heading if `n`' is nil.
Otherwise, go to next parent heading at level `n'"
  (interactive) (torg--moveto-heading
                 (if n (- (org-current-level) n) torg-root-level) 'next 'parent))


;;;; Sibling ;;;;
(defun torg-previous-sibling-heading (&optional n)
  "navigate to the `nth' previous sibling heading. `n' is 1 by default."
  (interactive) (torg--moveto-heading n 'previous 'sibling))

(defun torg-next-sibling-heading (&optional n)
  "navigate to the `nth' next sibling heading. `n' is 1 by default."
  (interactive) (torg--moveto-heading n 'next 'sibling))


;;;; Child ;;;;
(defun torg-previous-child-heading (&optional n)
  "navigate to the `nth' previous child heading. `n' is 1 by default."
  (interactive) (torg--moveto-heading n 'previous 'child))

(defun torg-next-child-heading (&optional n)
  "navigate to the `nth' next child heading. `n' is 1 by default."
  (interactive) (torg--moveto-heading n 'next 'child))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Hide/Show Subtrees ;;;;


;;;;;;;;;;;;;;;
;;;; Cycle ;;;;

(defun torg-cycle (&optional arg)
  "toggle visibility only between folded and subtree states"
  (interactive)
  (if (outline-invisible-p (line-end-position))
      (outline-show-subtree)
    (outline-hide-subtree)))

(defun torg-hide-all (&optional arg)
  (interactive)
  (ci 'evil-goto-first-line)
  (outline-hide-other))


;;;;;;;;;;;;;;;;;;;;
;;;; Utilities ;;;;

(defun torg-deepest-subtree-level (&optional cur-level)
  (save-excursion
    (let ((initial-level (org-current-level))
          (deepest-level (org-current-level)))
      (save-excursion
        (torg-goto-previous-parent-heading-level cur-level)
        (outline-next-heading)
        (setq deepest-level (max deepest-level (org-current-level)))
        (while (and
                (> (org-current-level) initial-level)
                (outline-next-heading))
          (setq deepest-level (max deepest-level (org-current-level)))))
      deepest-level)))


;;;;;;;;;;;;;;;;;;
;;;; Children ;;;;

(defun torg-show-n-children (n &optional root-level)
  (interactive)
  (setq root-level (or root-level (org-current-level)))
  (save-excursion
    (kmacro "<home>")
    (cond
     ((= root-level 0)
      (evil-goto-first-line)
      (while (not (org-at-heading-p)) (outline-next-heading))
      (let ((prev-line (- (line-number-at-pos) 1)))
        (while (> (line-number-at-pos) prev-line)
          (torg-show-n-children n 1)
          (setq prev-line (line-number-at-pos))
          (torg-forward-same-level 1))))
     (t
      (torg-goto-previous-parent-heading-level root-level)
      (outline-hide-subtree)
      (if current-prefix-arg
          (outline-show-children current-prefix-arg)
        (outline-show-children n))))))

(defun torg-show-n-children-from-root (n)
  (torg-show-n-children n torg-root-level))

;;;;;;;;;;;;;;;;
;;;; Leaves ;;;;


(defun t--org-show-n-leaves (&optional n root-level)
  (if (>= n 0)
      (outline-show-children
       (- (torg-deepest-subtree-level root-level)
          (org-current-level) n))
    (outline-show-subtree)))

(defun torg-show-n-leaves (&optional n root-level)
  "Show `root-level' leaves from bottom.
If `root-level` is 0, show all leaves of all top-level subtrees."
  (interactive)
  (setq root-level (or root-level (org-current-level)))
  (save-excursion
    (kmacro "<home>")
    (cond
     ((= root-level 0)
      (evil-goto-first-line)
      (while (not (org-at-heading-p)) (outline-next-heading))
      (let ((prev-line (- (line-number-at-pos) 1)))
        (while (> (line-number-at-pos) prev-line)
          (torg-show-n-leaves n 1)
          (setq prev-line (line-number-at-pos))
          (torg-forward-same-level 1))))
     (t
      (torg-goto-previous-parent-heading-level root-level)
      (outline-hide-subtree)
      (if current-prefix-arg
          (t--org-show-n-leaves current-prefix-arg root-level)
        (t--org-show-n-leaves n root-level))))))

(defun torg-show-n-leaves-from-root (n)
  (torg-show-n-leaves n torg-root-level))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Moving ;;;;

(defun torg-move-subtree-up (&optional arg)
  "Move the current subtree up past ARG headlines of the same level."
  (interactive "p")
  (torg-move-subtree-down (- arg)))

(defun ttorg-move-subtree-up (&optional arg)
  "Move the current subtree up past ARG headlines of the same level."
  (interactive "p")
  (torg-move-subtree-down (- (prefix-numeric-value arg))))

(defun torg-move-subtree-down (&optional arg)
  "Move the current subtree down past ARG headlines of the same level."
  (interactive "p")
  (setq arg (prefix-numeric-value arg))
  (org-preserve-local-variables
   (let ((movfunc (if (> arg 0) 'org-get-next-sibling
                    'org-get-previous-sibling))
         (ins-point (make-marker))
         (cnt (abs arg))
         (col (current-column))
         beg end txt folded)
     ;; Select the tree
     (org-back-to-heading)
     (setq beg (point))
     (save-match-data
       (save-excursion
         ;; (outline-end-of-heading)
         (org-get-next-sibling)
         (setq folded (org-invisible-p)))
       (progn
         ;; (org-end-of-subtree nil t)
         (org-get-next-sibling)
         (unless (eobp) (backward-char))))
     (outline-next-heading)
     (setq end (point))
     (goto-char beg)
     ;; Find insertion point, with error handling
     (while (> cnt 0)
       (unless (and (funcall movfunc) (looking-at org-outline-regexp))
         ;; (goto-char beg)
         ;; (user-error "Cannot move past superior level or buffer limit")
         )
       (setq cnt (1- cnt)))
     (when (> arg 0)
       ;; Moving forward - still need to move over subtree
       ;; (org-end-of-subtree t t)
       (org-get-next-sibling)
       (save-excursion
         (org-back-over-empty-lines)
         (or (bolp) (newline))))
     (move-marker ins-point (point))
     (setq txt (buffer-substring beg end))
     (org-save-markers-in-region beg end)
     (delete-region beg end)
     (org-remove-empty-overlays-at beg)
     (unless (= beg (point-min)) (org-flag-region (1- beg) beg nil 'outline))
     (unless (bobp) (org-flag-region (1- (point)) (point) nil 'outline))
     (and (not (bolp)) (looking-at "\n") (forward-char 1))
     (let ((bbb (point)))
       (insert-before-markers txt)
       (org-reinstall-markers-in-region bbb)
       (move-marker ins-point bbb))
     (or (bolp) (insert "\n"))
     (goto-char ins-point)
     (org-skip-whitespace)
     (move-marker ins-point nil)
     (if folded
         (org-flag-subtree t)
       (org-show-entry)
       (org-show-children))
     (org-clean-visibility-after-subtree-move)
     ;; move back to the initial column we were at
     (move-to-column col))))

(defun torg-move-subtree-down (&optional arg)
  "Move the current subtree down past ARG headlines of the same level."
  (interactive "p")
  (cond
   ((org-at-heading-p)
    (outline-back-to-heading)
    (let* ((movfunc (if (> arg 0)
                        ;; 'outline-next-visible-heading
                        ;; 'outline-previous-visible-heading
                        ;; 'torg-next-sibling-heading
                        ;; 'torg-previous-sibling-heading
                        'outline-get-next-sibling
                      'outline-get-last-sibling
                      ))
           ;; Find the end of the subtree to be moved as well as the point to
           ;; move it to, adding a newline if necessary, to ensure these points
           ;; are at bol on the line below the subtree.
           (end-point-func (lambda ()
                             (outline-end-of-subtree)
                             (if (eq (char-after) ?\n) (forward-char 1)
                               (if (and (eobp) (not (bolp))) (insert "\n")))
                             (point)))
           (beg (point))
           (folded (save-match-data
                     (outline-end-of-heading)
                     (outline-invisible-p)))
           (end (save-match-data
                  (funcall end-point-func)))
           (ins-point (make-marker))
           (cnt (abs arg)))
      ;; Find insertion point, with error handling.
      (goto-char beg)
      (while (> cnt 0)
        (or (funcall movfunc)
            (progn
              ;; (goto-char beg)
              ;; (user-error "Cannot move past superior level")
              ))
        (setq cnt (1- cnt)))
      (if (> arg 0)
          ;; Moving forward - still need to move over subtree.
          (funcall end-point-func))
      (move-marker ins-point (point))
      (insert (delete-and-extract-region beg end))
      (goto-char ins-point)
      (if folded (outline-hide-subtree))
      (move-marker ins-point nil)))
   ((org-at-item-p)
    (unless (org-at-item-p) (error "Not at an item"))
    (let* ((col (current-column))
           (item (point-at-bol))
           (struct (org-list-struct))
           (prevs (org-list-prevs-alist struct))
           (next-item (org-list-get-next-item (point-at-bol) struct prevs)))
      (unless (or next-item org-list-use-circular-motion)
        ;; (user-error "Cannot move this item further down")
        )
      (if (not next-item)
          (setq struct (org-list-send-item item 'begin struct))
        (setq struct (org-list-swap-items item next-item struct))
        (goto-char
         (org-list-get-next-item item struct (org-list-prevs-alist struct))))
      (org-list-write-struct struct (org-list-parents-alist struct))
      (org-move-to-column col)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Files ;;;;

(defun t-open-file (&optional n)
  (interactive)
  (let ((file (nth n t-files)))
    (if (file-exists-p file)
        (switch-to-buffer (find-file-noselect file t))
      (switch-to-buffer file))))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Bindings ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; HIDE/SHOW Subtrees ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; RING MIDDLE - LEFT Keys hand ;;;;;;;;;;;;;;;;;;;;

;; SHOW LEAVES ;;

(key  "C-s-w" '(torg-show-n-leaves-from-root 1))
(key  "C-s-e" '(torg-show-n-leaves-from-root 0))
(key  "C-s-r" '(torg-show-n-leaves-from-root -1))

(key "C-s-S-s"'(torg-show-n-leaves 1))
(key "C-s-S-d"'(torg-show-n-leaves 0))
(key "C-s-S-f"'(torg-show-n-leaves -1))

(key "C-s-SPC" '(torg-show-n-leaves nil))
;;
(key "C-s-S-a"   '(torg-show-n-leaves 1 0))
(key "C-s-S-c"   '(torg-show-n-leaves 0 0))
(key "C-s-S-v" '(progn (outline-show-all)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; RING INDEX - LEFT Keys hand ;;;;;;;;;;;;;;;;;;;;

;; SHOW CHILDREN ;;

(setq torg-child-start 0)

(key "M-s-W"   '(torg-show-n-children-from-root (+ torg-child-start 0)))
(key "M-s-e"   '(torg-show-n-children-from-root (+ torg-child-start 1)))
(key "M-s-r"   '(torg-show-n-children-from-root (+ torg-child-start 2)))

(key  "M-s-s"  '(torg-show-n-children (+ torg-child-start 0)))
(key  "M-s-d"  '(torg-show-n-children (+ torg-child-start 1)))
(key  "M-s-f"  '(torg-show-n-children (+ torg-child-start 2)))

(key "M-s-SPC" '(torg-show-n-children 0))
;;
(key "M-s-a"   '(torg-show-n-children (+ torg-child-start 0) 0))
(key "M-s-c"   '(torg-show-n-children (+ torg-child-start 1) 0))
(key "M-s-v"   '(torg-show-n-children (+ torg-child-start 2) 0))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Hide/Show Subtrees ;;;;
(key "TAB" '(if (eq major-mode 'org-mode)
                (ci 'org-cycle) (ci 'indent-for-tab-command)))
(key "TAB" '(if (eq major-mode 'org-mode)
                (torg-cycle) (ci 'indent-for-tab-command)))

(key "C-s-q" 'torg-hide-all)







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MISC ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(key "C-M-<kp-enter>" '(t-toggle-sibling-header-and-item))
(key "S-<kp-enter>" '(t-kmacro "RET"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MIDDLE RING - LEFT Keys hand ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Misc

(key "C-M-0" '(torg-show-n-children-from-root 0))

(key "C-M-1" '(torg-show-n-children-from-root 3))
(key "C-M-2" '(torg-show-n-leaves-from-root 1))
(key "C-M-3" '(torg-show-n-leaves-from-root 0))

(key "C-M-4" '(torg-show-n-children (+ torg-child-start 0)))
(key "C-M-5" '(torg-show-n-leaves 0))
(key "C-M-6" '(torg-show-n-leaves -1))

(key "C-s-g" '(torg-show-n-leaves-from-root -1))
(key "C-s-x" 'torg-hide-all)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Item Insertion - RET ;;
;; Up R Ring
(key "<f5>" '(t-toggle-sibling-header-and-item))
(key "<f6>" '(torg-insert-item-at-point))
(key "<f7>" '(torg-insert-sibling-heading-below))
;; Center R Ring
(key "RET" 'torg-insert)
;; Down R Ring
(key "<f3>" 't-copy-area)
(define-key evil-motion-state-map (kbd "<f7>") 'evil-jump-item)
(define-key evil-motion-state-map (kbd "<f6>") 't-jump-brace-area)

;;;;;;;;;;;;;;;;;;;
;;;; Promotion ;;;;
(key  "C-M-s-<" '(torg-promote-subtree))
(key  "C-M-s->" '(torg-demote-subtree))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MIDDLE RING - LEFT Keys ;;;;;;;;;;;;;;;;;;;;

;;;; Bullet toggling ;;;;
(key "C-M-8" 'org-promote-subtree)
(key "C-M-9" 'org-demote-subtree)

;;;; Header Insertion ;;;;
(key "M-9" 't--org-insert-sibling-heading-above)
(key "M-6" 't--org-insert-sibling-heading)
(key "M-3" 't--org-insert-child-heading)

;;;;;;;;;;;;;;;;;;;;
;;;; Navigation ;;;;

(key "M-0" 'end-of-line)

(key "M-7" '(torg-previous-parent-heading))
(key "M-8" '(torg-next-parent-heading))

(key "M-4" '(torg-previous-sibling-heading))
(key "M-5" '(torg-next-sibling-heading))

(key "M-1" '(torg-previous-child-heading))
(key "M-2" '(torg-next-child-heading))


(key "S-<prior>" '(if (eq major-mode 'org-mode) (torg-previous-visible-heading 1) (backward-paragraph)))
(key "S-<next>" '(if (eq major-mode 'org-mode) (torg-next-visible-heading 1) (forward-paragraph)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; RING INDEX - RIGHT Keys ;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;
;;;; FILES ;;;;
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
        "~/learning/uvm/tb_ram.sv"
        "*Messages*"
        "~/learning/uvm/uvm_notes.txt"
        ;;
        "~/notes/todo.org"
        "~/learning/notes/notes.org"
        "~/.emacs.d/config/org.el"
        ;;
        "~/.emacs.d/config/help.el"
        "~/.emacs.d/config/user-config.el"
        "~/.emacs.d/config/main.el"
        ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; RING MIDDLE - RIGHT Keys ;;;;;;;;;;;;;;;;;;;;

;; (key "C-s-u" '(save-excursion (ci 'evil-write-all) (end-of-line) (t-set-cmd)))
(key "C-S-s-o"
     '(save-excursion
        (ci 'evil-write-all) (forward-paragraph) (t-set-cmd)))
(key "C-s-u" '(org-move-item-up))
(key "C-s-I" '(org-move-item-down))
;; Test
;; (key "C-s-O" '(progn
;;                 (kmacro "<home>")
;;                 (outline-end-of-subtree)
;;                 ;; (outline-back-to-heading))
;;                 ;; (outline-next-visible-heading 1)
;;                 ;; (end-of-line)
;;                 (if (eq (char-after) ?\n) (forward-char 1)
;;                   (if (and (eobp) (not (bolp))) (insert "\n")))
;;                 (point)))
(key "C-S-s-j" '(cond ((eq major-mode 'org-mode)
                       (torg-move-subtree-up 1))
                      (t (evil-write-all nil) (eval-buffer)
                         (message "Evaluated buffer"))))
(key "C-S-s-k" '(cond ((eq major-mode 'org-mode)
                       (torg-move-subtree-down 1))
                      (t (save-excursion
                           (ci 'evil-write-all)
                           (forward-paragraph)
                           (t-set-cmd)))))
(key "C-S-s-p" '(save-excursion (t-set-cmd)))

(key "C-S-s-m" 'adaptive-wrap-prefix-mode)
(key "C-S-s-z" '(toggle-truncate-lines))
(key "C-S-s-n" 'visual-line-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;     x |w e r| t   ;;   y |u i o| z     ;;;
;;     q |s d f| g   ;;   h |j k l| p     ;;;
;;   SPC |a c v|     ;;     |m b n|       ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

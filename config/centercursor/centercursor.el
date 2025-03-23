;;; centercursor.el --- My improved version of centered-cursor-mode -*- lexical-binding: t; -*-

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;; Automatically center buffers vertically in the window after opening files and
;; during editing. Users can also adjust the centering offset with scrolling to
;; further scroll up or down by any amount above the top lines in a buffer.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; TODO:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Customization

(require 'topspace)

(defvar-local centercursor--previous-window-heights '()
  "Stores the window heights of each window that buffer has been selected in.")


(setq centercursor-center-position 0.42)
(defvar-local centercursor--enabled nil)

(defgroup centercursor nil
  "."
  :group 'scrolling
  :group 'convenience
  :link '(emacs-library-link :tag "Source Lisp File" "centercursor.el")
  ;; :link '(url-link "https://github.com/")
  :link '(emacs-commentary-link :tag "Commentary" "centercursor"))
(defvar centercursor-min-context-lines-top 8)
(defvar centercursor-min-context-lines-bottom 4)
(defvar previous-mwheel-scroll-up-function #'mwheel-scroll-up-function)
(defvar previous-mwheel-scroll-down-function #'mwheel-scroll-down-function)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun centercursor-center-line ()
  (let ((line (topspace--center-line centercursor-center-position))
        (window-height (window-text-height)))
    (when (floatp centercursor-center-position)
      (setq line (- line (window-top-line))))
    (setq line (round (1- line)))
    (when (> line (- window-height
                     topspace--context-lines
                     centercursor-min-context-lines-bottom))
      (setq line (- window-height centercursor-min-context-lines-bottom
                    topspace--context-lines)))
    (when (< line centercursor-min-context-lines-top)
      (setq line centercursor-min-context-lines-top))
    (when (< (- window-height topspace--context-lines)
             (+ centercursor-min-context-lines-bottom
                centercursor-min-context-lines-top))
      (setq line (floor (/
                         (- window-height topspace--context-lines)
                         2))))
    line))

;;;###autoload
(defun centercursor-recenter ()
  "TODO."
  (interactive)
  (recenter (centercursor-center-line)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun centercursor--window-height ()
  "TODO."
  (ceiling (window-screen-lines)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Hooks
(defun centercursor--after-command ()
  "TODO."
  (ignore-errors (centercursor-recenter)))

(defun centercursor--window-configuration-change ()
  (ignore-errors
    (let ((current-height (window-text-height))
          (window (selected-window)))
      (let ((previous-height (alist-get window
                                        centercursor--previous-window-heights
                                        ;; current-height
                                        0
                                        )))
        (when (and (= (window-start) 1)
                   (eq (line-number-at-pos) 1)
                   ;; (topspace--eval-choice topspace-autocenter-buffers)
                   (or (not (fboundp 'frame-parent))
                       (not (frame-parent)))
                   ;; (equal centercursor--previous-window-heights '())
                   (eq (alist-get window centercursor--previous-window-heights) nil)
                   (not (= previous-height current-height)))
          (centercursor-goto-center-buffer-line))
        (setf (alist-get window centercursor--previous-window-heights)
              current-height)))))

(defun centercursor-goto-center-buffer-line ()
  (let ((line-offset) (make-center-function))
    (setq make-center-function
          (if (fboundp 'topspace--height-to-recenter-buffer)
              #'topspace--height-to-recenter-buffer
            #'topspace-height-to-make-buffer-centered))
    (setq line-offset
          (ceiling (- (- (topspace--center-line
                          centercursor-center-position)
                         (topspace--correct-height
                          (funcall make-center-function
                                   ;; centercursor-center-position
                                   )))
                      (topspace--count-lines (window-start) (point))
                      1)))
    (next-line line-offset)))

(defun centercursor--kill-buffer ()
  (setq centercursor--previous-window-heights '()))

(defvar centercursor--hook-alist
  '(
    (post-command-hook . centercursor--after-command)
    (window-configuration-change-hook
     . centercursor--window-configuration-change)
    ;; (kill-buffer-hook . centercursor--kill-buffer)
    )
  "A list of hooks so they only need to be written in one spot.
List of cons cells in format (hook-variable . function).")

(defun centercursor--add-hooks ()
  "Add hooks defined in variable `centercursor-hook-alist'."
  (dolist (hook-func-pair centercursor--hook-alist)
    (add-hook (car hook-func-pair) (cdr hook-func-pair) 0 t)))

(defun centercursor--remove-hooks ()
  "Remove hooks defined in variable `centercursor-hook-alist'."
  (dolist (hook-func-pair centercursor--hook-alist)
    (remove-hook (car hook-func-pair) (cdr hook-func-pair) t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Mode definition and setup

(defvar centercursor-keymap (make-sparse-keymap)
  "Keymap for Centercursor commands.
By default this is left empty for users to set with their own
preferred bindings.")

;;;###autoload
(define-minor-mode centercursor-mode
  "Allows vertical padding or scrolling above the top line of a buffer.
When opening a buffer, the contents are initially vertically centered with
krespect to the window height. The user can also scroll as well to adjust the
centering offset. The buffer also recenters if transfered to
another window unless user has previously adjusted its height with scrolling."
  :init-value nil
  :ligher " Ⓣ"
  :keymap centercursor-keymap
  :group 'centercursor
  (if centercursor-mode (centercursor-enable) (centercursor-disable)))

;;;###autoload
(define-globalized-minor-mode global-centercursor-mode centercursor-mode
  centercursor-mode
  :group 'centercursor)

(defun centercursor-enable-p ()
  (not (or centercursor--enabled
           (minibufferp)
           (frame-parent)
           (string-prefix-p " " (buffer-name)))))

;;;###autoload
(defun centercursor-enable ()
  "TODO."
  (interactive)
  (ignore-errors
    (when (centercursor-enable-p)
      (setq centercursor--enabled t)
      (centercursor--add-hooks)
      ;; (centered-cursor-mode 1)
      (setq previous-mwheel-scroll-up-function mwheel-scroll-up-function)
      (setq mwheel-scroll-up-function #'next-line)
      (setq previous-mwheel-scroll-down-function mwheel-scroll-down-function)
      (setq mwheel-scroll-down-function #'previous-line))))

;;;###autoload
(defun centercursor-disable ()
  "Delete/unset data structures when the mode is turned off."
  (interactive)
  (when centercursor--enabled
    (setq centercursor--enabled nil)
    (centercursor--remove-hooks)
    (setq mwheel-scroll-up-function previous-mwheel-scroll-up-function)
    (setq mwheel-scroll-down-function previous-mwheel-scroll-down-function)
    ;; (centered-cursor-mode 0)
    ))

(provide 'centercursor)

;;; centercursor.el ends here

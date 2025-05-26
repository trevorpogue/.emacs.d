;;; eshell-posframe.el --- Using posframe to show eshell window  -*- lexical-binding: t -*-

;; Copyright (C) 2017-2018 Free Software Foundation, Inc.

;; Author: Feng Shu
;; Maintainer: Feng Shu <tumashu@163.com>
;; URL: https://github.com/tumashu/eshell-posframe
;; Package-Version: 20210412.1147
;; Package-Commit: 2412e5b3c584c7683982a7e9cfa10a67427f2567
;; Version: 0.1.0
;; Keywords: abbrev, convenience, matching, eshell
;; Package-Requires: ((emacs "26.0")(posframe "1.0.0")(eshell "0.1"))

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.


;;; Commentary:
;; * eshell-posframe README                                :README:
;; ** Need new maintainer !!!
;; I do not use eshell and hard to maintain this package, for I
;; do not know the details of eshell. need a new maintainer !!!

;; ** What is eshell-posframe
;; eshell-posframe is a eshell extension, which let eshell use posframe
;; to show its candidate menu.

;; NOTE: eshell-posframe requires Emacs 26

;; ** How to enable and disable eshell-posframe
;;    #+BEGIN_EXAMPLE
;;    (eshell-posframe-enable)
;;    (eshell-posframe-disable)
;;    #+END_EXAMPLE

;; ** Tips

;; *** How to show fringe to eshell-posframe
;; ;; #+BEGIN_EXAMPLE
;; (setq eshell-posframe-parameters
;;       '((left-fringe . 10)
;;         (right-fringe . 10)))
;; ;; #+END_EXAMPLE

;; By the way, User can set *any* parameters of eshell-posframe with
;; the help of `eshell-posframe-parameters'.

;;; Code:
;; * eshell-posframe's code
(require 'cl-lib)
(require 'posframe)
(require 'eshell)


(defgroup eshell-posframe nil
  "Using posframe to show eshell menu"
  :group 'eshell
  :prefix "eshell-posframe")

(defcustom eshell-posframe-poshandler
  #'posframe-poshandler-window-bottom-left-corner
  "The poshandler of eshell-posframe."
  :group 'eshell-posframe
  :type 'function)

(defcustom eshell-posframe-width 249
  "The width of eshell-posframe."
  :group 'eshell-posframe
  :type 'number)

(defcustom eshell-posframe-min-width eshell-posframe-width
  "The width of eshell-min-posframe."
  :group 'eshell-posframe
  :type 'number)

(defcustom eshell-posframe-height 55
  "The height of eshell-posframe."
  :group 'eshell-posframe
  :type 'number)

(defcustom eshell-posframe-min-height eshell-posframe-height
  "The height of eshell-min-posframe."
  :group 'eshell-posframe
  :type 'number)

(defcustom eshell-posframe-border-width 1
  "The border width used by eshell-posframe.
When 0, no border is showed."
  :type 'number)

(defcustom eshell-posframe-size-function #'eshell-posframe-get-size
  "The function which is used to deal with posframe's size."
  :group 'eshell-posframe
  :type 'function)

(defcustom eshell-posframe-font nil
  ;; '("Source Code Pro" . 10.0 normal normal)
  "The font used by eshell-posframe.
When nil, Using current frame's font as fallback."
  :group 'eshell-posframe
  :type 'string)

(defcustom eshell-posframe-border-width 1
  "The border width used by eshell-posframe.
When 0, no border is shown."
  :group 'eshell-posframe
  :type 'number)

(defcustom eshell-posframe-parameters
  '(
    (vertical-scroll-bars . t)
    ;; (font-height 10)
    ;; (font-width 10)
    ;; (left-fringe . 600)
    ;; (right-fringe . 10)
    )
  "The frame parameters used by eshell-posframe."
  :group 'eshell-posframe
  :type 'string)

(defface eshell-posframe-border
  '((t (:inherit default :background "gray50")))
  "Face used by the ivy-posframe's border."
  :group 'eshell-posframe)

(defvar eshell-posframe-buffer nil
  "The posframe-buffer used by eshell-posframe.")

;; Fix warn
(defvar emacs-basic-display)

(defun eshell-posframe-display (buffer &optional _resume)
  "The display function which is used by `eshell-display-function'.
Argument BUFFER."
  (setq eshell-posframe-buffer buffer)
  (apply #'posframe-show
         buffer
         :position (point)
         :poshandler eshell-posframe-poshandler
         :font eshell-posframe-font
         :override-parameters eshell-posframe-parameters
         :internal-border-width eshell-posframe-border-width
         :respect-header-line t
         :border-width eshell-posframe-border-width
         :border-color (face-attribute 'eshell-posframe-border :background nil t)
         ;; (funcall eshell-posframe-size-function)
         ))

;; (eshell-posframe-get-size)
(defun eshell-posframe-get-size ()
  "The default functon used by `eshell-posframe-size-function'."
  (list
   :width (or eshell-posframe-width (+ (window-width) 2))
   :height (or eshell-posframe-height)
   :min-height (or eshell-posframe-min-height
                   (let ((height 1))
                     (min height (or eshell-posframe-height height))))
   :min-width (or eshell-posframe-min-width
                  (let ((width (round (* (frame-width) 0.62))))
                    (min width (or eshell-posframe-width width))))))

(defun eshell-posframe-cleanup (orig-func)
  "Advice function of `eshell-cleanup'.

`eshell-cleanup' will call `bury-buffer' function, which
will let emacs minimize and restore when eshell close.

In this advice function, `burn-buffer' will be temp redefine as
`ignore', do nothing."
  (cl-letf (((symbol-function 'bury-buffer) #'ignore)
            ((symbol-function 'replace-buffer-in-windows) #'ignore))
    (funcall orig-func)
    (when (posframe-workable-p)
      (posframe-hide eshell-posframe-buffer))))

;;;###autoload
(defun eshell-posframe-enable ()
  "Enable eshell-posframe."
  (interactive)
  (advice-add 'eshell-cleanup :around #'eshell-posframe-cleanup)
  ;; (message "eshell-posframe is enabled.")
  (setq eshell-posframe-buffer "*eshell*<0>")
  (setq posframe-mouse-banish nil)
  (setq posframe-mouse-banish t)
  (with-selected-window
      (winum-get-window-by-number t--eshell-win)
    (setq t--posframe (apply #'posframe-show
                             eshell-posframe-buffer
                             :position (point)
                             :poshandler 'posframe-poshandler-window-top-left-corner
                             ;; :poshandler 'posframe-poshandler-window-center
                             ;; :poshandler 'posframe-poshandler-frame-center
                             :internal-border-width eshell-posframe-border-width
                             :respect-header-line t
                             :border-width eshell-posframe-border-width
                             :border-color (face-attribute 'eshell-posframe-border :background nil t)
                             :accept-focus t
                             ;; :string "test"
                             (funcall eshell-posframe-size-function)
                             ))
    )
  (setq t--parent-frame (selected-frame))
  (t--switch-frames t--posframe)
  (evil-goto-line)
  (end-of-line)
  (evil-insert-state)
  )

(defun t--switch-frames (frame)
  (select-frame frame)
  (x-focus-frame frame)
  )

(defun eshell-posframe-disable ()
  "Disable eshell-posframe"
  (interactive)
  (require 'eshell)
  (setq eshell-display-function #'eshell-default-display-buffer)
  (advice-remove 'eshell-cleanup  #'eshell-posframe-cleanup)
  (message "eshell-posframe is disabled."))

(provide 'eshell-posframe)

;; Local Variables:
;; coding: utf-8
;; End:

;;; eshell-posframe.el ends here

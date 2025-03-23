

(defun flycheck-add-overlay (err)
  "Add overlay for ERR.

Return the created overlay."
  ;; We must have a proper error region for the sake of fringe indication,
  ;; error display and error navigation, even if the highlighting is disabled.
  ;; We erase the highlighting later on in this case
  (pcase-let* ((`(,beg . ,end)
                (if (flycheck-relevant-error-other-file-p err)
                    ;; Display overlays for other-file errors on the first line
                    (cons (point-min)
                          (save-excursion (goto-char (point-min))
                                          (point-at-eol)))
                  (flycheck-error-region-for-mode
                   err (or flycheck-highlighting-mode 'lines))))
               (overlay (make-overlay beg end))
               (level (flycheck-error-level err))
               (category (flycheck-error-level-overlay-category level))
               (index (flycheck--next-overlay-index)))
				;; < this is the code i added
				(unless t-flycheck-enabled
					(setf (flycheck-error-message err) ""))
				;; >
    (unless (flycheck-error-level-p level)
      (error "Undefined error level: %S" level))
    (setf (overlay-get overlay 'flycheck-error-index) index)
    (setf (overlay-get overlay 'flycheck-overlay) t)
    (setf (overlay-get overlay 'flycheck-error) err)
    (setf (overlay-get overlay 'category) category)
    (setf (overlay-get overlay 'help-echo) #'flycheck-help-echo)
    (flycheck--setup-highlighting err overlay)
    overlay))

(setq t-flycheck-enabled nil)

(defun t-flycheck-disable-messages (&rest args)
		(setq t-flycheck-enabled t)
		(flycheck-pos-tip-mode 1)
		(setq t-flycheck-enabled nil)
		(if (display-graphic-p) (pos-tip-hide) (flycheck-hide-error-buffer))
		(flycheck-pos-tip-mode -1)
		)

(defun t-flycheck-enable-messages ()
		(setq t-flycheck-enabled t)
		(flycheck-pos-tip-mode 1)
		(flycheck-mode)
		(flycheck-mode)
		)

;; (setq flycheck-display-errors-delay 999.9)
;; (setq lsp-ui-sideline-delay 999.0)
;; (setq flycheck-display-errors-delay 0.9)
;; (setq lsp-ui-sideline-delay 0.2)
;; (setq flycheck-display-errors-function #'t-nil)
;; (setq flycheck-display-errors-function #'flycheck-display-error-messages)
;; (setq flycheck-process-error-functions nil)
;; (setq lsp-ui-sideline-enable t)
;; (setq lsp-ui-sideline-enable nil)

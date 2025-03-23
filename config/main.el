(setenv "DLA" t--comp-dir)
(setq main-right-base 1)
(setq t--help-win2         (+ main-right-base 3))
(setq t--help-win          (+ t--help-win2 1))
(setq t--messages-win      (+ main-right-base 0))
(setq t--backtrace-win     (+ main-right-base 0))

(setq main-left-base 4)
(setq t--refactor-win      (+ main-left-base 0))
(setq t--eshell-win        (+ main-left-base 4))
(setq t--error-win-scrap   1)
(setq t--helm-win          t--eshell-win)
(setq t--helm-win          nil)

(setq t-window-width 86)

(setq t--comp-buffer-name "*compilation*")
(setq t--log-buffer-name2 "*eww*")

(setq t--comp-mode "dla-python")
;; (setq t--comp-mode "dla-paper")
;; .......... pluralsuffix = 's'
(setq t--log-win2          (+ main-left-base 4))
(setq t--log-win2          nil)

(setq t--comp-win          (length (window-list)))
(setq helm-rg-default-glob-string "*.py")
(setq helm-rg-default-glob-string "")



(setq t--log-win          1)

;; (defvar t-comp-frame (selected-frame))
;; (frame-list)


;; ~/anaconda3/bin/python
;; (dired "/ssh:v38218@130.15.171.21:34275:")
(setq helm-tramp-custom-connections '(/ssh:v38218@130.15.171.21\#34275:/))

(setq t--error-win-main    (+ t--comp-win 1))

(cond
    (
        (string= t--comp-mode "dla-python")
        ;; (setq t--comp-dir "~/ntree")


        (setq t--logfile-fullname2 "~/dla/host/*outlog2*")
        ;; (setq t--comp-mode "code")

        )(
        (string= t--comp-mode "dla-paper")
        (setq t--comp-command "~/dla/article/compile")
        (setq t--comp-dir "~/dla/article")
        ;; (setq t--comp-mode "basic")
        ;; (setq t--comp-win          (+ main-left-base 0))
        ;; (setq t--log-win          nil)
        ;; (setq t--log-win2          nil)
        )
    ;; cond end
    )

;; FIXME
;; setting t--comp-win to 2 doesn't work

;; TODO
;; make key fn allows list of mode-maps input
;; error fun to wrap each init include file in, print file that failed
;; tests
;; open buffers from files: comp, help, outlog

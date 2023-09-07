;;; early-init.el -- Adam Miezianko's early Emacs initialization

;; Startup speed & annoyance suppression
(setq gc-cons-threshold 1000000)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

(setq frame-resize-pixelwise t)
(tool-bar-mode -1)
(setq default-frame-alist '((fullscreen . maximized)
                            (background-color . "#FFFFFF")
                            (vertical-scroll-bars . nil)
                            (horizontal-scroll-bars . nil)
                            (ns-appearance . light)))

;;; early-init.el -- Adam Miezianko's early Emacs initialization

;; Startup speed & annoyance suppression
(setq gc-cons-threshold 1000000)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

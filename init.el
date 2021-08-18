;;; --------
;;; Packages
;;; --------

;; I am rebuilding my Emacs config from scratch. Not using any packages, yet.
;; Keeping the package system initialized for future use.

;; Fixes TLS issues on macOS
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(require 'package)

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/")
             t)

(package-initialize)

;;; -----------
;;; Look & feel
;;; -----------

(setq inhibit-startup-message t)
(setq visual-bell t)

(scroll-bar-mode -1) ; Disable visible scrollbar
(tool-bar-mode -1) ; Disable the toolbar

;; Disable the menu bar. On macOS the menu bar is unobtrusive, so leave it be.
;; TODO: In the future, wrap this in an OS-specific conditional to remove the
;; menu bar on Windows and Linux.
; (menu-bar-mode -1)

;; Tooltips seem useful at the moment. They're not intrusive without a toolbar,
;; anyhow.
; (tooltip-mode -1)

(set-face-attribute 'default nil :font "Go Mono" :height 140)

(load-theme 'leuven t)

; disable arrow keys so I am forced to learn navigating using C-p C-n C-f and
; C-b
(global-unset-key (kbd "<left>"))
(global-unset-key (kbd "<right>"))
(global-unset-key (kbd "<up>"))
(global-unset-key (kbd "<down>"))

;;; --------
;;; Org-mode
;;; --------

;; Currently commented out as I rebuild my configuration.

; (require 'org)
; (define-key global-map "\C-cl" 'org-store-link)
; (define-key global-map "\C-ca" 'org-agenda)
; (setq org-log-done t)
; (setq org-agenda-files (list "~/memex/OrgTutorial.org"))

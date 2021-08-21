;;;; --------
;;;; Packages
;;;; --------

;; I am rebuilding my Emacs config from scratch. Not using any packages, yet.
;; Keeping the package system initialized for future use.

;; Fixes TLS issues on macOS
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(require 'package)

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/")
             t)

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;;; use-package allows for cleaner configuration of packages
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

;;; Causes use-package function to install packages not yet installed. Useful
;;; when running this init.el on a system for the first time.
(setq use-package-always-ensure t)

;;;; -----------
;;;; Look & Feel
;;;; -----------

(setq inhibit-startup-message t)
(setq visible-bell t)

(scroll-bar-mode -1) ; Disable visible scrollbar
(tool-bar-mode -1) ; Disable the toolbar

;;; Disable the menu bar. On macOS the menu bar is unobtrusive, so leave it be.
;;; TODO: In the future, wrap this in an OS-specific conditional to remove the
;;; menu bar on Windows and Linux.
;; (menu-bar-mode -1)

;;; Tooltips seem useful at the moment. They're not intrusive without a toolbar,
;;; anyhow.
;; (tooltip-mode -1)

(set-face-attribute 'default nil :font "Go Mono" :height 140)

;;; A reasonable, minimal syntax highlighting scheme.

(set-face-attribute 'font-lock-comment-face nil :foreground "#008000")
(set-face-attribute 'font-lock-string-face nil :foreground "#800000")
(set-face-attribute 'font-lock-constant-face nil :foreground "#800000")
(set-face-attribute 'font-lock-keyword-face nil :foreground "#000080")
(set-face-attribute 'font-lock-builtin-face nil :foreground "#000080")
(set-face-attribute 'font-lock-type-face nil :foreground "#000000")
(set-face-attribute 'font-lock-function-name-face nil :foreground "#000000"
		    :weight 'bold)
(set-face-attribute 'font-lock-variable-name-face nil :foreground "#000000"
		    :weight 'bold)

;; (load-theme 'leuven t)

;;; disable arrow keys so I am forced to learn navigating using:
;;; C-p C-n C-f and C-b
(global-unset-key (kbd "<left>"))
(global-unset-key (kbd "<right>"))
(global-unset-key (kbd "<up>"))
(global-unset-key (kbd "<down>"))

;;; Most of my code and documents should wrap at 80 columns.
(setq fill-column 80)

;;;; ---------
;;;; Evil-mode
;;;; ---------

;; (use-package evil
;;  :config
;;  (evil-mode 1))

;;;; --------
;;;; Ido-mode
;;;; --------

;;; Not sure whether to use helm, ivy or ido. Going with ido for now due to its
;;; position as a built-in.

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;;;; --------
;;;; Org-mode
;;;; --------

;;; Currently commented out as I rebuild my configuration.

;; (require 'org)
;; (define-key global-map "\C-cl" 'org-store-link)
;; (define-key global-map "\C-ca" 'org-agenda)
;; (setq org-log-done t)
;; (setq org-agenda-files (list "~/memex/OrgTutorial.org"))

;;;; ---------- 
;;;; Exeriments
;;;; ---------- 

;;; Elements I am still test driving or am unsure where they will end up.

(defun my-tab-width ()
  "Cycle tab-width between values 2, 4, and 8."
  (interactive)
  (setq tab-width
	(cond ((eq tab-width 8) 2)
	      ((eq tab-width 2) 4)
	      (t 8)))
  (redraw-display))

(global-set-key (kbd "C-c t") 'my-tab-width)

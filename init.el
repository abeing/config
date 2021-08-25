;;; init.el --- Emacs initialization
;;; Commentary:

;; I am rebuilding my Emacs config from scratch. I used to use spacemacs and
;; then Doom emacs but both of those were too different from my Emacs experience
;; in the 90s and early 00s. So, tabula rasa.

;;; Code:

(when (eq system-type 'darwin)
  ;; Fixes TLS issues on macOS
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none))

(require 'package)

(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; use-package allows for cleaner configuration of packages
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

;; Causes use-package function to install packages not yet installed. Useful
;; when running this init.el on a system for the first time.
(setq use-package-always-ensure t)

(setq inhibit-startup-message t)
(setq visible-bell t)

(scroll-bar-mode -1)
(tool-bar-mode -1)

(defalias 'yes-or-no-p 'y-or-n-p)

;; I seperate my sentences with one space not two.
(setq sentence-end-double-space nil)

(setq make-backup-files nil)

(set-face-attribute 'default nil :font "Go Mono" :height 140)

(load-theme 'leuven t)

(blink-cursor-mode -1)

(setq shift-select-mode nil)

(setq-default fill-column 75)

(show-paren-mode 1)

;; Emacs doesn't provide enough terminal support for pagers like less, but we
;; don't need pagers since we have a buffer. We can just use cat instead.
(setenv "PAGER" "/bin/cat")

(use-package w3m)

;;; ido-mode
(ido-mode 1)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)

;;; fido-mode
;; (fido-mode 1)

;;; Helm
(use-package helm)

(define-key emacs-lisp-mode-map
  (kbd "M-.") 'find-function-at-point)

(eldoc-mode 1)

;; rebinding M-i (tab-to-tab-stop) to something I use more often: imenu
(global-set-key (kbd "M-i") 'imenu)

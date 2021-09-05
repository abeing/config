;;; init.el --- Adam Miezianko's Emacs configuraiton
;;
;; Author: Adam Miezianko <adam.miezianko@gmail.com>

;; This file is not part of GNU Emacs

;;; Commentary:

;; I am rebuilding my Emacs config from scratch. I used to use spacemacs and
;; then Doom emacs but both of those were too different from my Emacs experience
;; in the 90s and early 00s. So, tabula rasa.

;;; Code:

(setq user-full-name "Adam Miezianko"
      user-mail-address "adam.miezianko@gmail.com")
(setq calendar-latitude 47.6062
      calendar-longitude -122.3321)

(defconst my/laptop-p (equal (system-name) "algos.lan"))

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


(scroll-bar-mode -1)
(tool-bar-mode -1)
(when (not (eq system-type 'darwin))
  (menu-bar-mode -1))

(setq inhibit-startup-message t)
(setq visible-bell t)

(defalias 'yes-or-no-p 'y-or-n-p)

(set-face-attribute 'default nil :font "Go Mono" :height 140)

(setq custom-safe-themes t)

(use-package zenburn-theme
  :config
  (load-theme 'zenburn t))

(when (eq system-type 'darwin)
  ;; Fixes TLS issues on macOS
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none))

;; I seperate my sentences with one space not two.
(setq sentence-end-double-space nil)

;; Change this to Sasha Chua's backup strategy of using a directory
(setq make-backup-files nil)

(global-hl-line-mode 1)

(blink-cursor-mode -1)

(setq shift-select-mode nil)

(setq-default fill-column 80)
(setq-default sentence-end-double-space nil)

(show-paren-mode 1)

;; Emacs doesn't provide enough terminal support for pagers like less, but we
;; don't need pagers since we have a buffer. We can just use cat instead.
(setenv "PAGER" "/bin/cat")

(ido-mode 1)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)

(use-package helm)

(define-key emacs-lisp-mode-map
  (kbd "M-.") 'find-function-at-point)

(eldoc-mode 1)

(use-package magit)

;; rebinding M-i (tab-to-tab-stop) to something I use more often: imenu
(global-set-key (kbd "M-i") 'imenu)

;; Goal column is handy (C-x C-n)
(put 'set-goal-column 'disabled nil)

;; Org-mode configuration

(setq org-agenda-files '("~/memex"))
(setq-default org-adapt-indentation 'headline-data)
(add-hook 'org-mode-hook 'turn-on-auto-fill)

(define-key global-map (kbd "C-c a") 'org-agenda)
(define-key global-map (kbd "C-c l") 'org-store-link)

(setq org-log-done t)

(use-package org-pomodoro
  :bind ("C-c p" . org-pomodoro))

(if my/laptop-p
    (setq-default python-shell-interpreter "/usr/local/bin/python3"))

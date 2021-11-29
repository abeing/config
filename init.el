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

(add-to-list 'initial-frame-alist '(fullscreen . fullheight))

(set-face-attribute 'default nil :font "Go Mono" :height 140)

(setq custom-safe-themes t)

(use-package tao-theme)

(use-package leuven-theme
  :config
  (setq-default org-fontify-whole-heading-line t)
  (load-theme 'leuven t))

(when (eq system-type 'darwin)
  ;; Fixes TLS issues on macOS
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none))

;; I seperate my sentences with one space not two.
(setq sentence-end-double-space nil)

;; Change this to Sasha Chua's backup strategy of using a directory
(setq make-backup-files nil)

;; (blink-cursor-mode -1)

(setq shift-select-mode nil)

(setq-default fill-column 80)
(setq-default sentence-end-double-space nil)

(show-paren-mode 1)

;; Emacs doesn't provide enough terminal support for pagers like less, but we
;; don't need pagers since we have a buffer. We can just use cat instead.
(setenv "PAGER" "/bin/cat")

(use-package counsel
  :config
  (ivy-mode 1))

(define-key emacs-lisp-mode-map
  (kbd "M-.") 'find-function-at-point)

(eldoc-mode 1)

(use-package magit)

;; rebinding M-i (tab-to-tab-stop) to something I use more often: imenu
(global-set-key (kbd "M-i") 'imenu)

;; Goal column is handy (C-x C-n)
(put 'set-goal-column 'disabled nil)

;; Org-mode configuration

(setq org-directory "~/memex")

(setq org-agenda-files '("~/memex"))

;; This is where capture will place new content by default
(setq org-default-notes-file (concat org-directory "/journal.org"))

(setq org-modules '(org-habit))

(setq-default org-habit-graph-column 60)
(setq org-habit-show-habits-only-for-today nil)

(setq org-feed-alist
      '(("Hacker News Front Page"
	 "https://hnrss.org/frontpage"
	 "~/memex/feeds.org" "Hacker News Front Page")
	("xkcd"
	 "https://xkcd.com/atom.xml"
	 "~/memex/feeds.org" "xkcd")))

(setq-default org-startup-indented t)
;; (setq-default org-adapt-indentation 'headline-data)
(setq-default org-adapt-indentation nil)

(add-hook 'org-mode-hook 'turn-on-auto-fill)

(define-key global-map (kbd "C-c c") 'org-capture)
(define-key global-map (kbd "C-c a") 'org-agenda)
(define-key global-map (kbd "C-c l") 'org-store-link)

(setq org-tag-alist '((:startgroup . nil)
		      ("size_large" . ?l)
		      ("size_uncertain" . ?u)
		      ("size_small" . ?s)
		      (:endgroup . nil)))

(setq org-log-done t)

(setq-default buffer-file-coding-system 'utf-8-unix)

(setq org-use-speed-commands t)

(use-package org-pomodoro
  :bind ("C-c p" . org-pomodoro))

;; Only show the highest-level TODO of a TODO tree
(setq org-agenda-todo-list-sublevels nil)

(setq org-agenda-diary-file "~/memex/journal.org")

(defun my/org-last-heading ()
  "Go to last visible org heading"
  (interactive)
  (progn (call-interactively 'end-of-buffer)
	 (call-interactively 'org-previous-visible-heading)))
(define-key global-map (kbd "C-c t") 'my/org-last-heading)

(if my/laptop-p
    (setq-default python-shell-interpreter "/usr/local/bin/python3"))

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/memex/roam")
  :bind
  (("C-c n l" . org-roam-buffer-toggle)
   ("C-c n f" . org-roam-node-find)
   ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))

(use-package diminish)

(use-package which-key
  :config
  (which-key-mode)
  (diminish 'which-key))

(use-package elpher)

(setq org-capture-templates
      (quote (
	      ("p" "org-protocol"
	      entry (file+headline "~/memex/reading.org" "Articles")
	      "* TODO %:description\n:PROPERTIES:\n:Link: %:link\n:END:\n%i\n\n"
	      :empty-lines-after 2
	      :immediate-finish t)
	      ("t" "todo"
	       entry (file+headline "~/memex/plan.org" "Inbox")
	       "* TODO %?")
	      )))


(server-start)
(require 'org-protocol)

(use-package evil)

(use-package markdown-mode)

(setq-default show-trailing-whitespace t)

(use-package rg
  :config
  (rg-enable-default-bindings))

(setq org-enforce-todo-dependencies t)

(setq-default indent-tabs-node nil)

(setq-default tab-always-indent 'complete)

;; (use-package powerline
;;  :config
;;  (powerline-default-theme))

(defun my/show-formfeed-as-line ()
  "Display formfeed ^L char as line."
  (interactive)
  (progn
    (when (not buffer-display-table)
      (setq buffer-display-table (make-display-table)))
    (aset buffer-display-table ?\^L
	  (vconcat (make-list 80 (make-glyph-code ?- 'font-lock-comment-face))))
    (redraw-frame)))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (scheme . t)))

(setq org-babel-python-command "python3")
(setq org-babel-scheme-command "mit-scheme")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-sexp-background-color "#efebe9")
 '(package-selected-packages
   '(modus-themes zenburn-theme which-key use-package tao-theme solarized-theme rg powerline poet-theme plan9-theme org-roam org-pomodoro nordless-theme nord-theme moe-theme markdown-mode magit leuven-theme gruvbox-theme gotham-theme flatui-theme evil elpher diminish cyberpunk-theme counsel color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

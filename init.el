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

(set-face-attribute 'default nil :font "Go Mono" :height 120)

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
 '(awesome-tray-mode-line-active-color "#0031a9")
 '(awesome-tray-mode-line-inactive-color "#d7d7d7")
 '(exwm-floating-border-color "#888888")
 '(flymake-error-bitmap '(flymake-double-exclamation-mark modus-themes-fringe-red))
 '(flymake-note-bitmap '(exclamation-mark modus-themes-fringe-cyan))
 '(flymake-warning-bitmap '(exclamation-mark modus-themes-fringe-yellow))
 '(hl-sexp-background-color "#efebe9")
 '(hl-todo-keyword-faces
   '(("HOLD" . "#70480f")
     ("TODO" . "#721045")
     ("NEXT" . "#5317ac")
     ("THEM" . "#8f0075")
     ("PROG" . "#00538b")
     ("OKAY" . "#30517f")
     ("DONT" . "#315b00")
     ("FAIL" . "#a60000")
     ("BUG" . "#a60000")
     ("DONE" . "#005e00")
     ("NOTE" . "#863927")
     ("KLUDGE" . "#813e00")
     ("HACK" . "#813e00")
     ("TEMP" . "#5f0000")
     ("FIXME" . "#a0132f")
     ("XXX+" . "#972500")
     ("REVIEW" . "#005a5f")
     ("DEPRECATED" . "#201f55")))
 '(ibuffer-deletion-face 'modus-themes-mark-del)
 '(ibuffer-filter-group-name-face 'modus-themes-pseudo-header)
 '(ibuffer-marked-face 'modus-themes-mark-sel)
 '(ibuffer-title-face 'default)
 '(org-src-block-faces 'nil)
 '(package-selected-packages
   '(bongo nov w3m modus-themes zenburn-theme which-key use-package tao-theme solarized-theme rg powerline poet-theme plan9-theme org-roam org-pomodoro nordless-theme nord-theme moe-theme markdown-mode magit leuven-theme gruvbox-theme gotham-theme flatui-theme evil elpher diminish cyberpunk-theme counsel color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized))
 '(pdf-view-midnight-colors '("#000000" . "#f8f8f8"))
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   '((20 . "#a60000")
     (40 . "#721045")
     (60 . "#8f0075")
     (80 . "#972500")
     (100 . "#813e00")
     (120 . "#70480f")
     (140 . "#5d3026")
     (160 . "#184034")
     (180 . "#005e00")
     (200 . "#315b00")
     (220 . "#005a5f")
     (240 . "#30517f")
     (260 . "#00538b")
     (280 . "#093060")
     (300 . "#0031a9")
     (320 . "#2544bb")
     (340 . "#0000c0")
     (360 . "#5317ac")))
 '(vc-annotate-very-old-color nil)
 '(xterm-color-names
   ["black" "#a60000" "#005e00" "#813e00" "#0031a9" "#721045" "#00538b" "gray65"])
 '(xterm-color-names-bright
   ["gray35" "#972500" "#315b00" "#70480f" "#2544bb" "#8f0075" "#30517f" "white"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(variable-pitch ((t (:family "Go")))))

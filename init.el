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

;; (require 'package)

(setq package-archives
    '(("gnu" . "http://elpa.gnu.org/packages/")
	("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; use-package allows for cleaner configuration of packages
;;(unless (package-installed-p 'use-package)
;;  (package-install 'use-package))

;; (require 'use-package)

;; Causes use-package function to install packages not yet installed. Useful
;; when running this init.el on a system for the first time.
;; (setq use-package-always-ensure t)


(scroll-bar-mode -1)
(tool-bar-mode -1)
(when (not (eq system-type 'darwin))
  (menu-bar-mode -1))

(setq inhibit-startup-message t)
(setq visible-bell t)

(defalias 'yes-or-no-p 'y-or-n-p)

(add-to-list 'initial-frame-alist '(fullscreen . fullheight))

;; (set-face-attribute 'default nil :font "Hack" :height 120)
(set-face-attribute 'default nil :family "Iosevka" :height 130)
;; (set-face-attribute 'variable-pitch nil :family "Source Sans Pro")
(set-face-attribute 'variable-pitch nil :family "Source Serif Pro" :height 1.1)

(require 'pulse)

(setq bongo-enabled-backends '(mpv vlc speexdec))

(setq custom-safe-themes t)

;;; Configure themes

(setq modus-themes-mode-line '(accented borderless))
(modus-themes-load-operandi)
(define-key global-map (kbd "<f5>") #'modus-themes-toggle)

(setq-default org-fontify-whole-heading-line t)

(when (eq system-type 'darwin)
  ;; Fixes TLS issues on macOS
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none))

;; I seperate my sentences with one space not two.
(setq-default sentence-end-double-space nil)

;; Change this to Sasha Chua's backup strategy of using a directory
(setq make-backup-files nil)

;; (blink-cursor-mode -1)

(setq shift-select-mode nil)

(setq-default fill-column 80)

(show-paren-mode 1)

;; save-place-mode causes Emacs to remember the point position for each file
(save-place-mode 1)

;; Emacs doesn't provide enough terminal support for pagers like less, but we
;; don't need pagers since we have a buffer. We can just use cat instead.
(setenv "PAGER" "/bin/cat")

;;(use-package counsel
;;  :config
;;  (ivy-mode 1))

;;(define-key emacs-lisp-mode-map
;;  (kbd "M-.") 'find-function-at-point)

;;(eldoc-mode 1)

;;(use-package magit)

;; rebinding M-i (tab-to-tab-stop) to something I use more often: imenu
(global-set-key (kbd "M-i") 'imenu)

;; Goal column is handy (C-x C-n)
(put 'set-goal-column 'disabled nil)

;;; Org-mode configuration
;;; ---------------------------------------------------------------------------

(setq org-directory "~/memex")

(setq org-agenda-files '("~/memex"))

;; This is where capture will place new content by default
(setq org-default-notes-file (concat org-directory "/inbox.org"))

(setq org-modules '(org-habit))

;; (setq-default org-habit-graph-column 60)
;; (setq org-habit-show-habits-only-for-today t)

;; (setq-default org-startup-indented t)
;; (setq-default org-adapt-indentation 'headline-data)
(setq-default org-adapt-indentation nil)

(add-hook 'org-mode-hook 'turn-on-auto-fill)
(add-hook 'org-mode-hook (lambda ()
			   (setq-local show-trailing-whitespace t)))

(require 'org-modern)

(modify-all-frames-parameters
 '((right-divider-width . 20)
   (internal-border-width . 10)))
(dolist (face '(window-divider
		window-divider-first-pixel
		window-divider-last-pixel))
  (face-spec-reset-face face)
  (set-face-foreground face (face-attribute 'default :background)))
(set-face-background 'fringe (face-attribute 'default :background))

(setq org-hide-emphasis-markers t
      org-pretty-entites t
      org-auto-align-tags nil
      org-tags-column 0
      org-ellipses "…"
      org-catch-invisible-edits 'show-and-error
      org-special-ctrl-a/e t
      org-insert-heading-respect-content t)

(add-hook 'org-mode-hook 'org-modern-mode)

(define-key global-map (kbd "C-c c") 'org-capture)
(define-key global-map (kbd "C-c a") 'org-agenda)
(define-key global-map (kbd "C-c l") 'org-store-link)

(setq org-log-done t)

(setq-default buffer-file-coding-system 'utf-8-unix)

(setq org-use-speed-commands t)

;;(use-package org-pomodoro
;;  :bind ("C-c p" . org-pomodoro))

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

;; (require 'evil-mode)

;; (evil-mode)

;;(use-package org-roam
;;  :init
;;  (setq org-roam-v2-ack t)
  ;; :custom
  ;; (org-roam-directory "~/memex/roam")
  ;; :bind
  ;; (("C-c n l" . org-roam-buffer-toggle)
  ;;  ("C-c n f" . org-roam-node-find)
  ;;  ("C-c n i" . org-roam-node-insert))
  ;; :config
  ;; (org-roam-setup))

;; (use-package diminish)

;; (use-package which-key
;;   :config
;;   (which-key-mode)
;;   (diminish 'which-key))

;; (use-package elpher)

(setq org-capture-templates
      '(("p" "org-protocol"
	 entry (file+headline "~/memex/reading.org" "Articles")
	 "* TODO %:description\n:PROPERTIES:\n:Link: %:link\n:END:\n%i\n\n"
	 :empty-lines-after 2
	 :immediate-finish t)
	("t" "Todo [inbox]" entry
	 (file+headline "~/memex/inbox.org" "Tasks")
	 "* TODO %i%?")
	("T" "Tickler" entry
	 (file+headline "~/memex/tickler.org" "Tickler")
	 "* %i%? \n %U")))

(setq org-refile-targets '(("~/memex/plan.org" :maxlevel . 3)
			   ("~/memex/someday.org" :level . 1)
			   ("~/memex/tickker.org" :maxlevel . 2)))

(setq org-todo-keywords
      '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))

(server-start)
(require 'org-protocol)

;; (use-package markdown-mode)

;; (use-package rg
;;  :config
;;  (rg-enable-default-bindings))

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

(require 'orderless)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (scheme . t)))

(setq langtool-java-classpath "/usr/share/languagetool:/usr/share/java/languagetool/*")
(require 'langtool)

(setq org-babel-python-command "python3")
(setq org-babel-scheme-command "mit-scheme")

;;; The Simple HTML Renderer (shr) is used by the Emacs Web Browser (EWW) and
;;; nov.el to render HTML. I want it to act mostly like reader mode.

(setq shr-use-colors nil)
(setq shr-use-fonts nil)
(setq shr-max-image-proportion 0.6)
(setq shr-width 72)

;;; nov.el for reading epubs

(require 'visual-fill-column)
(defun nov-mode-spacing ()
  (progn
    (setq line-spacing 0.3)
    (setq nov-text-width 72)
    (setq visual-fill-column-center-text t)
    (visual-line-mode)
    (visual-fill-column-mode)))
(add-hook 'nov-mode-hook 'nov-mode-spacing)

(defun my-nov-window-configuration-change-hook ()
  (my-nov-post-html-render-hook)
  (remove-hook 'window-configuration-change-hook
	       'my-nov-window-configuration-change-hook
	       t))

(defun my-nov-post-html-render-hook ()
  (if (get-buffer-window)
      (with-current-buffer (current-buffer)
	(goto-char (point-min))
	(while (not (eobp))
	  (when (looking-at "^[[:space:]]*$")
	    (kill-line)
	    (insert "    "))
	  (forward-line 1)))
    (add-hook 'window-configuration-change-hook
	      'my-nov-window-configuration-change-hook
	      nil t)))

(add-hook 'nov-post-html-render-hook 'my-nov-post-html-render-hook)

(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(visual-fill-column orderless bongo org-modern nov langtool elpher gemini-mode modus-themes markdown-mode magit evil decide)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

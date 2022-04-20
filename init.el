;;; init.el --- Adam Miezianko's Emacs configuraiton
;;
;; Author: Adam Miezianko <adam.miezianko@gmail.com>

;; This file is not part of GNU Emacs

;;; Commentary:

;; I am rebuilding my Emacs config from scratch. I used to use spacemacs and
;; then Doom emacs but both of those were too different from my Emacs experience
;; in the 90s and early 00s. So, tabula rasa.

;;; Code:

;;; ---------- User information ----------

(setq user-full-name "Adam Miezianko"
      user-mail-address "adam.miezianko@gmail.com")
(setq calendar-latitude 47.6062
      calendar-longitude -122.3321)

(defconst my/laptop-p (equal (system-name) "algos.lan"))

;;; ---------- Set up package.el ----------

(require 'package)

;; On macOS, fix an issue with TLS
(when (eq system-type 'darwin)
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))

(package-initialize)

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

;;; ---------- Use better defaults ----------

;; Don't use compiled code if its older than uncompiled code
(setq-default load-prefer-newer t)

;; Don't show the startup message/screen
(setq-default inhibit-startup-message t)

;; Don't put 'customize' config in init.el; git it another file
(setq-default custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; 72 is too narrow
(setq-default fill-column 80)

;; Don't use hard tabs.
(setq-default indent-tabs-mode nil)

;; Don't litter backup files everywhere. Contain them to a directory in .config
(setq-default backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))

;; Change yes/no questions to y/n instead
(defalias 'yes-or-no-p 'y-or-n-p)

;; On macOS, use Command as Meta, not Option
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none))

;; Delete trailing whitespace before saving a file
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Enable narrowing commands (C-x n)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

;; Enable goal column (C-x C-n)
(put 'set-goal-column 'disabled nil)

;; Display column number in addition to line number in mode line
(column-number-mode 1)

;; Automatically update buffers if file content on disk has changes
(global-auto-revert-mode t)

;; Don't show the menu bar, except on macOS. On macOS the menu bar doesn't take
;; up any additional screen real estate, so there's no harm in keeping it.
(when (not (eq system-type 'darwin))
  (menu-bar-mode -1))

;; Don't show the scroll bar or tool bar.
(scroll-bar-mode -1)
(tool-bar-mode -1)

(setq visible-bell t)

;; Allow Emacs to resize by pixel rather than character
(setq window-resize-pixelwise t)
(setq frame-resize-pixelwise t)

;;; ---------- Company mode ----------

(use-package company
  :bind (:map company-active-map
	      ("C-n" . company-select-next)
	      ("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0.3)
  (global-company-mode t))

;;; ---------- Completion ----------

(unless (package-installed-p 'vertico)
  (package-install 'vertico))

(vertico-mode t)

(unless (package-installed-p 'consult)
  (package-install 'consult))

(global-set-key [rebind switch-to-buffer] #'consult-buffer)

(setq read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t
      completion-ignore-case t)

;;; ---------- LSP support ----------

(unless (package-installed-p 'eglot)
  (package-install 'eglot))

(add-hook 'prog-mode-hook #'eglot-ensure)

(add-hook 'prog-mode-hook #'flymake-mode)

;;; ---------- Source control ----------

(unless (package-installed-p 'magit)
  (package-install 'magit))

(global-set-key (kbd "C-c g") #'magit-status)

(unless (package-installed-p 'diff-hl)
  (package-install 'diff-hl))

(add-hook 'prog-mode-hook #'diff-hl-mode)

;;; ---------- Markdown support ----------

(unless (package-installed-p 'markdown-mode)
  (package-install 'markdown-mode))

(line-number-mode 1)

(add-to-list 'initial-frame-alist '(fullscreen . fullheight))

(set-face-attribute 'default nil :family "Iosevka" :height 130)
(set-face-attribute 'variable-pitch nil :family "Source Serif Pro" :height 1.1)

(setq bongo-enabled-backends '(mpv vlc speexdec))

(setq custom-safe-themes t)

(load-theme 'modus-operandi t)
(modus-themes-load-operandi)
(define-key global-map (kbd "<f5>") #'modus-themes-toggle)

(setq-default org-fontify-whole-heading-line t)

;; I seperate my sentences with one space not two.
(setq-default sentence-end-double-space t)

(setq shift-select-mode nil)

(show-paren-mode 1)

;; save-place-mode causes Emacs to remember the point position for each file
(save-place-mode 1)

;; Emacs doesn't provide enough terminal support for pagers like less, but we
;; don't need pagers since we have a buffer. We can just use cat instead.
(setenv "PAGER" "/bin/cat")

;; rebinding M-i (tab-to-tab-stop) to something I use more often: imenu
(global-set-key (kbd "M-i") 'imenu)

;; ---------- Org-mode ----------

(setq org-directory "~/memex")

(setq org-agenda-files '("~/memex"))

;; This is where capture will place new content by default
(setq org-default-notes-file (concat org-directory "/inbox.org"))

(setq org-modules '(org-habit))

;; (setq-default org-startup-indented t)
;; (setq-default org-adapt-indentation 'headline-data)
(setq-default org-adapt-indentation nil)

(add-hook 'org-mode-hook 'turn-on-auto-fill)
(add-hook 'org-mode-hook (lambda ()
			   (setq-local show-trailing-whitespace t)))

;; TODO: See which I want to keep…
(setq org-hide-emphasis-markers t
      org-pretty-entites t
      org-auto-align-tags nil
      org-tags-column 0
      org-ellipses "…"
      org-catch-invisible-edits 'show-and-error
      org-special-ctrl-a/e nil
      org-insert-heading-respect-content t)

;; (add-hook 'org-mode-hook 'org-modern-mode)

(define-key global-map (kbd "C-c c") 'org-capture)
(define-key global-map (kbd "C-c a") 'org-agenda)
(define-key global-map (kbd "C-c l") 'org-store-link)

(setq org-log-done t)

(setq-default buffer-file-coding-system 'utf-8-unix)

(setq org-use-speed-commands t)

;; Only show the highest-level TODO of a TODO tree
(setq org-agenda-todo-list-sublevels nil)

(setq org-agenda-diary-file "~/memex/journal.org")

(defun my/org-last-heading ()
  "Go to last visible org heading"
  (interactive)
  (progn (call-interactively 'end-of-buffer)
	 (call-interactively 'org-previous-visible-heading)))
(define-key global-map (kbd "C-c t") 'my/org-last-heading)

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

(use-package org-modern
  :hook org-mode)
(use-package olivetti
  :hook org-mode)
(use-package org-pomodoro
  :bind
  (("C-c p" . org-pomodoro)))

;; ────────────────────────────────── Org-roam ──────────────────────────────────

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

;; (use-package diminish)

;; (use-package which-key
;;   :config
;;   (which-key-mode)
;;   (diminish 'which-key))

;; (use-package elpher)


;;; Elfeed --

(setq elfeed-feeds
      '(("https://pluralistic.net/feed/" privacy)
	("https://www.rockpapershotgun.com/feed" games)
	("https://yourlocalepidemiologist.substack.com/feed" covid)
	("https://musicforprogramming.net/rss.xml" music)))

;;; Emacs server

(server-start)
(require 'org-protocol)

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

(use-package orderless)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (scheme . t)))

(if my/laptop-p
    (setq-default python-shell-interpreter "/usr/local/bin/python3"))

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
  "Spacing for nov.el mode."
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

;;; init.el ends here

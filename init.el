;;; init.el --- Adam Miezianko's Emacs configuraiton
;;
;; Author: Adam Miezianko <adam.miezianko@gmail.com>

;; This file is not part of GNU Emacs

;;; Commentary:

;; I am rebuilding my Emacs config from scratch.  I used to use spacemacs and
;; then Doom Emacs but both of those were too different from my Emacs experience
;; in the 90s and early 00s.  So, tabula rasa.

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

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

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

(line-number-mode 1)

(add-to-list 'initial-frame-alist '(fullscreen . fullheight))

(set-face-attribute 'default nil :family "Iosevka" :height 150)

;;; ---------- Completion ----------

;; (icomplete-mode)

(when (not (package-installed-p 'vertico))
  (package-refresh-contents)
  (package-install 'vertico))
(require 'vertico)
(vertico-mode)

;;; ---------- Theme ----------

(when (not (package-installed-p 'modus-themes))
  (package-refresh-contents)
  (package-install 'modus-themes))

(when (not (package-installed-p 'ef-themes))
  (package-refresh-contents)
  (package-install 'ef-themes))

(setq modus-themes-bold-constructs t
      modus-themes-italic-constructs t
      modus-themes-links nil
      modus-themes-mode-line 'accented
      modus-themes-markup '(bold)
      modus-themes-org-blocks 'background)

(setq org-fontify-quote-and-verse-blocks t)

;; (load-theme 'modus-operandi)
;; (define-key global-map (kbd "<f5>") #'modus-themes-toggle)
(ef-themes-load-random 'autumn)

;;; ---------- Other ----------


;; I seperate my sentences with one space not two.
(setq-default sentence-end-double-space nil)

(setq shift-select-mode nil)

(show-paren-mode 1)

;; save-place-mode causes Emacs to remember the point position for each file
(save-place-mode 1)

;; (savehist-mode t)
;; (recentf-mode t)

;; Emacs doesn't provide enough terminal support for pagers like less, but we
;; don't need pagers since we have a buffer. We can just use cat instead.
(setenv "PAGER" "/bin/cat")

;; rebinding M-i (tab-to-tab-stop) to something I use more often: imenu
(global-set-key (kbd "M-i") 'imenu)

;;; Langtool

(setq langtool-language-tool-jar "/usr/local/opt/languagetool/libexec/languagetool-commandline.jar")

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

(define-key global-map (kbd "C-c c") 'org-capture)
(define-key global-map (kbd "C-c a") 'org-agenda)
(define-key global-map (kbd "C-c l") 'org-store-link)
(define-key global-map (kbd "C-c p") 'org-pomodoro)

(setq org-startup-indented t)
(setq org-pretty-entities t)
(setq org-hide-emphasis-markers t)

(setq-default buffer-file-coding-system 'utf-8-unix)

(setq org-use-speed-commands t)

;; Only show the highest-level TODO of a TODO tree
(setq org-agenda-todo-list-sublevels nil)

(setq org-agenda-diary-file "~/memex/journal.org")

(defun my/org-last-heading ()
  "Go to last visible org heading."
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
			   ("~/memex/tickler.org" :maxlevel . 2)))

;;; Bongos

(when (not (package-installed-p 'bongo))
  (package-install 'bongo))

;;; Emacs server

(server-start)
(require 'org-protocol)

(setq org-enforce-todo-dependencies t)

(setq org-log-done t)

(setq-default indent-tabs-node nil)

(setq-default tab-always-indent 'complete)

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

(if my/laptop-p
    (setq-default python-shell-interpreter "/usr/local/bin/python3"))

(setq org-babel-python-command "python3")
(setq org-babel-scheme-command "mit-scheme")

;; denote

(when (not (package-installed-p 'denote))
  (package-refresh-contents)
  (package-install 'denote))
(require 'denote)

(setq denote-directory (expand-file-name "~/memex"))

(define-key global-map (kbd "C-c n r") #'denote-dired-rename-file)
(define-key global-map (kbd "C-c n n") #'denote-create-note)
(define-key global-map (kbd "C-c n l") #'denote-link-insert-link)

;;; Logos narrowing

(when (not (package-installed-p 'logos))
  (package-refresh-contents)
  (package-install 'logos))
(require 'logos)
(setq logos-outlines-are-pages t)
(setq logos-outline-regexp-alist
      `((emacs-lisp-mode . "^;;;+ ")
        (org-mode . "^\\*+ +")
        (t . ,(or outline-regexp logos--page-delimiter))))
(define-key global-map (kbd "C-x n l") #'logos-narrow-dwim)

;;; init.el ends here

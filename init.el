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

;;; ---------- Package management  ----------

(require 'package)

;; On macOS, fix an issue with TLS
(when (eq system-type 'darwin)
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-archive-priorities '(("melpa" . 100)
                                   ("gnu" . 50)
                                   ("nongnu" . 25)))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package use-package
  :init
  (setq use-package-always-ensure t)
  (use-package use-package-ensure-system-package
    :ensure t))

;;; ---------- Laptop-specific settings ----------

(when my/laptop-p
  (setq ispell-program-name "/usr/local/bin/ispell"))

;;; ---------- Use better defaults ----------

(setq-default
 inhibit-startup-screen t
 initial-scratch-message nil ; The *scratch* buffer doesn't need to comment on top
 indent-tabs-mode nil        ; Don't use tabs, ever!
 tab-width 2                 ; The number of spaces a tab is equal to
 fill-column 78              ; Wrap at 78; 72 was too narrow
 column-number-mode t        ; Display column number in the mode line
 vc-follow-symlinks t        ; Follow symlinks without asking
 ring-bell-function nil)     ; Don't ding

(savehist-mode t)             ; Save the minibuffer history
(show-paren-mode)             ; Highlight matching parenthesis
(save-place-mode)             ; Remember the point position for each file
(delete-selection-mode)       ; Replace selection when typing
(prefer-coding-system 'utf-8) ; Default to UTF-8 encoding

;; Don't use compiled code if its older than uncompiled code
(setq-default load-prefer-newer t)

;; Don't put 'customize' config in init.el; git it another file
(setq-default custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

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
(add-to-list 'default-frame-alist '(width . 177))

;; Font

(set-face-attribute 'default nil :family "Iosevka" :height 140)

;;; ---------- Completion ----------

(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t))

(use-package orderless
  :custom
  (completion-styles '(orderless)))

(use-package marginalia
  :init
  (marginalia-mode)
  :custom
  (marginalia-align 'right))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)))




;;; ---------- Pulsar ----------

(use-package pulsar
  :init
  (setq pulsar-pulse t
        pulsar-delay 0.055
        pulsar-iterations 10
        pulsar-face 'pulsar-magenta
        pulsar-highlight-face 'pulsar-yellow)
  (pulsar-global-mode 1))

;;; ---------- Other ----------

;; I seperate my sentences with one space not two.
(setq-default sentence-end-double-space nil)

(setq shift-select-mode nil)

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

;; This should not be necessary with (prefer-coding-system 'utf-8) above
;; (setq-default buffer-file-coding-system 'utf-8-unix)

(setq org-use-speed-commands t)
(setq org-fontify-whole-heading-line t)
(setq org-fontify-quote-and-verse-blocks t)
(setq org-startup-indented t)

;; Only show the highest-level TODO of a TODO tree
(setq org-agenda-todo-list-sublevels t)

(setq org-todo-keywords '((type "TODO" "WAITING" "|" "DONE")))

(setq org-agenda-diary-file "~/memex/journal.org")

(setq org-log-into-drawer t)

(setq org-hierarchical-todo-statistics nil)

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
	 (file+headline "~/memex/inbox.org" "Task Inbox")
	 "* TODO %i%?")
	("T" "Tickler" entry
	 (file+headline "~/memex/tickler.org" "Tickler")
	 "* %i%? \n %U")))

(setq org-refile-targets
      '(("~/memex/todo.org" :level . 1)
			  ("~/memex/someday.org" :level . 1)
			  ("~/memex/tickler.org" :maxlevel . 2)))

;;; ---------- Theme ----------

;; Aesthetic and subjective look-and-feel choices.

(use-package ef-themes
  :ensure t
  :init
  (ef-themes-select 'ef-autumn))

;;; ---------- Elfeed ----------

(use-package elfeed
  :ensure t
  :init
  (setq elfeed-feeds '(("https://pluralistic.net/feed/" tech)
                       ("https://yourlocalepidemiologist.substack.com/feed" health)
                       ("https://news.ycombinator.com/rss")
                       ("https://www.reddit.com/r/Fantasy/.rss")
                       ("https://nitter.net/orangebook_/rss")
                       ("https://lobste.rs/rss"))))

;;; ---------- Olivetti ----------

(use-package olivetti
  :hook ((org-mode          . olivetti-mode)
         (nov-mode          . olivetti-mode)
         (markdown-mode     . olivetti-mode)
         (mu4e-view-mode    . olivetti-mode)
         (elfeed-show-mode  . olivetti-mode)
         (mu4e-compose-mode . olivetti-mode))
  :custom
  (olivetti-body-width 85))

;;; ---------- Projectil ----------

(use-package projectile
  :init
  (projectile-mode)
  :bind
  ("C-c p" . projectile-command-map))

;;; ---------- Nov ----------

(use-package nov
  :mode ("\\.epub\\'" . nov-mode)
  :preface
  (defun adam/nov-font-setup ()
    (face-remap-add-relative 'variable-pitch
                             :family "Iosevka"
                             :height 210)
    (setq line-spacing 0.15))
  :hook (nov-mode . 'adam/nov-font-setup)
  :custom
  (nov-text-width t))

;;; ---------- Mastodon ----------

(use-package mastodon
  :ensure t
  :config
  (setq mastodon-instance-url "https://fosstodon.org")
  (setq mastodon-active-user "aephos"))

;;; ---------- Bongo ----------

(use-package bongo
  :ensure t)

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

;; ---------- Denote ----------

(use-package denote
  :after org
  :bind (("C-c n r" . denote-rename-file)
         ("C-c n n" . denote-create-note)
         ("C-c n l" . denote-link-insert-link))
  :hook (dired-mode . denote-dired-mode)
  :custom
  (denote-sort-keywords t)
  (denote-directory (concat org-directory "/"))
  (denote-known-keywords '("literature", "idea", "project", "index")))

;;; ----------=[ Magit ]=--------------------------------------------------------

(use-package magit
  :ensure t)

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

;;; ----------=[ evil-mode ]=---------------------------------------------------

(use-package evil
  :ensure t
  :bind (("<spc> t" . org-capture)))

;;; init.el ends here

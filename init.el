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

(defconst my/laptop-p (equal (system-name) "algos.local"))

;;; ---------- Package management  ----------

(require 'package)

;; On macOS, fix an issue with TLS
(when (eq system-type 'darwin)
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-archive-priorities '(("mela" . 100)
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

(set-face-attribute 'default nil :family "Iosevka" :height 160)

(setq shr-width 80)

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

(use-package company)

;;; ---------- Timer ----------

(use-package tmr)

(defun am/pomodoro (task)
  "Start a Pomodoro"
  (interactive "sTask: ")
  (tmr-with-description "25m" task))

(defun am/brew-hojicha ()
  "Brew hojicha"
  (interactive)
  (tmr-with-description "3m" "Hojicha"))

(global-set-key (kbd "C-c t p") 'am/pomodoro)
(global-set-key (kbd "C-c t g") 'am/brew-hojicha)
(global-set-key (kbd "C-c t t") 'tmr-tabulated-view)


;;; ---------- Keyboard use ----------

(use-package which-key
  :init
  (which-key-mode))

;;; ---------- Pulsar ----------

(use-package pulsar
  :init
  (setq pulsar-pulse t
        pulsar-delay 0.055
        pulsar-iterations 10)
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

(use-package org
  :init
  (setq org-startup-indented t
        org-fontify-todo-headline nil
        org-fontify-done-headline nil))


(setq org-directory "~/memex")

(setq org-agenda-files '("~/memex"))

;; This is where capture will place new content by default
(setq org-default-notes-file (concat org-directory "/inbox.org"))

(setq org-modules '(org-habit))

(add-hook 'org-mode-hook 'turn-on-auto-fill)
(add-hook 'org-mode-hook (lambda ()
			                     (setq-local show-trailing-whitespace t)))

(define-key global-map (kbd "C-c c") 'org-capture)
(define-key global-map (kbd "C-c a") 'org-agenda)
(define-key global-map (kbd "C-c l") 'org-store-link)

(setq org-pretty-entities t)
(setq org-hide-emphasis-markers t)

;; This should not be necessary with (prefer-coding-system 'utf-8) above
;; (setq-default buffer-file-coding-system 'utf-8-unix)

(setq org-fontify-whole-heading-line t)
(setq org-fontify-quote-and-verse-blocks t)

;; Only show the highest-level TODO of a TODO tree
;; (setq org-agenda-todo-list-sublevels t)

;; (setq org-todo-keywords '((type "TODO" "WAITING" "|" "DONE")))

;; (setq org-enforce-todo-dependencies t)

(setq org-log-done t)

;; (setq org-agenda-diary-file "~/memex/journal.org")

(setq org-log-into-drawer t)

(setq org-hierarchical-todo-statistics nil)

(defun my/org-last-heading ()
  "Go to last visible org heading."
  (interactive)
  (progn (call-interactively 'end-of-buffer)
	 (call-interactively 'org-previous-visible-heading)))
;; (define-key global-map (kbd "C-c t") 'my/org-last-heading)

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
			  ("~/memex/tickler.org" :level . 1)))

;;; ---------- Flycheck ----------

(use-package flycheck)

;;; ---------- EMMS ----------

(use-package emms
  :init
  (emms-all)
  (emms-default-players))

;;; ---------- Theme ----------

(use-package modus-themes
  :init
  (setq modus-themes-disable-other-themes t
        modus-themes-org-blocks 'gray-background
        modus-themes-to-toggle '(modus-operandi modus-vivendi)
        modus-themes-italic-constructs t
        modus-themes-bold-constructs t)
  (load-theme (car modus-themes-to-toggle) t)
  :bind ("<f5>" . modus-themes-toggle))

;;; ---------- Roam ----------

(use-package org-roam
  :config
  (setq org-roam-directory "~/memex/roam"
        org-roam-index-file "~/memex/roam/index.org"))



;;; ---------- Elfeed ----------

(use-package elfeed
  :ensure t
  :init
  (setq elfeed-feeds '(("https://pluralistic.net/feed/" tech)
                       ("https://yourlocalepidemiologist.substack.com/feed" health)
                       ("https://lobste.rs/rss" tech)
                       ("https://sachachua.com/blog/category/emacs-news/feed" tech)
                       ("https://xkcd.com/atom.xml" comic)
                       ("https://protesilaos.com/master.xml" tech)
                       ("https://jvns.ca/atom.xml" tech)
                       ("https://jamesclear.com/rss" life)
                       ("https://www.davidrevoy.com/feed/en/rss" comic))))

;;; ---------- Markdown ----------

(use-package markdown-mode
  :init
  (setq markdown-enable-wiki-links t))

;;; ---------- Nov ----------

(use-package nov
  :mode ("\\.epub\\'" . nov-mode))

;;; Emacs server

(server-start)
(require 'org-protocol)

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
         ("C-c n l" . denote-link-insert-link)
         ("C-c n f" . denote-open-or-create))
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

;;; init.el ends here

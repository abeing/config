;;; init.el --- Adam Miezianko's Emacs configuraiton

;; Author: Adam Miezianko <adam.miezianko@gmail.com>

;; This file is not part of GNU Emacs

;;; Commentary:

;; I am rebuilding my Emacs config from scratch.  I used to use spacemacs and
;; then Doom Emacs but both of those were too different from my Emacs experience
;; in the 90s and early 00s.  So, tabula rasa.

;;; Code:


;;; --------------------[ User information ]------------------------------------

(setq user-full-name "Adam Miezianko"
      user-mail-address "adam.miezianko@gmail.com")
(setq calendar-latitude 47.6062
      calendar-longitude -122.3321)

;; Is Emacs running on my laptop? Used for setting laptop-specific settings
;; where necessary.
(defconst my-laptop-p (eq system-type 'darwin))
(defconst my-work-machine-p (eq system-type 'windows-nt))

;;; --------------------[ Package management ]----------------------------------

(require 'package)

;; On macOS, fix an issue with TLS. Is this still necessary?
(when my-laptop-p
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


;;; ---------- Laptop-specific settings ----------

(when my-laptop-p
  (setq ispell-program-name "/usr/local/bin/ispell")
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none))


;;; --------------------[ General settings ]------------------------------------

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
(electric-pair-mode t)        ; When entering a character with a natural pair,
                              ; insert it's corresponding pair

;; Don't use compiled code if its older than uncompiled code
(setq-default load-prefer-newer t)

;; Don't put 'customize' config in init.el; give it another file
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; Don't litter backup files everywhere. Contain them to a directory in .config
(setq-default backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))

;; Change yes/no questions to y/n instead
(defalias 'yes-or-no-p 'y-or-n-p)

;; Delete trailing whitespace before saving a file
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Enable narrowing commands (C-x n)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

;; Enable goal column (C-x C-n)
(put 'set-goal-column 'disabled nil)

;; Automatically update buffers if file content on disk has changes
(setq auto-revert-interval 3
      auto-revert-check-vc-info t)
(global-auto-revert-mode t)

;; Don't show the menu bar, except on macOS. On macOS the menu bar doesn't take
;; up any additional screen real estate, so there's no harm in keeping it.
(when (not my-laptop-p)
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

(set-face-attribute 'default nil :family "Iosevka" :height 160)

(setq shr-width 80)

;; I seperate my sentences with one space not two.
(setq-default sentence-end-double-space nil)

(setq shift-select-mode nil)

;; Emacs doesn't provide enough terminal support for pagers like less, but we
;; don't need pagers since we have a buffer. We can just use cat instead.
(setenv "PAGER" "/bin/cat")

;; rebinding M-i (tab-to-tab-stop) to something I use more often: imenu
(global-set-key (kbd "M-i") 'imenu)


;;; --------------------[ Completion ]------------------------------------------

(use-package vertico
  :ensure t
  :init
  (fido-mode 0)
  (vertico-mode))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

(use-package corfu
  :ensure t
  :config
  (global-corfu-mode))

(use-package corfu-popupinfo
  :ensure nil
  :after corfu
  :hook (corfu-mode . corfu-popupinfo-mode)
  :custom
  (corfu-popupinfo-delay '(0.25 . 0.1))
  (corfu-popupinfo-hide nil)
  :config
  (corfu-popupinfo-mode))

(use-package kind-icon
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package consult
  :ensure t
  :bind (("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("C-s" . consult-line)))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless)))

;;; --------------------[ Timers ]----------------------------------------------

(use-package tmr
  :ensure t
  :custom
  (tmr-sound-file nil))

(defun start-pomodoro (task)
  "Start a Pomodoro"
  (interactive "sTask: ")
  (tmr-with-description "25m" task))

(defun start-short-break ()
  "Start a short break"
  (interactive)
  (tmr-with-description "5m" "Short break"))

(defun brew-hojicha ()
  "Brew hojicha"
  (interactive)
  (tmr-with-description "3m" "Hojicha"))

(global-set-key (kbd "C-c t p") 'start-pomodoro)
(global-set-key (kbd "C-c t b") 'start-short-break)
(global-set-key (kbd "C-c t g") 'brew-hojicha)
(global-set-key (kbd "C-c t t") 'tmr-tabulated-view)


;;; ---------- Keyboard use ----------

(use-package which-key
  :ensure t
  :init
  (which-key-mode))


;;; --------------------[ Pulsar ]----------------------------------------------

;; This performs poorly on Windows. I should consider creating something like
;; 'my-work-machine-p to do some conditional configuration on Windows.

(when (not my-work-machine-p)
  (use-package pulsar
    :ensure t
    :init
    (setq pulsar-pulse t
          pulsar-delay 0.055
          pulsar-iterations 10)
    (pulsar-global-mode 1)))


;; --------------------[ Org-mode ]---------------------------------------------

(use-package org
  :init
  (setq org-hide-emphasis-markers t
        org-log-done t
        org-log-into-drawer t
        org-todo-keywords '((sequence "TODO(t)" "WAIT(w)" "PROJ(p)" "|" "DONE(d)" "CNCL(c)"))))

(setq org-directory "~/memex")
(setq org-agenda-files '("~/memex"))

;; This is where capture will place new content by default
(setq org-default-notes-file (concat org-directory "/inbox.org"))

(setq org-modules '(org-habit org-protocol))

(add-hook 'org-mode-hook 'turn-on-auto-fill)
(add-hook 'org-mode-hook (lambda ()
			                     (setq-local show-trailing-whitespace t)))

(define-key global-map (kbd "C-c c") 'org-capture)
(define-key global-map (kbd "C-c a") 'org-agenda)
(define-key global-map (kbd "C-c l") 'org-store-link)

(setq org-pretty-entities t)
(setq org-fontify-quote-and-verse-blocks t)

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

;;; --------------------[ EMMS ]------------------------------------------------

;; I go back and forth between using EMMS and bongo but am considering using
;; Elsa or something else instead.

(use-package emms
  :ensure t
  :init
  (emms-all)
  (emms-default-players))


;;; --------------------[ Themes ]----------------------------------------------

(use-package modus-themes
  :ensure t
  :init
  (setq modus-themes-disable-other-themes t
        modus-themes-org-blocks 'gray-background
        modus-themes-to-toggle '(modus-operandi modus-vivendi)
        modus-themes-italic-constructs t
        modus-themes-bold-constructs t)
  (modus-themes-load-operandi)
  :bind ("<f5>" . modus-themes-toggle))

;;; --------------------[ Markdown ]--------------------------------------------

(use-package markdown-mode
  :ensure t
  :init
  (setq markdown-enable-wiki-links t))

;;; Emacs server

(server-start)
(require 'org-protocol)

(setq-default tab-always-indent 'complete)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (scheme . t)))

(when my-laptop-p
  (setq python-shell-interpreter "/usr/local/bin/python3"))

(setq org-babel-python-command "python3")
(setq org-babel-scheme-command "mit-scheme")

;; --------------------[ Denote ]-----------------------------------------------

(use-package denote
  :ensure t
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


;;; --------------------[ Magit ]-----------------------------------------------

(use-package magit
  :ensure t)

;;; --------------------[ Useful functions ]------------------------------------

(defun my-fill-to-eol (char)
  "Fill a character from point until column 80."
  (interactive "cChar: ")
  (insert-char char 80)
  (move-to-column 80)
  (kill-line))

;;; init.el ends here

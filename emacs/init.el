;;; init.el --- Adam Miezianko's Emacs configuraiton

;; Author: Adam Miezianko <adam.miezianko@gmail.com>

;; This file is not part of GNU Emacs

;;; Commentary:

;; I keep removing configuration from my init.el as Emacs gets more and more sane defaults.

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

;;; ---------- Laptop-specific settings ----------

(when my-laptop-p
  (setq ispell-program-name "/usr/local/bin/ispell")
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none))

;;; --------------------[ Packages ]--------------------------------------------

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

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

;; Make right-click do something sensible
(when (display-graphic-p)
  (context-menu-mode))

;; Delete trailing whitespace before saving a file
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Enable narrowing commands (C-x n)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

;; Enable goal column (C-x C-n)
(put 'set-goal-column 'disabled nil)

;; Automatically update buffers if file content on disk has changes
(setq auto-revert-interval 1)
(setq auto-revert-check-vc-info t)
(global-auto-revert-mode t)

;; Don't show the menu bar, except on macOS. On macOS the menu bar doesn't take
;; up any additional screen real estate, so there's no harm in keeping it.
(when (not my-laptop-p)
  (menu-bar-mode -1))

(setq visible-bell t)

(line-number-mode 1)

(set-face-attribute 'default nil :family "Iosevka" :height 140)

(setq shr-width 80)

;; I usually seperate my sentences with one space not two, but am
;; experimenting with being a two-spacer.
(setq-default sentence-end-double-space t)

(setq shift-select-mode nil)

;; Emacs doesn't provide enough terminal support for pagers like less, but we
;; don't need pagers since we have a buffer. We can just use cat instead.
(setenv "PAGER" "/bin/cat")

;; rebinding M-i (tab-to-tab-stop) to something I use more often: imenu
(global-set-key (kbd "M-i") 'imenu)

;;; --------------------[ Diminish ]--------------------------------------------

(use-package diminish
  :ensure t)

;;; --------------------[ Avy ]-------------------------------------------------

(use-package avy
  :ensure t
  :bind (("C-c g g" . avy-goto-char)
         ("C-c g w" . avy-goto-word-0)
         ("C-c g l" . avy-goto-line)
         ("C-c g c" . avy-goto-char-timer)))

;;; --------------------[ Eglot ]-----------------------------------------------

(use-package eglot
  :ensure t

  :hook
  ((rust-mode . rust-ts-mode))
  :bind (("C-c g e" . flymake-goto-next-error))
  :custom
  (eglot-send-changes-idle-time 0.1))

;;; --------------------[ Completion ]------------------------------------------

(use-package vertico
  :ensure t
  :init
  (fido-mode 0)
  (vertico-mode))

(use-package vertico-directory
  :ensure nil
  :after vertico
  :bind (:map vertico-map
              ("M-DEL" . vertico-directory-delete-word)))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :bind
  (:map corfu-map
        ("SPC" . corfu-insert-separator)
        ("C-n" . corfu-next)
        ("C-p" . corfu-previous)))

(use-package corfu-popupinfo
  :ensure nil
  :after corfu
  :hook (corfu-mode . corfu-popupinfo-mode)
  :custom
  (corfu-popupinfo-delay '(0.25 . 0.1))
  (corfu-popupinfo-hide nil)
  :config
  (corfu-popupinfo-mode))

(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

(use-package kind-icon
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package consult
  :ensure t
  :bind (("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("C-s" . consult-line)
         :map org-mode-map
         ("C-c C-j" . consult-org-heading)))

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


;;; ;;; --------------------[ Keyboard ]----------------------------------------

(use-package which-key
  :ensure t
  :diminish
  :config
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


;;; --------------------[ Remark ]----------------------------------------------

(use-package org-remark
  :ensure t
  :bind (("C-c r m" . org-remark-mark)
         ("C-c r o" . org-remark-open)
         ("C-c r n" . org-remark-view-next)
         ("C-c r p" . org-remark-view-prev)))

;; --------------------[ Org-mode ]---------------------------------------------

(defun fold-done-entries ()
  "Fold all enteries marked DONE."
  (interactive)
  (save-excursion
    (goto-char (point-max))
    (while (outline-previous-heading)
      (when (org-entry-is-done-p)
        (hide-subtree)))))

(use-package org
  :init
  (setq org-hide-emphasis-markers t
        org-log-done t
        org-log-into-drawer t
        org-adapt-indentation nil
        org-todo-keywords '((sequence "TODO(t)" "WAIT(w)" "PROJ(p)" "|" "DONE(d)" "CNCL(c)")))
  :hook
  (org-mode . org-indent-mode)
  (org-mode . fold-done-entries))


(setq org-directory "~/memex")
;; (setq org-agenda-files `(,org-directory))
(setq org-agenda-files (nconc
                        '("gtd.org")
                        (directory-files-recursively org-directory ".*_area.*\.org$")
                        (directory-files-recursively org-directory ".*_project.*\.org$")))

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
	       (file+headline "~/memex/gtd.org" "Inbox")
	       "* TODO %i%?")
	      ("T" "Tickler" entry
	       (file+headline "~/memex/gtd.org" "Tickler")
	       "* %i%? \n %U")
        ("w" "Weight" table-line
         (file+olp "~/memex/health.org" "Weight" "Data")
         "| %U | %? | " :unnarrowed t)))

(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))

;;; --------------------[ EMMS ]------------------------------------------------

;; I go back and forth between using EMMS and bongo but am considering using
;; Elsa or something else instead.

(use-package emms
  :ensure t
  :init
  (emms-all)
  (setq emms-info-functions '(emms-info-native
                              emms-info-metaflac
                              emms-info-ogginfo))
  (emms-default-players)
  :bind (("C-c m p" . emms-pause)
         ("C-c m m" . emms)
         ("C-c m r" . emms-random)
         ("C-c m v" . emms-volume-minor-mode)))

;;; --------------------[ Themes ]----------------------------------------------

(use-package modus-themes
  :ensure t
  :init
  (setq modus-themes-disable-other-themes t
        modus-themes-mode-line '(borderless accented)
        modus-themes-org-blocks 'gray-background
        modus-themes-to-toggle '(modus-operandi modus-vivendi)
        modus-themes-italic-constructs t
        modus-themes-bold-constructs t)
  (load-theme 'modus-operandi)
  :bind ("<f5>" . modus-themes-toggle))

(use-package ef-themes
  :ensure t
  :init
  (defun ef-themes-random-light ()
    "Load a random light ef-theme."
    (interactive)
    (ef-themes-load-random 'light))
  (defun ef-themes-random-dark ()
    "Load a random dark ef-theme."
    (interactive)
    (ef-themes-load-random 'dark))
  :bind (("<f6>" . ef-themes-random-light)
         ("<f7>" . ef-themes-random-dark))
  :config
  (ef-themes-random-light))

;;; --------------------[ Markdown ]--------------------------------------------

(use-package markdown-mode
  :ensure t
  :init
  (setq-default markdown-enable-wiki-links t
                markdown-hide-urls nil
                markdown-hide-markup nil))

;;; Emacs server

(server-start)
(require 'org-protocol)

(setq-default tab-always-indent 'complete)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (scheme . t)
   (lisp . t)))

(when my-laptop-p
  (setq python-shell-interpreter "/usr/local/bin/python3"))

(setq org-babel-python-command "python3")
(setq org-babel-scheme-command "mit-scheme")
(setq org-babel-lisp-eval-fn #'sly-eval)

;; --------------------[ Denote ]-----------------------------------------------

(defun my-denote-journal ()
  "Create an entry tagged 'journal' with the date as its title."
  (interactive)
  (denote
   (format-time-string "%A, %B %e, %Y") ; format like Friday, July 14, 2023
   '("journal"))) ; multiple keywords are a list of strings: '("one" "two")

(use-package denote
  :ensure t
  :after org
  :hook (dired-mode . denote-dired-mode)
  :init
  (setq denote-journal-extras-title-format 'day-date-month-year)
  (require 'denote-journal-extras)
  (denote-rename-buffer-mode)
  :custom
  (denote-sort-keywords t)
  (denote-directory (concat org-directory "/"))
  (denote-known-keywords '("literature", "idea", "project", "index"))
  :bind (("C-c n r" . denote-rename-file)
         ("C-c n n" . denote-create-note)
         ("C-c n l" . denote-link-or-create)
         ("C-c n b" . denote-backlinks)
         ("C-c n f" . denote-open-or-create)
         ("C-c n j" . denote-journal-extras-new-or-existing-entry)))


;;; --------------------[ Dired ]-----------------------------------------------

(use-package dired
  :init
  :hook (dired-mode . dired-hide-details-mode))

;;; --------------------[ Magit ]-----------------------------------------------

(use-package magit
  :ensure t)

;;; --------------------[ Rust ]------------------------------------------------

(use-package rust-mode
  :ensure t
  :bind
  (("C-c r r" . rust-run)
   ("C-c r f" . rust-format-buffer)))

;;; --------------------[ Go ]--------------------------------------------------

(use-package go-mode
  :ensure t
  :hook
  (go-mode . (lambda () (setq tab-width 8)))
  )

;;; --------------------[ Drill ]-----------------------------------------------

(use-package org-drill
  :ensure t)

;;; --------------------[ Proselint ]-------------------------------------------

(use-package flymake-proselint
  :ensure t
  :config
  (add-hook 'org-mode-hook #'flymake-proselint-setup))

;;; --------------------[ Useful functions ]------------------------------------

(defun fill-to-eol (char)
  "Fill a character from point until column 80."
  (interactive "cChar: ")
  (insert-char char 80)
  (move-to-column 80)
  (kill-line))

(defun insert-comment-header (title)
  "Create a Lisp comment header with a given title."
  (interactive "sTitle: ")
  (insert ";;; --------------------[ ")
  (insert title)
  (insert " ]")
  (fill-to-eol ?\-))

(defun random-list-element (x)
  (nth (random (length x)) x))

(defun choose-from (x)
  "Choose at random from a space-dilimited list of choices."
  (interactive "sChoices: ")
  (let ((y (split-string x)))
    (message "Chose: %s" (random-list-element y))))

;;; --------------------[ Macros ]----------------------------------------------

(defalias 'tvdb
   (kmacro "C-y C-u C-SPC \" C-d C-d M-l <escape> SPC - <escape> SPC C-e <backspace> \""))

;;; init.el ends here

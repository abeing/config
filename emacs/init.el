;;; init.el --- Adam Miezianko's Emacs configuraiton

;; Author: Adam Miezianko <adam.miezianko@gmail.com>

;; This file is not part of GNU Emacs

;;; Commentary:

;; I keep removing configuration from my init.el as Emacs gets more and more
;; sane defaults.

;;; Code:

;; Just in case I run my config on an older Emacs somewhere
(when (< emacs-major-version 29)
  (error "Emacs version 29 and newer required; this is version %s" emacs-major-version))

;;; --------------------[ User information ]------------------------------------

(setq user-full-name "Adam Miezianko"
      user-mail-address "adam.miezianko@gmail.com")
(setq calendar-latitude 47.6062
      calendar-longitude -122.3321)

;; Is Emacs running on my laptop? Used for setting laptop-specific settings
;; where necessary.
(defconst my-laptop-p (eq system-type 'darwin))
(defconst my-work-machine-p (eq system-type 'windows-nt))

;;; --------------------[ Computer specific settings ]--------------------------

(when my-laptop-p
  (setq ispell-program-name "/usr/local/bin/ispell")
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none))

;; Make right-click do something sensible when using GUI Emacs
(when (display-graphic-p)
  (context-menu-mode))

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

;; Save history of the minibuffer
(savehist-mode t)

;; Use Ctrl-<arrow keys> to move through windows
(windmove-default-keybindings 'control)

(show-paren-mode)             ; Highlight matching parenthesis
(save-place-mode)             ; Remember the point position for each file
(delete-selection-mode)       ; Replace selection when typing
(prefer-coding-system 'utf-8) ; Default to UTF-8 encoding
(electric-pair-mode nil)      ; When entering a character with a natural pair,
                              ; DON't insert it's corresponding pair

;; Don't use compiled code if its older than uncompiled code
(setq-default load-prefer-newer t)

;; Don't put 'customize' config in init.el; give it another file
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; Don't litter backup files everywhere. Contain them to a directory in .config
(defun am/backup-file-name (fpath)
  "Redirect the file path to backup directory where the init file lives."
  (let* ((backup-root-dir (concat user-emacs-directory "backup/"))
         (file-path (replace-regexp-in-string "[A-Za-z]:" "" fpath))
         (backup-file-path (replace-regexp-in-string "//" "/" (concat backup-root-dir file-path "~"))))
    (make-directory (file-name-directory backup-file-path) (file-name-directory backup-file-path))
    backup-file-path))
(setopt make-backup-file-name-function 'am/backup-file-name)

;;; --------------------[ Discovery aids ]--------------------------------------

(use-package which-key
  :ensure t
  :diminish
  :config
  (which-key-mode))

;;; --------------------[ Minibuffer and completion ]---------------------------

(setopt enable-recursive-minibuffers t) ; Use the minibuffer whilst in the
                                        ; minibuffer
(setopt completion-cycle-threshold 1)   ; TAB cycles candidates
(setopt completions-detailed t)         ; Show annotations
(setopt tab-always-indent 'complete)    ; TAB tries to complete, otherwise
                                        ; indents
;; Different styles to match input candidates
(setopt completion-styles '(basic initials substring))
(setopt completion-auto-help 'always)   ; Open completion always; `lazy'
                                        ; another option
(setopt completions-max-height 20)
(setopt completions-format 'one-column)
(setopt completions-group t)
(setopt completion-auto-select 'second-tab)

;; TAB acts more like how it does in the shell
(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete)

;;; --------------------[ Interface enhancements ]------------------------------

;; Show line and column number in the modeline
(setopt line-number-mode t)
(setopt column-number-mode t)
(setopt indicate-buffer-boundaries 'left)  ; Show buffer top and bottom in the margin

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
(setopt auto-revert-avoid-polling t)
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info t)
(global-auto-revert-mode t)
;; DONE

;; Don't show the menu bar, except on macOS. On macOS the menu bar doesn't take
;; up any additional screen real estate, so there's no harm in keeping it.
(when (not my-laptop-p)
  (menu-bar-mode -1))

(setq visible-bell t)

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
  :bind (("C-c g l" . avy-goto-line)
         ("C-c g c" . avy-goto-char-timer)
         ("C-c g w" . avy-goto-word-0-regexp)))

;;; --------------------[ Consult ]---------------------------------------------

(use-package consult
  :ensure t
  :bind (("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("M-s r" . consult-ripgrep)
         ("C-s" . consult-line)
         ("M-s e" . consult-flymake)
         ("M-s j" . consult-outline))
  :config
  (setq consult-narrow-key "<"))

;;; --------------------[ Embark ]----------------------------------------------

(use-package embark
  :ensure t
  :bind (("C-c e" . embark-act)))        ; bind this to an easy key to hit

(use-package embark-consult
  :ensure t)

;;; --------------------[ Evil ]------------------------------------------------

(use-package evil
  :ensure t
  :config
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-define-key 'normal 'global (kbd "<leader>f") 'find-file)
  (evil-define-key 'normal 'global (kbd "<leader>b") 'consult-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>a") 'embark-act)
  (evil-define-key 'normal 'global (kbd "<leader>wo") 'other-window)
  (evil-define-key 'normal 'global (kbd "<leader>w1") 'delete-other-windows)
  (evil-define-key 'normal 'global (kbd "<leader>gs") 'magit-status))

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

(use-package corfu-terminal
  :if (not (display-graphic-p))
  :ensure t
  :config
  (corfu-terminal-mode))

(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

(use-package kind-icon
  :if (display-graphic-p)
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless)))

;;; --------------------[ Eshell ]----------------------------------------------

(use-package eshell
  :init
  (defun my/setup-eshell ()
    (keymap-set eshell-mode-map "C-r" 'consult-history))
  :hook ((eshell-mode . my/setup-eshell)))

(use-package eat
  :ensure t
  :custom
  (eat-term-name "xterm")
  :config
  (eat-eshell-mode)
  (eat-eshell-visual-command-mode))

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

;;; --------------------[ Pulsar ]----------------------------------------------

;; This performs poorly on Windows, so I don't enable it on my work machine.

(when (not my-work-machine-p)
  (use-package pulsar
    :ensure t
    :init
    (setq pulsar-pulse t
          pulsar-delay 0.055
          pulsar-iterations 10)
    (pulsar-global-mode 1)))

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
      '(("t" "Todo [inbox]" entry
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
  (setq ef-themes-disable-other-themes t)
  (defun ef-themes-random-light ()
    "Load a random light ef-theme."
    (interactive)
    (ef-themes-load-random 'light))
  (defun ef-themes-random-dark ()
    "Load a random dark ef-theme."
    (interactive)
    (ef-themes-load-random 'dark))
  :bind (("<f6>" . ef-themes-random-light)
         ("<f7>" . ef-themes-random-dark)))

;;; --------------------[ Markdown ]--------------------------------------------

(use-package markdown-mode
  :ensure t
  :init
  (setq-default markdown-enable-wiki-links t
                markdown-hide-urls nil
                markdown-hide-markup nil))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (scheme . t)
   (lisp . t)
   (octave . t)))

(when my-laptop-p
  (setq python-shell-interpreter "/usr/local/bin/python3"))

(setq org-babel-python-command "python3")
(setq org-babel-scheme-command "mit-scheme")
(setq org-babel-lisp-eval-fn #'sly-eval)

;; --------------------[ Denote ]-----------------------------------------------

(use-package denote
  :ensure t
  :after org
  :hook (dired-mode . denote-dired-mode)
  :init
  (denote-rename-buffer-mode)
  :custom
  (denote-sort-keywords t)
  (denote-directory (concat org-directory "/"))
  (denote-known-keywords '("literature", "idea", "project", "index", "area", "resource"))
  :bind (("C-c n r" . denote-rename-file)
         ("C-c n n" . denote-create-note)
         ("C-c n l" . denote-link-or-create)
         ("C-c n b" . denote-backlinks)
         ("C-c n f" . denote-open-or-create)))

;;; --------------------[ Dired ]-----------------------------------------------

(use-package dired
  :init
  :hook (dired-mode . dired-hide-details-mode))

;;; --------------------[ Magit ]-----------------------------------------------

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

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

;;; --------------------[ LLMs ]------------------------------------------------

(use-package ellama
  :ensure t
  :bind ("C-c i" . ellama-transient-main-menu)
  :init
  (require 'llm-ollama)
  (setopt ellama-provider
          (make-llm-ollama
           :chat-model "deepseek-r1:latest")))


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

(defun random-line ()
  "Go to a random line in the buffer."
  (interactive)
  (goto-line (1+ (random (count-lines (point-min) (point-max))))))

;;; --------------------[ Macros ]----------------------------------------------

(defalias 'tvdb
   (kmacro "C-y C-u C-SPC \" C-d C-d M-l <escape> SPC - <escape> SPC C-e <backspace> \""))

;; Return `gc-cons-threshold' to its initial value stored in `early-init.el'
(setq gc-cons-threshold am/initial-gc-cons-threshold)

;;; init.el ends here

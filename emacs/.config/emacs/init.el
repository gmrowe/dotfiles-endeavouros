;;;; package --- Summary

;;; Commentary:

;;;;
;; TODO - change frame title bar to something more sensible
;;        (see: frame-title-format)
;; TODO - Add a visual indicator of which window is active
;;
;; TODO - Automatic spell-check in text modes
;;
;; TODO - Look into updating the mode-line with Doom-modeline + all-the-icons
;;
;; TODO - ivy-rich has even more goodies for discoverabilty
;;
;;;;

;;; Code:

(defvar config--min-emacs-major-version 29)

;; Show an error if this file is run with version < 29
(when (< emacs-major-version config--min-emacs-major-version)
  (error
   (format
    "This config only works with Emacs %s and newer; you have version %s"
    config--min-emacs-major-version
    emacs-major-version)))

;; Put emacs generated customization blocks into separate file
;; so that they aren't cluttering up this config
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;;; Add melpa package archives to the mix
(with-eval-after-load 'package
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

;;; TODO: should this function actually live here?
(defun config--ignore-trailing-whitespace-in-modal-spaces (hooks)
  "Turn off show trailing whitespace in modes where it is not useful.
HOOKS should be an alist of mode hooks in which whitespace should be ignored"
  (dolist
      (hook hooks)
    (add-hook hook
	      (lambda () (setq show-trailing-whitespace nil)))))

;; Default options to use when emacs loads
(use-package emacs
  :bind
  (;; Bind C-z to undo, by default it is bound to `suspend-frame'
   ("C-z" . undo)
   ;; Comment selected line(s) by using C-;
   ;; TODO: This is only really needed in prog-modes,
   ;;       can we define it there
   ("C-;" . comment-line))

  :hook
  ;; Display line numbers in any program mode
  (prog-mode . display-line-numbers-mode)
  ;; Use relative line numbering strategy
  (prog-mode . (lambda () (setopt display-line-numbers-type 'relative)))
  ;; Electric pair mode automatically closes parens and braces
  ;; it's just nice to have
  (prog-mode . electric-pair-mode)
  ;; When in a text mode, use visual line mode to wrap lines
  (text-mode . visual-line-mode)

  :config
  ;; C-<arrow key> will navagate between windows (frames)
  ; (windmove-default-keybindings 'control)
  ;; When in a gui frame, mouse right-click will bring up context menu
  (when (display-graphic-p) (context-menu-mode))
  ;; Save minibuffer history between sessions
  (savehist-mode 1)
  ;; Replace tabs with spaces
  (indent-tabs-mode nil)
  ;; Smoother scrolling - not sure if it's helpful or not
  (pixel-scroll-precision-mode 1)
  ;; Set the cursor to a lighter color so it is easier to see
  ;; #ededed is a very light grey
  (set-face-attribute 'cursor nil :background "#ededed")
  ;; Get rid of scroll bars
  (scroll-bar-mode 0)
  ;; Get rid of the graphical tool bar
  (tool-bar-mode 0)
  ;; Ignore trailing whitespace in spaces where it doesn't matter
  (config--ignore-trailing-whitespace-in-modal-spaces
   '(special-mode-hook
     term-mode-hook
     comint-mode-hook
     compilation-mode-hook
     minibuffer-setup-hook))

  :custom
  (inhibit-splash-screen t "Turn off the welcome screen")
  (line-number-mode t "Show line numbers in modeline")
  (column-number-mode t "Show column numbers in modeline")
  (initial-major-mode 'fundamental-mode "Start emacs in fundamental mode")
  (display-time-default-load-average nil "Turn off display of system load")
  (sentence-end-double-space nil "Sentences don't need double space")
  (cursor-type
   '(bar . 2)
   "Use a `bar: width = 2` type cursor like all the cool kids'")
  (initial-scratch-message nil "Suppress initial scratch message")
  (show-trailing-whitespace t "Indicate empty whitespace at end of line")
  (require-final-newline t "Attomatically append eof newline if not present")
  (ring-bell-function 'ignore "Never make a sound")
  (backup-directory-alist
   `(("." . ,(expand-file-name
	      (file-name-as-directory "backups")
	      user-emacs-directory)))
   "Don't clutter up random folders with backups")
  (backup-by-copying t "Always use copying to create backup files"))

(expand-file-name (file-name-as-directory "backups") user-emacs-directory)

;; which-key: shows a popup of available keybindings when typing a long key
;; sequence
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; Use smex for autocompletion in the minibuffer with M-x
(use-package smex
  :ensure t
  :config
  (smex-initialize)
  :bind
  (;; Bind smex to the default exteded command key
   ("M-x" . smex)
   ;; This is the default behavior for M-x - for historical purposes
   ("C-c C-c M-x" . execute-extended-command)))

;; move-text: Moves current line up or down with M-<up, down>
(use-package move-text
  :ensure t
  :bind
  (;; Bind move-text-[up, down] to M-<up, down>
   ("M-<up>" . move-text-up)
   ("M-<down>" . move-text-down)))

;; org-superstar: better looking bullets for org-mode
(use-package org-superstar
  :ensure t
  :hook
  (org-mode . org-superstar-mode))

;; simplicity-theme is a minimalist theme that only
;; colors a small number of elements (strings, comments, errors, etc.)
;; see: https://github.com/smallwat3r/emacs-simplicity-theme
(use-package simplicity-theme
  :load-path "manual-install/simplicity-theme"
  :config
  (setq simplicity-override-colors-alist
	'(("simplicity-foreground" . "#f0ead6")
	  ("simplicity-background" . "#2a333d")
	  ("simplicity-comment" . "#A4CF30")
	  ("simplicity-string" . "#CFAB30")
	  ("simplicity-keyword" . "#CF5B30")))
  (load-theme 'simplicity))

;; ivy: completion mode for multiple modes. Trust me, we really
;; want this!
(use-package ivy
  :ensure t
  :config (ivy-mode)
  :custom
  (ivy-use-virtual-buffers t "Buffers are indexes to provide faster search")
  (ivy-count-format "(%d/%d) "))

;; ace-window makes navigating wmacs windows more predicatble
(use-package ace-window
  :ensure t
  :bind
  ("M-o" . ace-window)
  ("C-x o" . ace-window))


;; ~~~~~~~~~~~~~ Development specific packages

;; company-mode: text completion for emacs
(use-package company
  :ensure t
  :hook
  (after-init . global-company-mode))

;; flycheck-mode: syntax checking for emacs
;; flycheck mode
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; flycheck-rust: a flycheck extension for configuring flycheck
;; automatically for the current cargo project
(use-package flycheck-rust
  :ensure t)

;; projectile: project-aware focused functions (compile, test, search etc.)
(use-package projectile
  :ensure t
  :init   (projectile-mode 1)
  :bind-keymap
  ("s-p" . projectile-command-map)
  ("C-c p" . projectile-command-map))

;;; Rust setup
;; rust-mode
(use-package rust-mode
  :ensure t)

;; rustic-mode - some additional goodies on top of rust-mode
(use-package rustic
  :ensure t
  :config
  (setq rustic-format-on-save t)
  (push 'rustic-clippy flycheck-checkers)
  (remove-hook 'rustic-mode-hook 'flycheck-mode)
  :custom
  (rustic-lsp-setup-p nil "Do not setup lsp mode... for now"))

;;; Clojure setup

;; clj-kondo is a linter for Clojure code.
;; flycheck-clj-kondo provides linting for Clojure via the
;; flycheck package
;; The [docs] (https://github.com/borkdude/flycheck-clj-kondo)
;; for flycheck-clj-kondo recommend putting this declaration
;; before clojure-mode declaration and then `require'ing this
;; package from the clojure-mode declaration.
;; (I don't like this, it feels messy and unlike other
;; requirements. I think this should be able to be done via
;; a `hook' but that is an experiment for another time)
(use-package flycheck-clj-kondo
  :ensure t)

;; clojure mode
(use-package clojure-mode
  :ensure t
  :config
  (require 'flycheck-clj-kondo))

;; Better handling of parenthesis when writing Lisps.
(use-package paredit
  :ensure t
  :hook
  (clojure-mode . enable-paredit-mode)
  (cider-repl-mode . enable-paredit-mode)
  (emacs-lisp-mode . enable-paredit-mode)
  :config
  (show-paren-mode t)
  :diminish nil)

;; cider-jack-in starts an nrepl and connects to it from
;; clojure-mode buffers. Enables lispy goodies such as evaluating
;; a form in a buffer. There are other, more lightweight
;; ways to do this for intance, starting a socket repl
;; and connecting to it from the emacs buffer. May
;; explore this in the future in furtherance of the goal
;; of having lightweight tools not prone to breakage.
(use-package cider
  :ensure t)

;; zprint is a source code formatter for Clojure.
;; zprint-mode formats a buffer when it is saved.
(use-package zprint-mode
  :ensure t
  :hook
  (clojure-mode . zprint-mode))

(use-package gforth
  :load-path "manual-install"
  :autoload forth-mode
  :mode ("\\.fs\\'" . forth-mode)
  :bind
  (("C-;" . comment-line))
  :hook
  (forth-mode . display-line-numbers-mode)
  (forth-mode . (lambda () (setopt display-line-numbers-type 'relative)))
  (forth-mode . electric-pair-mode))

(provide 'init)
;;; init.el ends here

;;; init-ui.el --- Emacs configuration file  -*- lexical-binding: t; no-byte-compile: t -*-
;; Copyright (C) 2024-2025 Jonathan A. Harris

;; Author: Jonathan A. Harris, MSc.
;; Keywords: configuration
;; Homepage: https://github.com/jah377/dotfiles

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This file has been generated from 'README.org'. DO NOT EDIT.

;; Changes to the configuration should be done in 'README.org' and then
;; re-tangled by calling 'C-c C-v C-t'.

;;; Code:

;; From https://www.unwoundstack.com/blog/switching-emacs-themes.html
(define-advice load-theme (:before (&rest _args) theme-dont-propagate)
  (mapc #'disable-theme custom-enabled-themes))

;; Effectively copied from https://github.com/doomemacs/themes
(use-package doom-themes
  :demand t
  :config
  (setopt doom-themes-enable-bold t
          doom-themes-enable-italic t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(defun light ()
  (interactive)
  (load-theme 'doom-tomorrow-day t))

(defun dark ()
  (interactive)
  (load-theme 'doom-one t))

(dark)

;; Modified from https://stackoverflow.com/a/50052751
(defun fonts (fontsize)
  "Set the font-pt size."
  (interactive "nFont size: ")
  (let* ((font-height (* 10 fontsize)))
    (set-face-attribute 'default nil :height font-height)
    (set-face-attribute 'fixed-pitch nil :height font-height)
    (set-face-attribute 'variable-pitch nil :height font-height)))

;; Font size at startup
(fonts 16)

(use-package nerd-icons
  :config
  ;; Download nerd-icons if directory not found
  (unless (car (file-expand-wildcards
                (concat user-emacs-directory "elpa/nerd-icons-*")))
    (nerd-icons-install-fonts t)))

;; Icons inside mini-buffer
(use-package nerd-icons-completion
  :after (marginalia nerd-icons)
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

;; Icons inside 'dired' buffers
(use-package nerd-icons-dired
  :after (dired nerd-icons)
  :hook
  (dired-mode . nerd-icons-dired-mode))

;; (use-package doom-modeline
;;   :config (doom-modeline-mode 1)
;;   :custom
;;   ;; Display project_name/../file_name
;;   (doom-modeline-buffer-file-name-style 'truncate-with-project)
;;   (doom-modeline-buffer-encoding nil "Dont care about UTF-8 badge")
;;   (doom-modeline-vcs-max-length 30   "Limit branch name length")
;;   (doom-modeline-enable-word-count t "Turn on wordcount"))

(use-package mood-line
  :hook (after-init . mood-line-mode)
  :custom
  (mood-line-glyph-alist mood-line-glyphs-fira-code)
  (mood-line-format
   (mood-line-defformat
    :left
    (((mood-line-segment-modal)                  . " ")
     ((or (mood-line-segment-buffer-status) " ") . " ")
     ((mood-line-segment-project) . "/")
     ((mood-line-segment-buffer-name)            . "\t\t")
     ((mood-line-segment-cursor-position)        . " | ")
     ((mood-line-segment-scroll)                 . "\t\t")
     ((mood-line-segment-anzu)                   . "  "))
    :right
    (((mood-line-segment-major-mode) . "  ")
     ((mood-line-segment-vc)         . "  ")
     ((mood-line-segment-misc-info)  . "  ")
     ((mood-line-segment-checker)    . "  ")
     ((mood-line-segment-process)    . "  ")))))

(column-number-mode t)

(line-number-mode t)

(use-package anzu
  :defer t
  :hook (emacs-startup . global-anzu-mode)
  :custom
  (anzu-search-threshold 1000 "Limit n words searched to reduce lag")
  (anzu-replace-threshold 50 "Limit n replacement overlay to reduce lag")
  (anzu-minimum-input-length 2 "Increase activation threshold to reduce lag")

  ;; Cleanup mode-line information
  (anzu-mode-lighter "" "Remove mode-name from results")
  (anzu-replace-to-string-separator "")

  :bind (;; Keybindings M-% and C-M-% do not change
         ([remap query-replace] . anzu-query-replace)
         ([remap query-replace-regexp] . anzu-query-replace-regexp)

         :map isearch-mode-map
         ;; Use Anzu-mode for replacing from isearch results (C-s or C-f)
         ([remap isearch-query-replace] . anzu-isearch-query-replace)
         ([remap isearch-query-replace-regexp] . anzu-isearch-query-replace-regexp)))

;; Display current function() in mode-line
(use-package which-func
  :commands which-function-mode
  :hook (prog-mode . which-function-mode))

  (use-package spacious-padding
    :hook (after-init . spacious-padding-mode)
    :custom
    (spacious-padding-widths
     '( :internal-border-width 10 ;; Space between frame & contents
        :right-divider-width 10   ;; Space between side-by-side windows
        :fringe-width 8           ;; Fringe on either side of window
        :header-line-width 4      ;; Space surrpounding 'header-line'
        :mode-line-width 2        ;; Space surrounding 'mode-line'
        :scroll-bar-width nil))   ;; 'scroll-bar' disabled
    (spacious-padding-subtle-mode-line t))

(provide 'init-ui)
;;; init-ui.el ends here

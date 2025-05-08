;;; init-writing.el --- Emacs configuration file  -*- lexical-binding: t; no-byte-compile: t -*-
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

(use-package avy
  :bind (("M-j" . avy-goto-char-timer)  ;; orig. 'default-indent-new-line'
         :map isearch-mode-map
         ("M-j" . avy-isearch))
  :custom
  (avy-timeout-seconds 0.3 "Seconds before overlay appears")
  (avy-style 'pre "Overyly single char at beginning of word")
  :custom-face
  ;; Change colors to improve readability
  (avy-lead-face ((t (:background "#000000" :foreground "#33A4FF" :weight regular)))))

(use-package jinx
  :defer t
  :hook (org-mode text-mode prog-mode conf-mode)
  :bind (("C-c j c" . jinx-correct)
         ("C-c j a" . jinx-correct-all)
         ("C-c j d" . my/jinx-save-word-at-point))
  :custom
  ;; 'jinx-mode' only checks text possessing specific face properties like
  ;; 'font-lock-comment-face' in 'prog-mode' for example.
  (jinx-include-faces
   '((yaml-mode . conf-mode)
     (yaml-ts-mode . conf-mode)
     ;; Only check docstrings and comments; not strings
     (conf-mode font-lock-comment-face)
     (prog-mode font-lock-comment-face
                font-lock-doc-face
                tree-sitter-hl-face:comment
                tree-sitter-hl-face:doc)))

  (jinx-languages "en_GB")
  :config
  ;; Quickly save word-at-point to dictionary used by 'jinx'
  (defalias 'my/jinx-save-word-at-point (kmacro "C-c j c @ RET"))

  ;; 'jinx-correct' suggestions displayed as grid instead of long list
  (vertico-multiform-mode 1)
  (add-to-list 'vertico-multiform-categories
               '(jinx grid (vertico-grid-annotate . 20))))

(use-package denote
  :defer t
  :after org
  :commands (denote denote-open-or-create)
  :hook ((dired-mode . denote-dired-mode)
         (text-mode . denote-fontify-links-mode-maybe))
  :custom
  (denote-directory (expand-file-name "notes" user-cloud-path))
  (denote-file-type "org")
  (denote-prompts '(title keywords))
  (denote-known-keywords '("emacs" "python" "linux" "ml" "work"))
  ;; TODO: add separate templates for coding/ect
  (denote-templates nil)
  (denote-org-front-matter (concat "#+TITLE: %1$s\n"
                                   "#+DATE: %2$s\n"
                                   "#+ID: %4$s\n"
                                   "#+FILETAGS: %3$s\n"
                                   "#+STARTUP: overview\n")))

(add-hook 'before-save-hook (lambda ()
                              (when (denote-file-is-note-p (buffer-file-name))
                                (org-update-all-dblocks))))

(use-package consult-denote
  :after (consult denote)
  :commands (consult-denote-find))

(provide 'init-writing)

;;; init-writing.el ends here

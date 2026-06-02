;;; personal.el --- Define personal info  -*- lexical-binding: t; no-byte-compile: t -*-

;;; Keywords: configuration
;;; Homepage: https://github.com/jah377/dotfiles
;; This file is not part of GNU Emacs.

;;; Commentary:
;;
;; Here is where we


;;; Code:

(setq user-full-name "Jonathan A. Harris, MSc."
      user-email-address "harris.jon@proton.me"
      user-github-site "https://github.com/jah377"
      user-linkedin-site "https://www.linkedin.com/in/jonharriseit/"
      user-cloud-path "/Users/jonathanharris/Library/CloudStorage/ProtonDrive-harris.jon@proton.me-folder/")

;; Create
(if (string-match user-cloud-path "")
    (error "Must define user-cloud-path in personal.el")
  (setq user-emacs-settings-path (expand-file-name "emacs_settings" user-cloud-path))

  (unless (file-directory-p user-emacs-settings-path)
    (make-directory user-emacs-settings-path)))

;; -*- coding: utf-8 -*-

(setq load-path  (cons (expand-file-name "~/.emacs.d/site-lisp/") load-path))
(load "~/.emacs.d/package.el")

(require 'auto-compile)
(setq load-prefer-newer t)
(auto-compile-on-load-mode 1)

(load "~/.emacs.d/emulate-mac-keyboard-mode")
(emulate-mac-us-keyboard-mode)

(dolist (f (directory-files "~/.emacs.d/init/" t "\\.el$"))
  (load (replace-regexp-in-string "\\.el$" "" f)))

(load "~/.emacs.d/tweeks")
(load "~/.emacs.d/keybinding")

(server-start)

;; eof

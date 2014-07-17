;; c files

(c-add-style "postgresql"
             '("bsd"
               (c-auto-align-backslashes . nil)
               (c-basic-offset . 4)
               (c-offsets-alist . ((case-label . +)
                                   (label . -)
                                   (statement-case-open . +)))
               (fill-column . 78)
               (indent-tabs-mode . t)
               (tab-width . 4)))

;; perl files

(defun pgsql-perl-style ()
  "Perl style adjusted for PostgreSQL project"
  (interactive)
  (setq perl-brace-imaginary-offset 0)
  (setq perl-brace-offset 0)
  (setq perl-continued-brace-offset 4)
  (setq perl-continued-statement-offset 4)
  (setq perl-indent-level 4)
  (setq perl-label-offset -2)
  (setq tab-width 4))

(add-hook 'perl-mode-hook
          (defun postgresql-perl-mode-hook ()
            (when (string-match "/postgres\\(ql\\)?/" buffer-file-name)
              (pgsql-perl-style))))

;; doc files

(add-hook 'sgml-mode-hook
          (defun postgresql-sgml-mode-hook ()
            (when (and buffer-file-name (string-match "/postgres\\(ql\\)?/" buffer-file-name))
              (setq fill-column 78)
              (setq indent-tabs-mode nil)
              (setq sgml-basic-offset 1))))


;;; Makefiles

;; use GNU make mode instead of plain make mode
(add-to-list 'auto-mode-alist '("/postgres\\(ql\\)?/.*Makefile.*" . makefile-gmake-mode))
(add-to-list 'auto-mode-alist '("/postgres\\(ql\\)?/.*\\.mk\\'" . makefile-gmake-mode))


(defun ck-init-c ()
  (if (string-match "/postgres/" buffer-file-name)
      (progn
        (c-set-style "postgresql")
        (setq c-basic-offset 2)
        (setq-default c-basic-offset 2))

    (progn
      (c-set-style "bsd")
      (setq c-basic-offset 2)
      (c-set-offset 'arglist-cont 0)
      (c-set-offset 'arglist-intro 2)
      (c-set-offset 'case-label 2)
      (c-set-offset 'arglist-close 0))))

(add-hook 'c-mode-hook 'ck-init-c)
(add-hook 'c++-mode-hook 'ck-init-c)



;; eof

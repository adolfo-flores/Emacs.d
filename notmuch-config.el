;; -*- coding: utf-8 -*-

(define-key notmuch-search-mode-map "g"
  'notmuch-poll-and-refresh-this-buffer)
(define-key notmuch-hello-mode-map "g"
  'notmuch-poll-and-refresh-this-buffer)

(define-key notmuch-search-mode-map "d"
  (lambda ()
    "toggle deleted tag for thread"
    (interactive)
    (if (member "deleted" (notmuch-search-get-tags))
        (notmuch-search-tag '("-deleted"))
      (notmuch-search-tag '("+deleted" "-inbox" "-unread")))))

(define-key notmuch-search-mode-map "!"
  (lambda ()
    "toggle unread tag for thread"
    (interactive)
    (if (member "unread" (notmuch-search-get-tags))
        (notmuch-search-tag '("-unread"))
      (notmuch-search-tag '("+unread")))))


(define-key notmuch-show-mode-map "d"
  (lambda ()
    "toggle deleted tag for message"
    (interactive)
    (if (member "deleted" (notmuch-show-get-tags))
        (notmuch-show-tag '("-deleted"))
      (notmuch-show-tag '("+deleted" "-inbox" "-unread")))))



(define-key notmuch-search-mode-map "a"
  (lambda ()
    "toggle archive"
    (interactive)
    (if (member "archive" (notmuch-search-get-tags))
        (notmuch-search-tag '("-archive"))
      (notmuch-search-tag '("+archive" "-inbox" "-unread")))))


(define-key notmuch-show-mode-map "a"
  (lambda ()
    "toggle archive"
    (interactive)
    (if (member "archive" (notmuch-show-get-tags))
        (notmuch-show-tag '("-archive"))
      (notmuch-show-tag '("+archive" "-inbox" "-unread")))))


(define-key notmuch-hello-mode-map "i"
  (lambda ()
    (interactive)
    (notmuch-hello-search "tag:inbox")))

(define-key notmuch-hello-mode-map "u"
  (lambda ()
    (interactive)
    (notmuch-hello-search "tag:unread")))

(define-key notmuch-hello-mode-map "a"
  (lambda ()
    (interactive)
    (notmuch-hello-search "tag:archive")))


(setq notmuch-search-oldest-first nil
      message-sendmail-envelope-from 'header
      mail-specify-envelope-from 'header
      mail-envelope-from 'header
      notmuch-show-all-multipart/alternative-parts nil
      mime-edit-split-message nil
      mime-edit-pgp-signers '("C84EF897")
      mime-edit-pgp-encrypt-to-self t
      message-send-mail-function 'message-send-mail-with-sendmail
      sendmail-program "~/dev/mail/msmtp-enqueue.sh"
      message-sendmail-f-is-evil nil
      mail-interactive t
      user-full-name "Christian Kruse"
      user-mail-address "cjk@defunct.ch"
      message-kill-buffer-on-exit t
      mail-user-agent 'message-user-agent
      notmuch-fcc-dirs '(("cjk@defunct.ch" . "Defunct/Sent")
                         ("cjk@wwwtech.de" . "Defunct/Sent")
                         ("c.kruse@termitel.de" . "Termitel/Sent")
                         ("c.kruse@mwbenson.de" . "Termitel/Sent")
                         ("c.kruse@mwbenson.ch" . "Termitel/Sent")
                         ("c.kruse@sourceflow.ch" . "Termitel/Sent")
                         (".*" . "Defunct/Sent")))

(require 'gnus-alias)
(setq gnus-alias-debug-buffer-name 1)
;(add-hook 'message-setup-hook 'gnus-alias-determine-identity)
;(setq gnus-alias-unknown-identity-rule 'gnus-alias-select-identity)

(defun ck/choose-identity ()
  (interactive)
  (let ((ident (gnus-alias-determine-identity t)))
    (if (not (equal ident ""))
        (gnus-alias-select-identity ident)
      (gnus-alias-select-identity))

    (mml-secure-sign-pgpmime)))

(add-hook 'message-setup-hook 'ck/choose-identity)
;(add-hook 'message-setup-hook 'mml-secure-sign-pgpmime)


(setq gnus-alias-identity-alist
      '(("Defunct"
         nil ;; Does not refer to any other identity
         "Christian Kruse <cjk@defunct.ch>" ;; Sender address
         nil ;; No organization header
         (("Fcc" . " ~/Mail/Defunct/Sent"))
         nil ;; No extra body text
         "~/dev/mail/signature-defunct")
        ("Termitel"
         nil
         "Christian Kruse <c.kruse@termitel.de>"
         "Termitel GmbH"
         (("Fcc" . " ~/Mail/Termitel/Sent"))
         nil
         "~/dev/mail/signature-termitel")))

;;(setq gnus-alias-default-identity "Defunct")
;; Define rules to match work identity
(setq gnus-alias-identity-rules
      '(("Termitel" ("any" "c.kruse@\\(termitel\\.de\\|mwbenson\\.de\\|mwbenson\\.ch\\|sourceflow\\.ch\\)" both) "Termitel")))

(require 'org-notmuch)

;;; bbdb

(use-package bbdb
  :config (progn

            (bbdb-initialize)
            (add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
            (add-hook 'gnus-startup-hook 'bbdb-insinuate-message)
            ;(add-hook 'message-setup-hook 'bbdb-define-all-aliases)

            (setq bbdb-user-mail-address-re "cjk\\|c.kruse@\\(defunct\\|wwwtech\\|termitel\\|mwbenson\\|sourceflow\\)\\.\\(ch\\|de\\|com\\)"
                  bbdb-file "~/.emacs.d/.bbdb"
                  bbdb-auto-revert t
                  bbdb-check-auto-save-file t
                  bbdb-expand-mail-aliases t
                  bbdb-phone-style nil
                  bbdb-pop-up-window-size 10

                  bbdb/news-auto-create-p t
                  bbdb-complete-name-allow-cycling t
                  bbdb-complete-mail-allow-cycling t
                  bbdb-complete-name-full-completion t
                  bbdb-completion-type 'primary-or-name
                  bbdb-use-pop-up nil

                  bbdb-offer-save 1
                  bbdb-electric-p t)


            (if (equal system-type 'darwin)
                (progn
                  (setq osxb-import-with-timer t)
                  (require 'osx-bbdb))
              (progn
                (use-package bbdb-vcard)))))


;; eof

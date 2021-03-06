;;; stack-ghci-mode.el --- stack ghci mode           -*- lexical-binding: t; -*-

;; Copyright (C) 2015  yasukun

;; Author: yasukun <https://twitter.com/sukezo>
;; Keywords: processes

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(require 'comint)
(require 'easymenu)

(defconst stack-ghci-mode-version "0.0.1"
  "The version of `stack-ghci-mode'.")

(defcustom stack-ghci-buffer "*StackGHCI*"
  "The name of the Stack ghci repl buffer"
  :type 'string
  :group 'stack-ghci)

(defcustom stack-ghci-mode-hook nil
  "Hook called by `stack-ghci-mode'."
  :type 'hook
  :group 'stack-ghci)

(defcustom stack-command "stack"
  "The stack command used for build haskell."
  :type 'string
  :group 'stack-ghci)

(defcustom ghci-args '("ghci")
  "The argument to pass to `stack-ghci' to start a ghci."
  :type 'list
  :group 'stack-ghci)

(defcustom ghci-reload-command ":reload"
  "The argument to pass to `stack-ghci' to reload a ghci."
  :type 'string
  :group 'stack-ghci)

(defvar stack-ghci-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-l") 'stack-ghci-send-line)
    (define-key map (kbd "C-c C-r") 'stack-ghci-send-region)
    (define-key map (kbd "C-c C-b") 'stack-ghci-revert-buffer)
    (define-key map (kbd "C-c C-g") 'stack-ghci-repl)
    (define-key map (kbd "C-c C-s") 'stack-ghci-send-commands)
    map)
  "Keymap for stack ghci major mode.")

(defun stack-ghci-repl ()
  "Launch a Stackghci REPL using `haskel-command' as an inferior mode."
  (interactive)

  (unless (comint-check-proc stack-ghci-buffer)
    (set-buffer
     (apply 'make-comint "StackGHCI"
	    stack-command
	    nil
	    ghci-args)))
  (pop-to-buffer stack-ghci-buffer))

(defun stack-ghci-get-repl-proc ()
  (unless (comint-check-proc stack-ghci-buffer)
    (stack-ghci-repl))
  (get-buffer-process stack-ghci-buffer))

(defun stack-ghci-send-line ()
  (interactive)
  (stack-ghci-send-region (line-beginning-position) (line-end-position)))

(defun stack-ghci-send-region (start end)
  "Send the current region to the inferior ghci process."
  (interactive "r")
  (deactivate-mark t)
  (let* ((string (buffer-substring-no-properties start end))
         (proc (stack-ghci-get-repl-proc))
         (multiline-escaped-string
          (replace-regexp-in-string "\n" "\uFF00" string)))
    (comint-simple-send proc multiline-escaped-string)))

(defun stack-ghci-revert-buffer ()
  (interactive)
  (deactivate-mark t)
  (save-buffer)
  (let* ((proc (stack-ghci-get-repl-proc)))
    (comint-simple-send proc ghci-reload-command)))

(defun stack-ghci-send-commands (cmd)
  "Send the command to the inferior ghci process."
  (interactive "s:")
  (deactivate-mark t)
  (let* ((proc (stack-ghci-get-repl-proc)))
    (comint-simple-send proc (format ":%s" cmd))))

(defun stack-ghci-version ()
  "Show the `stack-ghci-mode' version in the echo area."
  (interactive)
  (message (conncat "stack-ghci-mode version " stack-ghci-mode-version)))

;;
;; Menubar
;;

(easy-menu-define stack-ghci-mode-menu stack-ghci-mode-map
  "Menu for stack ghci mode"
  '("StackGHCI"
    ["REPL" stack-ghci-repl]
    "---"
    ["Version" stack-ghci-version]))

;;
;; Define Major Mode
;;

;;;###autoload
(define-derived-mode stack-ghci-mode haskell-mode "StackGHCI"
  "Major mode for editing haskell.")

(provide 'stack-ghci-mode)

;;
;; On Load
;;

;; Run stack-ghci-mode for files ending in .hs.
;;;###autoload
(add-to-list 'auto-mode-alist '("\\.hs\\'" . stack-ghci-mode))

;;; stack-ghci-mode.el ends here

;;; sideline-racket.el --- Show racket result with sideline  -*- lexical-binding: t; -*-

;; Copyright (C) 2024-2026  Shen, Jen-Chieh

;; Author: Shen, Jen-Chieh <jcs090218@gmail.com>
;; Maintainer: Shen, Jen-Chieh <jcs090218@gmail.com>
;; URL: https://github.com/emacs-sideline/sideline-racket
;; Version: 0.1.0
;; Package-Requires: ((emacs "28.1") (sideline "0.1.0") (racket-mode "1"))
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Show racket result with sideline.
;;
;; 1) Add sideline-racket to sideline backends list,
;;
;;   (setq sideline-backends-right '(sideline-racket))
;;
;; 2) Then enable sideline-mode in the target buffer,
;;
;;   M-x sideline-mode
;;

;;; Code:

(require 'sideline)

(eval-when-compile
  (require 'racket-mode))

(defgroup sideline-racket nil
  "Show racket result with sideline."
  :prefix "sideline-racket-"
  :group 'tool
  :link '(url-link :tag "Repository" "https://github.com/emacs-sideline/sideline-racket"))

(defface sideline-racket-result-overlay-face
  '((((class color) (background light))
     :background "grey90" :box (:line-width -1 :color "yellow"))
    (((class color) (background dark))
     :background "grey10" :box (:line-width -1 :color "black")))
  "Face used to display evaluation results."
  :group 'sideline-racket)

(defvar sideline-racket--buffer nil
  "Record the evaluation buffer.")

(defvar-local sideline-racket--callback nil
  "Callback to display result.")

;;;###autoload
(defun sideline-racket (command)
  "Backend for sideline.

Argument COMMAND is required in sideline backend."
  (cl-case command
    (`candidates (cons :async
                       (lambda (callback &rest _)
                         (setq sideline-racket--callback callback
                               sideline-racket--buffer (current-buffer)))))
    (`face 'sideline-racket-result-overlay-face)))

;;;###autoload
(defun sideline-racket-show (result &rest _)
  "Show RESULT with sideline."
  (when (and result
             sideline-racket--buffer)
    (with-current-buffer sideline-racket--buffer
      (funcall sideline-racket--callback (list (sideline-2str result))))))

(provide 'sideline-racket)
;;; sideline-racket.el ends here

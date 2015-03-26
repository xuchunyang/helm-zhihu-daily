;;; helm-zhihu-daily.el --- helm interface for Zhihu Daily <http://daily.zhihu.com>

;; Copyright (C) 2015 by Chunyang Xu

;; Author: Chunyang Xu <xuchunyang56@gmail.com>
;; URL: https://github.com/xuchunyang/helm-zhihu-daily
;; Version: 0.1
;; Package-Requires: ((helm "1.0") (cl-lib "0.5") (emacs "24.4"))

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

;; helm interface for 知乎日报 http://daily.zhihu.com
;;
;; This package needs Emacs 24.4 because it uses a function from EWW.

;;; Code:

(require 'cl-lib)

(require 'helm)
(require 'json)
(require 'eww)
(require 'browse-url)

(defgroup helm-zhihu-daily nil
  "helm interface for 知乎日报 (http://daily.zhihu.com/)."
  :group 'helm)

(defvar helm-zhihu-daily-url "http://news.at.zhihu.com/api/1.2/news/latest"
  "The url to grab the list of news from Zhihu Daily.")

(defun helm-zhihu-daily-get-posts ()
  (let (json)
    (with-current-buffer (url-retrieve-synchronously helm-zhihu-daily-url)
      (goto-char (point-min))
      (when (not (string-match "200 OK" (buffer-string)))
        (error "Problem connecting to the server"))
      (re-search-forward "^$" nil 'move)
      (setq json (buffer-substring-no-properties (point) (point-max)))
      (kill-buffer (current-buffer)))
    (json-read-from-string json)))

(defun helm-zhihu-daily-encoding (string)
  "Encoding."
  (decode-coding-string
   (encode-coding-string string 'utf-8) 'utf-8))

(defun helm-zhihu-daily-init ()
  (let ((json-res (helm-zhihu-daily-get-posts)))
    (cl-loop with posts = (assoc-default 'news json-res)
             for post across posts
             for title = (helm-zhihu-daily-encoding (assoc-default 'title post))
             ;; for url = (assoc-default 'url post) ; URL to raw content (in JSON)
             for share_url = (assoc-default 'share_url post)
             collect
             (cons title (list :share_url share_url)))))

(defun helm-zhihu-daily-eww-browse-link (cand)
  (eww-browse-url (plist-get cand :share_url)))

(defun helm-zhihu-daily-browse-link (cand)
  (browse-url (plist-get cand :share_url)))

(defvar helm-zhihu-daily-source
  `((name . ,(concat "知乎日报" " " (format-time-string "%Y.%m.%d %a")))
    (candidates . helm-zhihu-daily-init)
    (action . (("Browse Link in EWW" . helm-zhihu-daily-eww-browse-link)
               ("Browse Link in default web browser" . helm-zhihu-daily-browse-link)))
    (candidate-number-limit . 9999)))

;;;###autoload
(defun helm-zhihu-daily ()
  (interactive)
  (helm :sources '(helm-zhihu-daily-source) :buffer "*helm-zhihu-daily*"))

(provide 'helm-zhihu-daily)

;;; helm-zhihu-daily.el ends here

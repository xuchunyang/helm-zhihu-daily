;;; test-helm-zhihu-daily.el --- test for helm-zhihu-daily  -*- lexical-binding: t; -*-

;; Copyright (C) 2015  Chunyang Xu

;; Author: Chunyang Xu <xcy@ChunyangXusAir.lan>
;; Version: 0.1

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
;; This test file is just for learning how to write test. For now, there is no
;; stuff that needs to be tested.

;;; Code:

(require 'ert)
(require 'helm-zhihu-daily)

(ert-deftest helm-zhihu-daily:encoding ()
  "Test encoding."
  (should (string-equal "我" (helm-zhihu-daily--encoding "\u6211"))))

;;; test-helm-zhihu-daily.el ends here

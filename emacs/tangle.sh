#!/bin/sh
# Tangle files with Org mode
#
emacs -Q --batch --eval "
    (progn
      (require 'ob-tangle)
      (dolist (file command-line-args-left)
        (with-current-buffer (find-file-noselect file)
          (org-babel-tangle))))
  " "$@"

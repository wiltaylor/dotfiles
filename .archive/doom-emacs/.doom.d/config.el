;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Wil Taylor"
      user-mail-address "email@wiltaylor.dev")

;; Mostly default theme
(setq doom-font (font-spec :family "monospace" :size 14))
(setq doom-theme 'doom-one)

;; Org folder stored in nextcloud
(setq org-directory "~/trashbox/org/")

(setq display-line-numbers-type t)

;;Makes copy and paste work as expected
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

;; Setting up mermaid.
(setq ob-mermaid-cli-path "/home/wil/.doom.d/mermaid/node_modules/.bin/mmdc")

;; Custom key maps
(map! :after org
      :map org-mode-map
      :localleader
      :desc "Toggle Maths" "m" #'org-latex-preview
      :desc "Tottlge Image" "M" #'org-display-inline-images)

(map! :leader
      :desc "Toggle Treemacs" "t" #'treemacs)

;; Setting mouse pointer to white so it contrasts with theme properly
(set-mouse-color "white")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dashboard ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun open-org-index()
  "Opens the org mode index"
  (interactive)
	(message "I ran!!!")
	(find-file-existing "~/trashbox/org/index.org"))

(setq +doom-dashboard-menu-sections
  '(("Reload last session"
     :icon (all-the-icons-octicon "history" :face 'doom-dashboard-menu-title)
     :when (cond ((require 'persp-mode nil t)
                  (file-exists-p (expand-file-name persp-auto-save-fname persp-save-dir)))
                 ((require 'desktop nil t)
                  (file-exists-p (desktop-full-file-name))))
     :face (:inherit (doom-dashboard-menu-title bold))
     :action doom/quickload-session)
    ("Open org index"
     :icon (all-the-icons-octicon "book" :face 'doom-dashboard-menu-title)
     :action open-org-index)
    ("Recently opened files"
     :icon (all-the-icons-octicon "file-text" :face 'doom-dashboard-menu-title)
     :action recentf-open-files)
    ("Open project"
     :icon (all-the-icons-octicon "briefcase" :face 'doom-dashboard-menu-title)
     :action projectile-switch-project)
    ("Jump to bookmark"
     :icon (all-the-icons-octicon "bookmark" :face 'doom-dashboard-menu-title)
     :action bookmark-jump)
    ("Open private configuration"
     :icon (all-the-icons-octicon "tools" :face 'doom-dashboard-menu-title)
     :when (file-directory-p doom-private-dir)
     :action doom/open-private-config)
    ("Open documentation"
     :icon (all-the-icons-octicon "book" :face 'doom-dashboard-menu-title)
     :action doom/help)))


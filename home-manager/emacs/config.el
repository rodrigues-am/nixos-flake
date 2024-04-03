(setq user-full-name "André Rodrigues"
      user-mail-address "rodrigues.am@usp.br")

;; (add-to-list 'load-path "~/.script/elisp")
;; (require 'amr.el)

(use-package use-package-quelpa
  :defer t)

(use-package auth-source
  :ensure t
  :custom
  (auth-sources  '("~/sync/pessoal/security/.authinfo-amr")))

(setq bookmark-save-flag 1)

(setq dired-dwim-target t)

(use-package lsp-grammarly
  :ensure t
  ;; :hook ((text-mode org-mode) . (lambda ()
  ;;                       (require 'lsp-grammarly)
  ;;                       (lsp)))
  ) ; or lsp-deferred

(use-package grammarly
  :ensure t)

(remove-hook 'text-mode-hook #'spell-fu-mode)

(use-package flyspell
  :defer t
  :config
  (add-to-list 'ispell-skip-region-alist '("~" "~"))
  (add-to-list 'ispell-skip-region-alist '("=" "="))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_SRC" . "^#\\+END_SRC"))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_EXPORT" . "^#\\+END_EXPORT"))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_EXPORT" . "^#\\+END_EXPORT"))
  (add-to-list 'ispell-skip-region-alist '(":\\(PROPERTIES\\|LOGBOOK\\):" . ":END:"))

  (dolist (mode '(
                  ;;org-mode-hook
                  mu4e-compose-mode-hook))
    (add-hook mode (lambda () (flyspell-mode 1)))))

(use-package telega
  :defer t)

(use-package mastodon
  :defer t
  :config
  (setq mastodon-instance-url "https://mastodon.social"
  mastodon-active-user "rodrigues_am"))

(use-package shell-maker
  :ensure t)

(use-package chatgpt-shell
  :requires shell-maker
  :ensure t)

(use-package gptel
  :ensure t)

(use-package org
  :defer t
  :mode (("\\.org$" . org-mode))
  :ensure org-plus-contrib
  :config
  (setq org-directory "~/notas/general")
  (setq org-agenda-files '("~/notas/general"))
  (setq fill-column 110)
  :hook
  (org-mode . auto-fill-mode))

(use-package org-noter
  :defer t
  :custom
  (org-noter-highlight-selected-text t)
  (org-noter-max-short-selected-text-length 5))

(use-package org-modern
  :ensure t
  :hook
  (org-mode . org-modern-mode)
  :custom
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  (org-ellipsis "…")
  (org-modern-star '("" "" "⍟" "⋄" "✸" "✿")))

(with-eval-after-load 'org (global-org-modern-mode))

(setq org-todo-keywords
      '((sequence "TODO(t)" "READ(l)" "HOLD(h)" "IDEA(i)" "|" "DONE(d)" "KILL(k)")))

(setq hl-todo-keyword-faces
      '(("TODO"   . "#00CC00")
        ("READ"  . "#00ACE6")
        ("HOLD"  . "#FFCC66")
        ("IDEA"  . "#CCCC00")
        ("DONE"  . "#CCCCCC")
        ("KILL"  . "#FF0000")))

(use-package burly
  :ensure t)

(setq abbrev-file-name
        "~/sync/pessoal/emacs/abbrev/.abbrev_defs.el")

(org-babel-do-load-languages
  'org-babel-load-languages
  '((plantuml . t)))

(use-package golden-ratio
  :ensure t)

(use-package lambda-themes
  :defer t
  :custom
  (lambda-themes-set-italic-comments t)
  (lambda-themes-set-italic-keywords t)
  (lambda-themes-set-variable-pitch t)
  :config
  ;; load preferred theme
  (load-theme 'lambda-dark-faded))

(use-package olivetti
  :ensure
  :defer
  :diminish
  :config
  (setq olivetti-body-width 0.65)
  (setq olivetti-minimum-body-width 72)
  (setq olivetti-recall-visual-line-mode-entry-state t)

  (define-minor-mode amr/olivetti-mode
    "Toggle buffer-local `olivetti-mode' with additional parameters.

Fringes are disabled.  The modeline is hidden, except for
`prog-mode' buffers (see `amr/hidden-mode-line-mode').  The
default typeface is set to a proportionately-spaced family,
except for programming modes (see `amr/variable-pitch-mode').
The cursor becomes a blinking bar, per `amr/cursor-type-mode'."
    :init-value nil
    :global nil
    (if amr/olivetti-mode
        (progn
          (olivetti-mode 1)
          (set-window-fringes (selected-window) 0 0)
          (amr/variable-pitch-mode 1)
          (amr/scroll-centre-cursor-mode 1)
          (amr/display-line-numbers-mode 0))
      (olivetti-mode -1)
      (set-window-fringes (selected-window) nil) ; Use default width
      (amr/variable-pitch-mode -1)))
    :bind ("M-p o" . amr/olivetti-mode))


  (use-package face-remap
    :diminish buffer-face-mode            ; the actual mode
    :commands amr/variable-pitch-mode
    :config
    (define-minor-mode amr/variable-pitch-mode
      "Toggle `variable-pitch-mode', except for `prog-mode'."
      :init-value nil
      :global nil
      (if amr/variable-pitch-mode
          (unless (derived-mode-p 'prog-mode)
            (variable-pitch-mode 1))
        (variable-pitch-mode -1))))


  (use-package emacs
    :config
    (setq-default scroll-preserve-screen-position t)
    (setq-default scroll-conservatively 1) ; affects `scroll-step'
    (setq-default scroll-margin 0)

    (define-minor-mode amr/scroll-centre-cursor-mode
      "Toggle centred cursor scrolling behaviour."
      :init-value nil
      :lighter " S="
      :global nil
      (if amr/scroll-centre-cursor-mode
          (setq-local scroll-margin (* (frame-height) 2)
                      scroll-conservatively 0
                      maximum-scroll-margin 0.5)
        (dolist (local '(scroll-preserve-screen-position
                         scroll-conservatively
                         maximum-scroll-margin
                         scroll-margin))
          (kill-local-variable `,local))))

    ;; C-c l is used for `org-store-link'.  The mnemonic for this is to
    ;; focus the Line and also works as a variant of C-l.
    :bind ("M-p s" . amr/scroll-centre-cursor-mode))


  (use-package display-line-numbers
    :defer
    :config
    ;; Set absolute line numbers.  A value of "relative" is also useful.
    (setq display-line-numbers-type t)

    (define-minor-mode amr/display-line-numbers-mode
      "Toggle `display-line-numbers-mode' and `hl-line-mode'."
      :init-value nil
      :global nil
      (if amr/display-line-numbers-mode
          (progn
            (display-line-numbers-mode 1)
            (hl-line-mode 1))
        (display-line-numbers-mode -1)
        (hl-line-mode -1)))
    :bind ("M-p l" . amr/display-line-numbers-mode))

(use-package nov
  :defer t
  :hook
  (nov-mode . scroll-lock-mode))

(use-package org-roam
 :ensure t
 :init
 (setq org-roam-v2-ack t)
 (setq org-roam-mode-section-functions
       (list #'org-roam-backlinks-section
             #'org-roam-reflinks-section
              #'org-roam-unlinked-references-section ))
 (add-to-list 'display-buffer-alist
              '("\\*org-roam\\*"
                (display-buffer-in-direction)
                (direction . right)
                (window-width . 0.33)
                (window-height . fit-window-to-buffer)))
 :custom
 (org-roam-directory "~/roam-notes")
 (org-roam-complete-everywhere t)
 (org-roam-capture-templates
  '(("d" "default" plain "%?"
     :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                        "#+title: ${title}\n")
     :unnarrowed t))
    ("m" "main" plain
     (file "~/roam-notes/templates/main.org")
     :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                        "#+title: ${title}\n")
     :unnarrowed t)
    ("n" "novo pensamento" plain
     (file "~/roam-notes/templates/pensa.org")
     :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                        "#+title: ${title}\n")
     :unnarrowed t)
    ("b" "bibliografia" plain
     (file "~/roam-notes/templates/bib.org")
     :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                        "#+title: ${title}\n")
     :unnarrowed t)
    ("p" "project" plain
     (file "~/roam-notes/templates/project.org")
     :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                        "#+title: ${title}\n")
     :unnarrowed t))
 :bind (("C-c n l" . org-roam-buffer-toggle)
        ("C-c n f" . org-roam-node-find)
        ("C-c n i" . org-roam-node-insert)
        :map org-mode-map
        ("C-M-i" . completion-at-point))
 :config
  (org-roam-setup))

(setq org-agenda-span 1
      org-agenda-start-day "+0d"
      org-agenda-skip-timestamp-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-skip-scheduled-if-done t
      org-agenda-skip-scheduled-if-deadline-is-shown t
      org-agenda-skip-timestamp-if-deadline-is-shown t)

;; Ricing org agenda
(setq org-agenda-current-time-string "")
(setq org-agenda-time-grid '((daily) () "" ""))

(setq org-agenda-prefix-format '(
(agenda . "  %?-2i %t ")
 (todo . " %i %-12:c")
 (tags . " %i %-12:c")
 (search . " %i %-12:c")))

(setq org-agenda-hide-tags-regexp ".*")

;; Function to be run when org-agenda is opened
(defun org-agenda-open-hook ()
  "Hook to be run when org-agenda is opened"
  (olivetti-mode))

;; Adds hook to org agenda mode, making follow mode active in org agenda
(add-hook 'org-agenda-mode-hook 'org-agenda-open-hook)

;; org-super-agenda

(use-package org-super-agenda
  :after org
  :config
  (setq org-super-agenda-header-map nil) ;; takes over 'j'
  ;; (setq org-super-agenda-header-prefix " ◦ ") ;; There are some unicode "THIN SPACE"s after the ◦
  ;; Hide the thin width char glyph. This is dramatic but lets me not be annoyed
  (add-hook 'org-agenda-mode-hook
            #'(lambda () (setq-local nobreak-char-display nil)))
  (org-super-agenda-mode)
  (setq org-super-agenda-groups
       '(;; Each group has an implicit boolean OR operator between its selectors.
         (:name " Overdue "  ; Optionally specify section name
                :scheduled past
                :order 2
                :face 'error)

         ;; (:name "Personal "
         ;;        :and(:file-path "Personal.p" :not (:tag "event"))
         ;;        :order 3)

         ;; (:name "Family "
         ;;        :and(:file-path "Family.s" :not (:tag "event"))
         ;;        :order 3)

         ;; (:name "Teaching "
         ;;        :and(:file-path "Teaching.p" :not (:tag "event"))
         ;;        :order 3)

         ;; (:name "Gamedev "
         ;;        :and(:file-path "Gamedev.s" :not (:tag "event"))
         ;;        :order 3)

         ;; (:name "Youtube "
         ;;        :and(:file-path "Producer.p" :not (:tag "event"))
         ;;        :order 3)

         ;; (:name "Music "
         ;;        :and(:file-path "Bard.p" :not (:tag "event"))
         ;;        :order 3)

         ;; (:name "Storywriting "
         ;;        :and(:file-path "Stories.s" :not (:tag "event"))
         ;;        :order 3)

         ;; (:name "Writing "
         ;;        :and(:file-path "Author.p" :not (:tag "event"))
         ;;        :order 3)

         ;; (:name "Learning "
         ;;        :and(:file-path "Knowledge.p" :not (:tag "event"))
         ;;        :order 3)

          (:name " Today "  ; Optionally specify section name
                :time-grid t
                :date today
                :scheduled today
                :order 1
                :face 'warning)))

(org-super-agenda-mode t))

(use-package elfeed-org
  :defer
  :config
  (setq rmh-elfeed-org-files (list "~/sync/pessoal/emacs/elfeed/elfeed.org"))
  (setq-default elfeed-search-filter "@4-week-ago +unread -news -blog -search"))

(use-package elfeed-goodies
  :ensure t
  :custom
  (elfeed-goodies/feed-source-column-width 36)
  (elfeed-goodies/tag-column-width 25))

(with-eval-after-load 'ox
    (require 'ox-hugo))

(add-to-list 'org-capture-templates
      '(("b" "blog post" entry
         (file+headline "~/blog/blog.org" "NO New ideas")
         (file "~/sync/pessoal/emacs/org-capture-templates/post.org"))))

(use-package yasnippet
  :ensure t
  :config
  (setq yas-snippet-dirs '("~/sync/pessoal/emacs/snippets"))
  (yas-global-mode 1))

(require 'org-tempo)

(require 'oc-csl)
(setq org-cite-global-bibliography '("~/bib.bib"))
(setq org-cite-csl-styles-dir "~/Zotero/styles")

(use-package zotxt
  :defer t
  :custom
  (setq zotxt-default-bibiliography-style "apa"))

(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

(use-package all-the-icons
  :if (display-graphic-p))

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :ensure t
  :init (ivy-rich-mode 1))

(with-eval-after-load "ox-latex"
  (add-to-list 'org-latex-classes
               '("tuftebook"
                 "\\documentclass{tufte-book}\n
\\usepackage{color}
\\usepackage{amssymb}
\\usepackage{gensymb}
\\usepackage{nicefrac}
\\usepackage{units}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  ;; tufte-handout class for writing classy handouts and papers
  ;;(require 'org-latex)
  (add-to-list 'org-latex-classes
               '("tuftehandout"
                 "\\documentclass{tufte-handout}
\\usepackage{color}
\\usepackage{amssymb}
\\usepackage{amsmath}
\\usepackage{gensymb}
\\usepackage{nicefrac}
\\usepackage{units}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  ;; Plain text
  (add-to-list 'org-latex-classes
               '("org-plain-latex"
                 "\\documentclass{article}
           [NO-DEFAULT-PACKAGES]
           [PACKAGES]
           [EXTRA]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

(add-to-list 'org-latex-classes
               '("pocketmod"
                 "\\documentclass[fontsize=24pt,a4paper]{scrartcl}
\\usepackage[showmarks]{pocketmod}
\\usepackage[default]{lato}
\\usepackage[T1]{fontenc}
\\pagenumbering{gobble}
\\usepackage{color}
\\usepackage{amssymb}
\\usepackage{amsmath}
\\usepackage{gensymb}
\\usepackage{nicefrac}
\\usepackage{units}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
                 ("\\pagebreak" . "\\pagebreak")))

(setq org-publish-project-alist
      '(
        ("notes"
         :base-directory "~/notes/"
         :base-extension "org"
         :publishing-directory "~/notes/export/"
         :publishing-function org-publish-org-to-latex
         :select-tags     ("@NOTES")
         :title "Notes"
         :include ("academic.org")
         :exclude "\\.org$"
         )))

(after! projectile
          (setq projectile-project-root-files-bottom-up
                (remove ".git" projectile-project-root-files-bottom-up)))

(use-package company
  :defer t
  :custom
  (company-minimum-prefix-length 3)
  (company-idle-delay 0.3))



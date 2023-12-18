(setq user-full-name "André Rodrigues"
      user-mail-address "rodrigues.am@usp.br")

(setq bookmark-save-flag 1)

(setq dired-dwim-target t)

(use-package lsp-grammarly
  :ensure t
  :hook ((text-mode org-mode) . (lambda ()
                       (require 'lsp-grammarly)
                       (lsp)))) ; or lsp-deferred

(use-package grammarly
  :ensure t)

(use-package chatgpt-shell
  :ensure t
  :custom
  ((chatgpt-shell-openai-key
    (lambda ()
      (auth-source-pass-get 'secret "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")))))

(setq org-directory "~/notas/")

;;(defun amr-clean ()
  ;; (display-line-numbers-mode 0)
;;   (set-fill-column 110)
;;(set-window-margins (selected-window) 40 40)
;;   (setq left-margin-width 20)
  ;;                                                             (setq right-margin-width 10)
  ;; (company-mode -1))
;;(add-hook 'org-mode-hook 'amr-clean)

;; (setq
;; org-superstar-headline-bullets-list '("" "" "⍟" "⋄" "✸" "✿"))


;; (use-package org-fancy-priorities
;;   :ensure t
;;   :hook
;;   (org-mode . org-fancy-priorities-mode)
;;   :config
;;   (setq org-fancy-priorities-list '("🔴" "🔶" "🟩")))

(use-package org-modern
  :ensure t
  :hook
  (org-mode . org-modern-mode)
  :custom
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

(setq abbrev-file-name
        "~/notas/.abbrev_defs.el")

(org-babel-do-load-languages
  'org-babel-load-languages
  '((plantuml . t)))

;;(setq org-plantuml-jar-path
 ;;     (expand-file-name
;;       "~/.script/plantuml-1.2022.8.jar"))

(setq doom-theme 'doom-one)

(setq display-line-numbers-type t)

(use-package golden-ratio
  :ensure t)

;;(straight-use-package
;;  '(nano :type git :host github :repo "rougier/nano-emacs"))

(use-package bespoke-themes
  :straight (:host github :repo "mclear-tools/bespoke-themes" :branch "main")
  :config
  ;; Set evil cursor colors
  (setq bespoke-set-evil-cursors t)
  ;; Set use of italics
  (setq bespoke-set-italic-comments t
        bespoke-set-italic-keywords t)
  ;; Set variable pitch
  (setq bespoke-set-variable-pitch t)
  ;; Set initial theme variant
  (setq bespoke-set-theme 'dark)
  ;; Load theme
  (load-theme 'bespoke t))

(use-package olivetti
  :ensure t)

(use-package org-roam
 :ensure t
 :init
 (setq org-roam-v2-ack t)
 (setq org-roam-mode-section-functions
       (list #'org-roam-backlinks-section
             #'org-roam-reflinks-section
              #'org-roam-unlinked-references-section
             ))
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

;; org-super-agenda

 (let ((org-super-agenda-groups
       '((:log t)  ; Automatically named "Log"
         (:name "Schedule"
                :time-grid t)
         (:name "Today"
                :scheduled today)
         (:habit t)
         (:name "Due today"
                :deadline today)
         (:name "Overdue"
                :deadline past)
         (:name "Due soon"
                :deadline future)
         (:name "Unimportant"
                :todo "START"
                :order 100)
         (:name "HOLD"
                :todo "HOLD"
                :order 98)
         (:name "Scheduled earlier"
                :scheduled past))))
  (org-agenda-list))

;; (require 'org-gcal)
;; (setq org-gcal-client-id "873354957001-1lbdhjvqp9f9l63qg1tmmunq2ra3jsqk.apps.googleusercontent.com"
;;       org-gcal-client-secret "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"
;;       org-gcal-fetch-file-alist '(("rodrigues.am@usp.br" .  "~/notas/cal.org")))

;; (require 'org-gtasks)
;; (org-gtasks-register-account :name "rodrigues.am@usp.br"
;;                              :directory "~/notas/"
;;                              :client-id "873354957001-1lbdhjvqp9f9l63qg1tmmunq2ra3jsqk.apps.googleusercontent.com"
;;                              :client-secret "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")

(setq org-agenda-custom-commands
   '(("X" agenda "" nil ("~/org-agenda/agenda.html" "~/org-agenda/agenda.ps"))
        ("z" todo ""
         (
          ;;(org-columns-default-format "%25ITEM %TODO %3PRIORITY %TAGS")
          (org-agenda-overriding-header "Lista TODO")
          (org-agenda-with-colors true)
          (org-agenda-remove-tags t)
          (ps-number-of-column 2)
          (ps-landscape-mode t)
          )
         ("~/org-agenda/todo.html" "~/org-agenda/todo.txt" "~/org-agenda/todo.ps"))
        ))

(use-package elfeed-org
  :defer
  :config
  (setq rmh-elfeed-org-files (list "~/notas/elfeed.org"))
  (setq-default elfeed-search-filter "@4-week-ago +unread -news -blog -search"))

(use-package elfeed-goodies
  :ensure t
  :custom
  (feed-source-column-width 75)
  (tag-column-width 30))

(with-eval-after-load 'ox
    (require 'ox-hugo))

(setq org-capture-templates
      '(("b" "blog post" entry
         (file+headline "~/blog/blog.org" "NO New ideas")
         (file "~/blog/org-templates/post.org"))))

(require 'org-tempo)
(tempo-define-template "org-meeting" ; just some name for the template
                      '("*** m: "
                         (insert (format-time-string "%d %b %Y")) n p)
          "<mt"
          "Insert a metting with day" ; documentation
          'org-tempo-tags)

(tempo-define-template "requerimento-aprovado-equivalencia" ; just some name for the template
                       '("Solicitação " p ": Aprovado\nDisciplina:")
          "<ap"
          "Insert aprovado" ; documentation
          'org-tempo-tags)

(tempo-define-template "requerimento-negado-equivalencia" ; just some name for the template
                      '("Solicitação " p ": Negado\nDisciplina:")
          "<rj"
          "Insert Negado" ; documentation
          'org-tempo-tags)

(tempo-define-template "emacs-lisp" ; just some name for the template
                      '("#+begin_src emacs-lisp" n p n "#+end_src")
          "<el"
          "Insert a e-lisp block" ; documentation
          'org-tempo-tags)

(setq org-cite-csl-styles-dir "~/Zotero/styles")

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
         )
        ;; ("home"
        ;;  :base-directory "~/notes/org/"
        ;;  :base-extension "org"
        ;;  :publishing-directory "~/notes/export/home/"
        ;;  :publishing-function org-publish-org-to-latex
        ;;  :select-tags     ("@HOME")
        ;;  :title "Home Phone"
        ;;  :include ("index.org")
        ;;  :exclude "\\.org$"
        ;;  )
        ))

(after! projectile
          (setq projectile-project-root-files-bottom-up
                (remove ".git" projectile-project-root-files-bottom-up)))

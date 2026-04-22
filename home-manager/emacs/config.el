(setq user-full-name "André Rodrigues"
      user-mail-address "rodrigues.am@usp.br")

;; (add-to-list 'load-path "~/.script/elisp")
;; (require 'amr.el)

(use-package use-package-quelpa
  :defer t)

(define-key evil-normal-state-map (kbd "C-u") 'universal-argument)

(define-key evil-motion-state-map (kbd "C-u") 'universal-argument)

;; (setq doom-font (font-spec :family "Iosevka" :size 14)
;;       doom-big-font (font-spec :family "Iosevka" :size 20)
;;       ;; Opcional: fonte variável para textos
;;       doom-variable-pitch-font (font-spec :family "Iosevka" :size 16))

(setq doom-theme 'doom-gruvbox)

(use-package auth-source
  :ensure t
  :custom
  (auth-sources  '("~/sync/pessoal/security/.authinfo-amr")))

(use-package! sops-mode
  :mode ("\\.sops\\.ya?ml\\'" . sops-mode)
  :hook ((sops-mode . (lambda () (read-only-mode -1)))))

(setq bookmark-save-flag 1)

(setq dired-dwim-target t)

(setq delete-by-moving-to-trash t)

;; Optionally use the `orderless' completion style.
(use-package orderless
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(after! geiser
  (setq geiser-guile-binary "/etc/profiles/per-user/andre/bin/guile"))

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

(global-set-key (kbd "M-p s") 'my-flyspell-toggle)

(defun my-flyspell-toggle ()
  "Toggle flyspell-mode and run flyspell-buffer if enabling flyspell-mode."
  (interactive)
  (if flyspell-mode
      (flyspell-mode -1)
    (flyspell-mode 1)
    (flyspell-buffer)))

;; Definir o dicionário padrão
(setq ispell-dictionary "pt_BR")

;; Informar onde o aspell está e como deve usar os dicionários
(setq ispell-program-name "aspell")
(setq ispell-extra-args '("--sug-mode=ultra"))

;; Alternar rapidamente entre idiomas
(defun amr/set-english-dictionary ()
  "Switch ispell to English."
  (interactive)
  (ispell-change-dictionary "en"))

(defun amr/set-portuguese-dictionary ()
  "Switch ispell to Brazilian Portuguese."
  (interactive)
  (ispell-change-dictionary "pt_BR"))

(map! :leader
      (:prefix ("M-p d" . "toggle")
       :desc "English Dictionary" "e" #'amr/set-english-dictionary
       :desc "Portuguese Dictionary" "p" #'amr/set-portuguese-dictionary))

(use-package org
  :defer t
  :mode (("\\.org$" . org-mode))
  :ensure org-plus-contrib
  :config
  (setq org-directory "~/notas/general/")
  (setq org-agenda-files '("~/notas/general/"))
  (setq fill-column 100))

(use-package! org-headline-card
  :after org
  :custom
  (org-headline-card-directory "~/notas/general/card"))

(use-package pdf-tools
:config
(pdf-tools-install)
  (setq pdf-view-use-scaling t))

(use-package org-noter
  :defer t
  :after pdf-tools
  :custom
  (org-noter-enable-org-roam-integration)
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

(use-package burly)

(setq abbrev-file-name
        "~/sync/pessoal/emacs/abbrev/.abbrev_defs.el")

(org-babel-do-load-languages
  'org-babel-load-languages
  '((plantuml . t)))

(use-package golden-ratio
  :ensure t)

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
    :bind ("M-p q" . amr/scroll-centre-cursor-mode))


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
 (setq org-roam-mode-sections
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
 (org-roam-directory "~/notas/roam-notes")
 (org-roam-complete-everywhere t)
 (org-roam-capture-templates
  '(("d" "default" plain "%?"
     :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                        "#+title: ${title}\n")
     :unnarrowed t))
    ("m" "main" plain
     (file "~/notas/roam-notes/templates/main.org")
     :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                        "#+title: ${title}\n")
     :unnarrowed t)
    ("n" "novo pensamento" plain
     (file "~/notas/roam-notes/templates/pensa.org")
     :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                        "#+title: ${title}\n")
     :unnarrowed t)
    ("r" "bibliography reference" plain
         (file "~/notas/roam-notes/templates/bib.org")
         :target
         (file+head "references/${citekey}.org" "#+title: ${title}\n")
         :unnarrowed t)
    ("p" "project" plain
     (file "~/notas/roam-notes/templates/project.org")
     :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                        "#+title: ${title}\n")
     :unnarrowed t))
 :bind (("C-c n l" . org-roam-buffer-toggle)
        ("C-c n f" . org-roam-node-find)
        ("C-c n i" . org-roam-node-insert)
        :map org-mode-map
        ("C-M-i" . completion-at-point))
 :config
  (org-roam-db-autosync-enable))

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
  :custom
  (elfeed-goodies/feed-source-column-width 36)
  (elfeed-goodies/tag-column-width 25))

(with-eval-after-load 'ox
    (require 'ox-hugo))

(with-eval-after-load 'ox-hugo
  (plist-put org-hugo-citations-plist :bibliography-section-heading "Referências"))

(after! org
  (setq org-capture-templates
        (append org-capture-templates
                '(("i" "Inbox Tasks" entry
                   (file+headline "~/notas/general/inbox.org" "Inbox")
                   (file "~/sync/pessoal/emacs/org-capture-templates/inbox.org"))
                  ("b" "Blog Post" entry
                   (file+headline "~/notas/blog/blog.org" "NO New ideas")
                   (file "~/sync/pessoal/emacs/org-capture-templates/post.org"))))))

(use-package yasnippet
  :ensure t
  :config
  (setq yas-snippet-dirs '("~/sync/pessoal/emacs/snippets"))
  (yas-global-mode 1))

(require 'org-tempo)

(require 'oc-csl)
(setq org-cite-global-bibliography '("~/notas/bib/bib.bib"))
(setq org-cite-csl-styles-dir "~/Zotero/styles")

(use-package citar
  :custom
  (citar-bibliography '("~/notas/bib/bib.bib")))

(use-package citar-embark
  :after citar embark
  :no-require
  :config (citar-embark-mode))

(use-package citar-org-roam
  :after (citar org-roam)
  :config (citar-org-roam-mode))

(with-eval-after-load "ox-latex"

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
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))
  ;; Plain text

(after! projectile
          (setq projectile-project-root-files-bottom-up
                (remove ".git" projectile-project-root-files-bottom-up)))

(after! projectile
  ;; Nunca trate a home como projeto
  (add-to-list 'projectile-ignored-projects "~/")

  ;; (opcional) ignore também subdiretórios comuns da home
  (add-to-list 'projectile-globally-ignored-directories "~/.cache")
  (add-to-list 'projectile-globally-ignored-directories "~/.local")
  (add-to-list 'projectile-globally-ignored-directories "~/.config"))

(use-package company
  :defer t
  :custom
  (company-minimum-prefix-length 3)
  (company-idle-delay 0.3))

(defgroup amr-custom-group nil
  "Custom group for my settings."
  :group 'convenience)

(defcustom amr-course-list-file-path "~/notas/.script/curso.txt"
  "Path to the text file with courses list."
  :type 'file
  :group 'amr-custom-group)


(defun amr-read--text-file-to-alist (file-path)
  "Read a text file with one item per line and return an alist."
  (with-temp-buffer
    (insert-file-contents file-path)
    (let ((alist '()))
      (while (not (eobp))
        (push (cons (buffer-substring-no-properties (line-beginning-position) (line-end-position)) nil) alist)
        (forward-line))
      (nreverse alist))))


(defun amr-insert--alist-item (alist)
  "Prompt the user to select an item from the given alist using ivy-read."
  (let ((selected-item (completing-read "Select item: " (mapcar 'car alist))))
    (when selected-item
      (insert selected-item))))

(defun amr-insert-course-ifusp ()
  "Read a text file with one item per line, create an alist,
  and then prompt the user to select and insert an item from it using ivy-read."
  (interactive)
  (let ((file-path amr-course-list-file-path))
    (setq my-alist (amr-read--text-file-to-alist file-path))
    (amr-insert--alist-item my-alist)))


;; Bind the function to "C-j c"
(global-set-key (kbd "M-p c") 'amr-insert-course-ifusp)

(add-hook 'ess-mode-hook (lambda () (abbrev-mode 1)))
(defun amr-ess-keybindings ()
  (define-key ess-mode-map (kbd "M-p e") 'ess-eval-paragraph))
(add-hook 'ess-mode-hook 'amr-ess-keybindings)

;; ══════════════════════════════════════════════════════════════════════
;; Configuração mu4e — Doom Emacs
;; Contas: Gmail (pessoal) + USPmail (institucional)
;; Envia via msmtp, sincroniza via mbsync, indexa via mu
;; ══════════════════════════════════════════════════════════════════════

(use-package! mu4e
  :ensure nil  ;; mu4e vem com o pacote mu, não instalar via straight/package.el
  :config

  ;; ── Configurações gerais ────────────────────────────────────────────
  (setq mu4e-maildir "~/.mail"
        mu4e-get-mail-command "mbsync -a"
        mu4e-update-interval 300             ;; sync a cada 5 min (além do systemd timer)
        mu4e-change-filenames-when-moving t  ;; necessário para mbsync + Maildir
        mu4e-index-cleanup t                 ;; remove msgs antigos do índice
        mu4e-index-lazy-check nil            ;; indexação completa
        mu4e-view-show-images t
        mu4e-view-image-max-width 800
        mu4e-headers-auto-update t)

  ;; Usar msmtp para envio
  (setq message-send-mail-function 'message-send-mail-with-sendmail
        sendmail-program "/etc/profiles/per-user/andre/bin/msmtp"
        mail-specify-envelope-from t
        mail-envelope-from 'header)

  ;; ── Atalhos de pastas ───────────────────────────────────────────────
  ;; Os caminhos refletem a estrutura real do Maildir sincronizado via mbsync.
  ;; Gmail via mbsync cria: INBOX, [Gmail]/Sent Mail, [Gmail]/Drafts,
  ;;                          [Gmail]/Trash, [Gmail]/All Mail
  (setq mu4e-maildir-shortcuts
        '((:maildir "/gmail/INBOX"             :key ?g)
          (:maildir "/uspmail/INBOX"            :key ?u)
          (:maildir "/gmail/[Gmail]/Sent Mail"  :key ?G)
          (:maildir "/uspmail/[Gmail]/Sent Mail" :key ?U)
          (:maildir "/gmail/[Gmail]/Drafts"     :key ?d)
          (:maildir "/gmail/[Gmail]/All Mail"   :key ?a)))

  ;; ── Assinatura ──────────────────────────────────────────────────────
  (setq mu4e-compose-signature
        (concat
         "--\n"
         "Prof. Dr. André Machado Rodrigues\n"
         "Departamento de Física Aplicada\n"
         "Instituto de Física — Universidade de São Paulo\n"
         "Telefone: +55 (11) 3091-7108\n"
         "Sala: 3016 — Prédio Ala II\n"))

  ;; ── Contextos (contas) ──────────────────────────────────────────────
  ;; O contexto é selecionado automaticamente pelo prefixo do maildir
  (setq mu4e-contexts
        (list
         ;; Contexto USP (padrão)
         (make-mu4e-context
          :name "USP"
          :enter-func (lambda () (mu4e-message "Entrando no contexto USP"))
          :leave-func (lambda () (mu4e-message "Saindo do contexto USP"))
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/uspmail" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address    . "rodrigues.am@usp.br")
                  (user-full-name       . "André Machado Rodrigues")
                  (mu4e-sent-folder     . "/uspmail/[Gmail]/Sent Mail")
                  (mu4e-drafts-folder   . "/uspmail/[Gmail]/Drafts")
                  (mu4e-trash-folder    . "/uspmail/[Gmail]/Trash")
                  (mu4e-refile-folder   . "/uspmail/[Gmail]/All Mail")))

         ;; Contexto Gmail (pessoal)
         (make-mu4e-context
          :name "Gmail"
          :enter-func (lambda () (mu4e-message "Entrando no contexto Gmail"))
          :leave-func (lambda () (mu4e-message "Saindo do contexto Gmail"))
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/gmail" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address    . "rodrigues.am83@gmail.com")
                  (user-full-name       . "André Machado Rodrigues")
                  (mu4e-sent-folder     . "/gmail/[Gmail]/Sent Mail")
                  (mu4e-drafts-folder   . "/gmail/[Gmail]/Drafts")
                  (mu4e-trash-folder    . "/gmail/[Gmail]/Trash")
                  (mu4e-refile-folder   . "/gmail/[Gmail]/All Mail")))))

  ;; Política de contexto: usa o primeiro (USP) por padrão
  (setq mu4e-context-policy 'pick-first
        mu4e-compose-context-policy 'ask-if-none)

  ;; ── Bookmarks (atalhos na view principal) ────────────────────────────
  (setq mu4e-bookmarks
        '((:name "Unread (all)"
           :query "flag:unread AND NOT flag:trashed"
           :key ?U)
          (:name "Unread (Gmail)"
           :query "flag:unread AND NOT flag:trashed AND maildir:/gmail/"
           :key ?g)
          (:name "Unread (USP)"
           :query "flag:unread AND NOT flag:trashed AND maildir:/uspmail/"
           :key ?u)
          (:name "Today"
           :query "date:today..now"
           :key ?t)
          (:name "Last 7 days"
           :query "date:7d..now"
           :key ?w)
          (:name "Sent (all)"
           :query "maildir:/[Gmail]/Sent Mail"
           :key ?s)
          (:name "Attachments"
           :query "mime:application/pdf OR mime:application/zip"
           :key ?A)
          (:name "Flagged"
           :query "flag:flagged"
           :key ?f)))

  ;; ── Headers view: colunas e aparência ────────────────────────────────
  (setq mu4e-headers-fields
        '((:human-date    . 12)
          (:flags         .  6)
          (:mailing-list  . 10)
          (:from          . 25)
          (:subject       . 60)))

  (setq mu4e-headers-date-format "%d/%m/%Y"
        mu4e-headers-time-format "%H:%M")

  ;; ── View: ao abrir mensagem ─────────────────────────────────────────
  (setq mu4e-view-fields
        '(:from :to :cc :subject :flags :date :maildir
          :mailing-list :tags :attachments :signature))

  ;; Não confirmar ao sair do compose
  (setq mu4e-compose-dont-reply-to-self t)

  ;; ── Headers: ações rápidas ───────────────────────────────────────────
  ;; Marcar como lido ao arquivar
  (add-to-list 'mu4e-header-info-custom
               '(:empty . (:name "empty"
                           :shortname ""
                           :function (lambda (msg) ""))))
  ;; Navegação: abrir links no browser padrão
  (setq browse-url-browser-function 'browse-url-default-browser)

  ;; ── Flyspell no compose ─────────────────────────────────────────────
  (add-hook 'mu4e-compose-mode-hook
            (lambda ()
              (flyspell-mode 1)
              (set-fill-column 72))))

(use-package! mu4e-alert
  :after mu4e
  :config
   (setq mu4e-alert-interesting-mail-query
        "flag:unread AND NOT flag:trashed")
  (mu4e-alert-enable-mode-line-display)
  (mu4e-alert-enable-notifications))

(use-package! gptel
  :commands (gptel gptel-menu gptel-send)
  :bind (("M-p g" . gptel-menu))
  :custom
  (gptel-model "xiaomi/mimo-v2-pro")
  (gptel-default-mode 'org-mode)
  (gptel-directives
   '((default . "Responda de maneira consisa na mesma língua em que foi perguntado.")
     (writing . "Responda de maneira consisa na mesma língua em que foi perguntado.")
     (programming . "Você é um programador experiênte que gosta muito de elisp.")
     (chat . "Responda de maneira consisa na mesma língua em que foi perguntado.")))
  :config
  (gptel-make-ollama
      "Ollama"
    :host "localhost:11434"
    :stream t
    :key (lambda ()
           (let ((match (auth-source-search :host "ollama.com" :user "ollama_key")))
             (if match
                 (let ((secret (plist-get (car match) :secret)))
                   (if (functionp secret) (funcall secret) secret))
               (error "API Key para Ollama não encontrada no auth-source!"))))
    :models '(qwen3.5:9b
              qwen3.5:4b
              gemma4:e4b
              gemma4:31b
              granite3.3:8b
              translategemma:12b
              deepseek-ocr:3b
              glm-5.1:cloud
              minimax-m2.7:cloud
              gemma4:31b-cloud
              qwen3.5:cloud ))

  (gptel-make-openai
      "OpenRouter"
    :host "openrouter.ai"
    :endpoint "/api/v1/chat/completions"
    :stream t
    :key (lambda ()
           (let ((match (auth-source-search :host "openrouter.ai" :user "emacs_key")))
             (if match
                 (let ((secret (plist-get (car match) :secret)))
                   (if (functionp secret) (funcall secret) secret))
               (error "API Key para OpenRouter não encontrada no auth-source!"))))
    :models '(google/gemma-4-26b-a4b-it
              google/gemma-4-31b-it
              qwen/qwen3.6-plus
              xiaomi/mimo-v2-pro
              stepfun/step-3.5-flash:free
              deepseek/deepseek-v3.2
              minimax/minimax-m2.5
              z-ai/glm-5-turbo
              anthropic/claude-sonnet-4.6
              anthropic/claude-opus-4.6
              google/gemini-3-flash-preview
              minimax/minimax-m2.7
              moonshotai/kimi-k2.5
              openai/gpt-5.4
              openai/gpt-5.4-nano
              qwen/qwen3.5-35b-a3b))

        (gptel-make-openai "Hermes"
    :host "192.168.15.4:8642"
    :key "hermes-api-key-33b371c0310bf7d3"
    :stream t
    :models '("qwen/qwen3.6-plus")
    :endpoint "/v1/chat/completions"))

(use-package telega
  :defer t
  :config
  (setq telega-skip-confirm-destroy-root t)
  ;; O bot token ja esta no container.
  ;; Para usar telega com a conta pessoal, configure o TDLib.
  ;; Para usar o bot, use: telega-bot
  )

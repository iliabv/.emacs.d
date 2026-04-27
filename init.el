;; init.el --- description -*- lexical-binding: t; -*-
;;; Commentary:
;;; Hello there!
;;; Code:

(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("melpa" . "https://melpa.org/packages/")))

(unless package--initialized (package-initialize))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(load "~/.emacs.d/custom/funcs.el")

(if (eq system-type 'darwin)
  (set-face-attribute 'default nil :family "IosevkaTerm Nerd Font Mono" :height 160)
  (set-face-attribute 'default nil :family "IosevkaTerm Nerd Font Mono" :height 160))

;; (if (eq system-type 'darwin)
;;   (setq image-types (cons 'svg image-types)))

(when window-system
  (scroll-bar-mode 0)
  (tool-bar-mode 0)
  (tooltip-mode 0))

(menu-bar-mode 0)

(setq-default
 gc-cons-threshold 100000000
 read-process-output-max (* 1024 1024)
 ad-redefinition-action 'accept
 auto-window-vscroll nil
 cursor-in-non-selected-windows t
 delete-by-moving-to-trash t
 display-time-default-load-average nil
 display-time-format "%H:%M"
 fill-column 80
 help-window-select t
 indent-tabs-mode nil
 inhibit-startup-screen t
 initial-scratch-message ""
 initial-buffer-choice nil
 initial-major-mode 'fundamental-mode
 create-lockfiles nil
 mouse-yank-at-point t
 recenter-positions '(5 top bottom)
 scroll-conservatively most-positive-fixnum
 select-enable-clipboard t
 sentence-end-double-space nil
 show-trailing-whitespace nil
 split-height-threshold nil
 split-width-threshold nil
 tab-width 4
 uniquify-buffer-name-style 'forward
 window-combination-resize t
 enable-dir-local-variables nil
 enable-local-variables :safe
 enable-recursive-minibuffers t
 truncate-lines t
 x-stretch-cursor t)

(global-hl-line-mode 1)
(global-auto-revert-mode 1)
(global-so-long-mode 1)
(show-paren-mode 1)
(delete-selection-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)
(mouse-avoidance-mode 'none)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(set-default-coding-systems 'utf-8)

(setq read-extended-command-predicate #'command-completion-default-include-p)

(setq ring-bell-function 'p-flash-modeline)

(add-hook 'xref-after-jump-hook #'recenter)
(add-hook 'prog-mode-hook 'p-show-trailing-whitespace)
(add-hook 'prog-mode-hook 'p-enable-scroll-margin)
(add-hook 'comint-mode-hook 'p-disable-scroll-margin)

(setq vc-handled-backends '(Git))

(use-package project
  :config
  (setq project-switch-commands 'affe-find)
  (setq project-vc-extra-root-markers
        '("Cargo.toml" "go.mod" "package.json" "pyproject.toml"
          "BUILD" "BUILD.bazel" "MODULE.bazel"))
  (setq project-vc-include-untracked nil))

(use-package exec-path-from-shell
  :config
  (setq exec-path-from-shell-arguments '("-l" "-i"))
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package all-the-icons)

(use-package doom-themes
  :config
  (load-theme 'doom-one-light t)
  (doom-themes-visual-bell-config))

(use-package solaire-mode
  :after (doom-themes)
  :hook
  ((change-major-mode after-revert ediff-prepare-buffer) . turn-on-solaire-mode)
  ;; (minibuffer-setup . solaire-mode-in-minibuffer)
  :init
  (solaire-global-mode +1))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :init
  (setq doom-modeline-icon nil)
  (unless window-system
    (setq doom-modeline-height 30)
    (set-face-attribute 'mode-line nil :height 135)
    (set-face-attribute 'mode-line-inactive nil :height 135))
  (setq doom-modeline-buffer-file-name-style 'file-name)
  (add-hook 'doom-modeline-mode-hook 'p-set-custom-doom-modeline)
  :config
  (doom-modeline-def-modeline 'p-custom
    '(bar modals matches buffer-info remote-host buffer-position selection-info)
    '(misc-info debug major-mode process vcs "  ")))

(defun p-set-custom-doom-modeline ()
  (doom-modeline-set-modeline 'p-custom 'default))

(use-package dashboard
  :config
  (setq dashboard-items '((recents  . 10)
                          (projects . 5)
                          (bookmarks . 5)))
  (dashboard-setup-startup-hook))

(use-package recentf
  :config
  (recentf-mode 1)
  (setq recentf-max-menu-items 50)
  (run-with-idle-timer (* 5 60) t 'recentf-save-list))

(use-package evil
  :init
  (setq evil-want-C-u-scroll t
        evil-want-visual-char-semi-exclusive t
        evil-respect-visual-line-mode t
        evil-search-module 'evil-search
        evil-want-keybinding nil
        evil-symbol-word-search t)
  :config
  (evil-mode 1)
  (advice-add 'evil-ex-search :after (lambda (&rest _) (recenter))))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package expand-region)

(use-package anzu
  :config
  (global-anzu-mode 1)
  (global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)
  (global-set-key [remap query-replace] 'anzu-query-replace))

(use-package evil-anzu)

(use-package consult
  :ensure t
  :config
  (setq consult-narrow-key "<"))

(use-package affe
  :config
  (setq affe-count 1000))

(use-package embark
  :ensure t
  :demand t)

(use-package embark-consult
  :ensure t)

(use-package wgrep
  :ensure t)

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  (add-hook 'minibuffer-setup-hook #'vertico-repeat-save)
  (setq vertico-count 25))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless)))

(use-package flyspell
  :init
  (add-hook 'prog-mode-hook 'flyspell-prog-mode)
  (add-hook 'text-mode-hook 'turn-on-flyspell))

(use-package treemacs
  :defer t
  :commands (treemacs treemacs-find-file)
  :init
  (setq treemacs-width                       40
        treemacs-position                    'left
        treemacs-show-hidden-files           t
        treemacs-follow-after-init           t
        treemacs-recenter-after-file-follow  'on-distance
        treemacs-eldoc-display               'simple)
  :config
  (treemacs-follow-mode t)
  (treemacs-project-follow-mode t)
  (treemacs-git-mode 'deferred))

(use-package treemacs-evil  :after (treemacs evil))
(use-package treemacs-magit :after (treemacs magit))

(use-package treemacs-nerd-icons
  :after treemacs
  :config (treemacs-load-theme "nerd-icons"))

(use-package evil-nerd-commenter
  :commands (evilnc-comment-or-uncomment-lines))

(use-package buttercup)

(use-package bpr
  :commands (bpr-spawn bpr-open-last-buffer)
  :config
  (setq bpr-colorize-output t)
  (setq bpr-on-start 'p-bpr-set-comint-filter))

(use-package magit
  :init
  (setq magit-refresh-status-buffer nil)
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package diff-hl
  :hook (prog-mode . turn-on-diff-hl-mode)
  :init
  (setq diff-hl-fringe-bmp-function 'diff-hl-fringe-bmp-from-type)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(use-package color-identifiers-mode
  :commands (color-identifiers-mode))

(use-package shackle
  :config
  (setq shackle-rules
        '(("\\*helm.*?\\*" :regexp t :align t :size 0.5)
          ("\\*term:.*?\\*" :regexp t :align t :select t :size 0.6)
          ("\\*.*\\*" :regexp t :align t :select t :size 0.5)))
  (shackle-mode))

(use-package emmet-mode
  :hook (css-mode html-mode rjsx-mode web-mode)
  :config
  (setq
   emmet-insert-flash-time .1
   emmet-move-cursor-between-quote t))

(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :config
  (setq yas-snippet-dirs `(,(expand-file-name "snippets/" user-emacs-directory)))
  (yas-reload-all))

(use-package editorconfig
  :config
  (editorconfig-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package electric
  :hook (prog-mode . electric-indent-mode))

(use-package elec-pair
  :hook (prog-mode . electric-pair-mode))

(use-package files
  :ensure nil
  :config
  (setq-default
   backup-by-copying t
   backup-directory-alist `(("." . ,(expand-file-name "backups/" user-emacs-directory)))
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t))

(use-package org)

(use-package evil-org
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook (lambda () (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package restclient
  :commands (restclient-mode))

(use-package eglot
  :ensure nil
  :hook ((glsl-mode lua-mode js-mode js-ts-mode
          python-mode python-ts-mode
          java-mode java-ts-mode
          typescript-mode typescript-ts-mode tsx-ts-mode
          elixir-mode web-mode
          go-mode go-ts-mode
          zig-mode rustic-mode rust-ts-mode
          scala-ts-mode)
         . eglot-ensure)
  :init
  (add-to-list 'exec-path "/home/ibabanov/projects/elixir-ls/release")
  :config
  (add-to-list 'eglot-server-programs '(glsl-mode . ("glsl_analyzer")))
  (add-to-list 'eglot-server-programs '(zig-mode . ("/usr/bin/zls")))
  (setq-default eglot-workspace-configuration
                '(:rust-analyzer (:procMacro (:enable t))))
  (setq eglot-autoshutdown t))

(use-package glsl-mode)


(use-package corfu
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin
  ;; Enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))
  ;; Recommended: Enable Corfu globally.  This is recommended since Dabbrev can
  ;; be used globally (M-/).  See also the customization variable
  ;; `global-corfu-modes' to exclude certain modes.
  :init
  (setq tab-always-indent 'complete)
  (setq corfu-popupinfo-delay 0.5)
  (corfu-echo-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode)
  (global-corfu-mode))

(use-package kdl-mode
  :ensure t
  :mode "\\.kdl\\'")

(use-package js2-mode
  :mode "\\.js\\'"
  :config
  (setq js2-idle-timer-delay 0)
  (setq js2-strict-trailing-comma-warning nil)
  (setq js2-strict-missing-semi-warning nil)
  (setq js2-mode-show-parse-errors nil)
  (setq js2-mode-show-strict-warnings nil))

(use-package skewer-mode
  :commands (run-skewer))

(use-package web-beautify
  :commands (web-beautify-js web-beautify-css web-beautify-html))

(use-package json-mode
  :mode "\\.json\\'")

(use-package rjsx-mode
  :mode "\\.jsx\\'")

(use-package typescript-mode
  :mode "\\.ts\\'")

(use-package rustic
  :init
  (setq rustic-lsp-client 'eglot))

(use-package pipenv
  :hook (python-mode . pipenv-mode))

(use-package csv-mode
  :mode "\\.csv\\'")

(use-package lua-mode
  :mode "\\.lua\\'")

(use-package dockerfile-mode
  :mode "Dockerfile\\'")

(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(use-package web-mode
  :mode ("\\.erb\\'" "\\.mustache\\'" "\\.vue\\'" "\\.html?\\'" "\\.php\\'" "\\.inc\\'" "\\.tmpl\\'" "\\.html\\.eex\\'" "\\.jsx\\'"))

(use-package go-mode
  :mode "\\.go\\'"
  :hook (before-save-hook . gofmt-before-save))

(use-package zig-mode
  :mode "\\.zig\\'")

(use-package elixir-mode
  :mode "\\.ex\\'"
  :init
  (defface p-elixir-atom-face
    '((((class color) (background light)) :foreground "RoyalBlue4")
      (((class color) (background dark)) :foreground "light sky blue")
      (t nil))
    "For use with atoms & map keys."
    :group 'font-lock-faces)
  (setq elixir-atom-face 'p-elixir-atom-face))

;; --- Tree-sitter grammars and *-ts-mode routing ---
;; Place this AFTER all conflicting language use-packages so its
;; auto-mode-alist prepends win the lookup.
(use-package treesit
  :ensure nil
  :when (treesit-available-p)
  :init
  (setq treesit-language-source-alist
        '((tsx        . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
          (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
          (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "master" "src"))
          (json       . ("https://github.com/tree-sitter/tree-sitter-json"))
          (css        . ("https://github.com/tree-sitter/tree-sitter-css"))
          (html       . ("https://github.com/tree-sitter/tree-sitter-html"))
          (yaml       . ("https://github.com/ikatyang/tree-sitter-yaml"))
          (bash       . ("https://github.com/tree-sitter/tree-sitter-bash"))
          (go         . ("https://github.com/tree-sitter/tree-sitter-go"))
          (gomod      . ("https://github.com/camdencheek/tree-sitter-go-mod"))
          (rust       . ("https://github.com/tree-sitter/tree-sitter-rust"))
          (python     . ("https://github.com/tree-sitter/tree-sitter-python"))
          (java       . ("https://github.com/tree-sitter/tree-sitter-java"))
          (scala      . ("https://github.com/tree-sitter/tree-sitter-scala"))
          (toml       . ("https://github.com/tree-sitter/tree-sitter-toml"))
          (starlark   . ("https://github.com/amaanq/tree-sitter-starlark"))))
  :config
  ;; One-shot install per machine. Skips already-installed grammars.
  (dolist (lang (mapcar #'car treesit-language-source-alist))
    (unless (treesit-language-available-p lang)
      (condition-case err
          (treesit-install-language-grammar lang)
        (error (message "treesit: failed to install %s: %S" lang err)))))
  ;; Redirect explicit invocations of legacy modes to their ts-mode forms.
  (dolist (mapping '((typescript-mode . typescript-ts-mode)
                     (js-mode         . js-ts-mode)
                     (json-mode       . json-ts-mode)
                     (css-mode        . css-ts-mode)
                     (yaml-mode       . yaml-ts-mode)
                     (python-mode     . python-ts-mode)
                     (go-mode         . go-ts-mode)
                     (java-mode       . java-ts-mode)
                     (sh-mode         . bash-ts-mode)))
    (add-to-list 'major-mode-remap-alist mapping))
  ;; Route file extensions to ts-mode forms (prepend → wins over earlier
  ;; entries from web-mode/typescript-mode/json-mode/yaml-mode/etc.).
  (dolist (entry '(("\\.tsx\\'"            . tsx-ts-mode)
                   ("\\.ts\\'"             . typescript-ts-mode)
                   ("\\.rs\\'"             . rust-ts-mode)
                   ("\\.go\\'"             . go-ts-mode)
                   ("/go\\.mod\\'"         . go-mod-ts-mode)
                   ("\\.java\\'"           . java-ts-mode)
                   ("\\.py[iw]?\\'"        . python-ts-mode)
                   ("\\.toml\\'"           . toml-ts-mode)
                   ("/Cargo\\.lock\\'"     . toml-ts-mode)))
    (add-to-list 'auto-mode-alist entry)))

;; Scala and Bazel don't ship with built-in *-ts-mode; use external packages.
(use-package scala-ts-mode
  :mode ("\\.scala\\'" "\\.sbt\\'"))

(use-package bazel)

(use-package evil-cleverparens
  :hook (emacs-lisp-mode . evil-cleverparens-mode))

(use-package which-key
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode))

(use-package general
  :config
  (general-define-key
   "C-<return>" '(embark-act :which-key "embark")
   "C-s-<return>" '(embark-export :which-key "embark export")
   "<escape>" '(p-quit :which-key "escape")
   "s-m" '(consult-buffer :which-key "buffers list")
   "M-u" '(universal-argument :which-key "universal argument"))

  (general-define-key
   :states '(normal visual insert emacs treemacs)
   :keymaps '(global override)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"

   "SPC" '(execute-extended-command :which-key "M-x")
   "TAB" '(switch-to-prev-buffer :which-key "previous buffer")
   "RET" '(embark-act :which-key "bookmark")
   "/"   '(consult-ripgrep :which-key "search in project")
   "a"   '(consult-buffer :which-key "buffers list")
   "m"   '(consult-buffer :which-key "buffers list")
   ";"   '(evilnc-comment-or-uncomment-lines :which-key "comment")
   "."   '(find-file :which-key "find files")

   "bk"  '(kill-current-buffer :which-key "kill this buffer")
   "bb"  '(consult-bookmark :which-key "bookmark")

   "cc"  '(xref-find-definitions :which-key "go to definition")
   "cd"  '(xref-find-definitions :which-key "go to definition")
   "cb"  '(evil-jump-backward :which-key "jump backward")
   "ca"  '(eglot-code-actions :which-key "execute code action")
   "ci"  '(eglot-find-implementation :which-key "go to implementation")
   "cf"  '(xref-find-references :which-key "find references")
   "cr"  '(eglot-rename :which-key "rename")
   "ch"  '(eldoc-doc-buffer :which-key "docs")
   "ce"  '(flymake-show-buffer-diagnostics :which-key "list errors")
   "co"  '(consult-outline :which-key "outline")

   "ff"  '(find-file :which-key "find files")
   "fp"  '(affe-find :which-key "find files in project")
   "fy"  '(p-copy-file-name-and-line-number :which-key "copy file name and line number")
   "fs"  '(p-flyspell-save-word :which-key "flyspell save word")

   "gg"  '(magit :which-key "magit")
   "gs"  '(magit :which-key "magit")
   "gb"  '(magit-blame :which-key "git blame")
   "gl"  '(magit-log-buffer-file :which-key "log current file")
   "gm"  '(p-shell-show-mine-commits :which-key "show mine commits")

   "pf"  '(affe-find :which-key "find files in project")
   "pp"  '(project-switch-project :which-key "switch project")

   "tt"  '(treemacs :which-key "toggle treemacs")
   "tf"  '(treemacs-find-file :which-key "show file in treemacs")
   "tl"  '(toggle-truncate-lines :which-key "toggle line wrapping")

   "qz"  '(delete-frame :which-key "delete frame")
   "qq"  '(kill-emacs :which-key "quit")

   "hh"  '(apropos :which-key "apropos")
   "jk"  '(consult-yank-from-kill-ring :which-key "yank from kill ring")
   "jh"  '(vertico-repeat :which-key "resume last veritco session")
   "jj"  '(vertico-repeat-select :which-key "choose veritco session")
   "jn"  '(p-npm-build :which-key "run npm build")
   "ji"  '(gptel-send :which-key "GPTel send")
   "jm"  '(gptel-menu :which-key "GPTel menu")
   "ja"  '(gptel-abort :which-key "GPTel abort")

   "jr"  '(p-love-run :which-key "run love in the current project")
   "jl"  '(agent-shell-toggle :which-key "toggle agent shell")

   "wl"  '(windmove-right :which-key "move right")
   "wh"  '(windmove-left :which-key "move left")
   "wk"  '(windmove-up :which-key "move up")
   "wj"  '(windmove-down :which-key "move bottom")
   "wL"  '(evil-window-move-far-right :which-key "move window right")
   "wH"  '(evil-window-move-far-left :which-key "move window left")
   "wK"  '(evil-window-move-very-top :which-key "move window up")
   "wJ"  '(evil-window-move-very-bottom :which-key "move window bottom")
   "wv"  '(p-split-window-right :which-key "split right")
   "ws"  '(p-split-window-below :which-key "split bottom")
   "+"   '(p-enlarge-window-right :which-key "enlarge window")
   "-"   '(p-shrink-window-right :which-key "shrink window")
   "wb"  '(balance-windows :which-key "balance windows")
   "wo"  '(delete-other-windows :which-key "delete other windows")
   "wc"  '(delete-window :which-key "delete window"))

  (general-define-key
    :states 'normal
    "C-u" '(evil-scroll-up :which-key "scroll up")
    "<escape>" '(p-quit :which-key "escape"))

  (general-define-key
   :states 'insert
   "C-v" '(yank :which-key "yank"))

  (general-define-key
    :states 'visual
    "<backspace>" '(delete-region :which-key "delete region (skip kill ring)")
    "v" '(er/expand-region :which-key "expand region")
    "V" '(er/contract-region :which-key "contract region"))

  (general-define-key
    :keymaps 'comint-mode-map
    "<up>" '(comint-previous-input :which-key "history prev")
    "<down>" '(comint-next-input :which-key "history next"))

  (general-define-key
   :keymaps '(transient-map transient-edit-map)
   "<escape>" 'transient-quit-one)

  (general-define-key
   :keymaps 'transient-sticky-map
   "<escape>" 'transient-quit-seq))

(define-key evil-normal-state-map [escape] 'p-quit)

(setq custom-file (expand-file-name ".custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(provide 'init)

;;; init.el ends here

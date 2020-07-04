(defun p-eshell-prompt-function ()
  (concat
   (propertize (eshell/dirs) 'face `(:foreground "cornflower blue"))
   (propertize "$ " 'face `(:foreground "green"))))

(defun p-enable-evil-normal-state ()
  (unless (member major-mode evil-normal-state-modes)
    (message "Dynamically set evil state to 'normal for %s" (buffer-name))
    (evil-set-initial-state major-mode 'normal)))

(defun p-enable-evil-emacs-state ()
  (unless (member major-mode evil-emacs-state-modes)
    (message "Dynamically set evil state to 'emacs for %s" (buffer-name))
    (evil-set-initial-state major-mode 'emacs)))

(defun p-enable-scroll-margin ()
  (make-variable-buffer-local 'scroll-margin)
  (setq scroll-margin 10))

(defun p-disable-scroll-margin ()
  (make-variable-buffer-local 'scroll-margin)
  (setq scroll-margin 0))

(defun p-delete-tern-process ()
  "Deletes tern process (after that, tern restarts automatically)"
  (interactive)
  (delete-process "Tern"))

(defun p-term (name)
  "Open term buffer with given name"
  (interactive "sName: ")
  (unless (get-buffer name) (vterm name))
  (display-buffer name))

(defun p-term-in-project ()
  "Open term buffer in current project"
  (interactive)
  (let* ((default-directory (or (projectile-project-root) default-directory))
         (buf-name (concat "*term:" (abbreviate-file-name default-directory) "*")))
    (unless (get-buffer buf-name) (vterm buf-name))
    (display-buffer buf-name)))

(defun p-npm-build ()
  "Runs 'npm run build' command"
  (interactive)
  (let ((bpr-scroll-direction -1))
    (bpr-spawn "npm run build")))

(defvar p-boo-role "app"
  "Default role for p-boo* commands")

(defun p-boo-set-role (role)
  "Sets default role for p-boo* commands"
  (interactive "sRole: ")
  (setq p-boo-role role))

(defun p-boo-run (command project)
  "Runs 'boo [command] [project]"
  (let ((bpr-scroll-direction -1))
    (bpr-spawn (concat "boo " command " " project))))

(defun p-boo-restart ()
  "Runs 'boo restart ROLE'"
  (interactive)
  (p-boo-run "restart" p-boo-role))

(defun p-boo-sync ()
  "Runs 'boo sync ROLE'"
  (interactive)
  (p-boo-run "sync" p-boo-role))

(defun p-boo-sync-restart ()
  "Runs 'boo sync ROLE && boo restart ROLE'"
  (interactive)
  (bpr-spawn (concat "boo sync " p-boo-role " && boo restart " p-boo-role)))

(defun p-boo-concat ()
  "Runs 'boo concat ROLE'"
  (interactive)
  (bpr-spawn (concat "boo sync " p-boo-role " && boo concat " p-boo-role)))

(defun p-bpr-package-tests ()
  "Tests emacs-bpr package"
  (interactive)
  (let* ((bpr-process-directory "~/projects/emacs-bpr/")
         (bpr-scroll-direction -1))
    (bpr-spawn "cask exec buttercup -L .")))

(defun p-restart-wifi-osx ()
  "Restarts wifi on osx"
  (interactive)
  (let* ((bpr-process-directory "~/"))
    (bpr-spawn "networksetup -setairportpower en0 off; sleep 4; networksetup -setairportpower en0 on")))

(defun p-bpr-open-last-buffer ()
  "Open last BPR buffer and select it."
  (interactive)
  (if (buffer-live-p bpr-last-buffer)
    (let ((window (split-window-vertically)))
      (set-window-buffer window bpr-last-buffer)
      (select-window window)
      (evil-normal-state))
    (message "Can't find last used buffer")))

(defun p-flyspell-save-word ()
  "Saves word to flyspell current dictionary"
  (interactive)
  (let ((current-location (point))
        (word (flyspell-get-word)))
    (when (consp word)
      (message "Saving word '%s' to dictionary" (car word))
      (flyspell-do-correct 'save nil
                           (car word)
                           current-location
                           (cadr word)
                           (caddr word)
                           current-location))))

(defun p-eval-line (eval-region)
  "Evaluates current line"
  (save-mark-and-excursion
    (end-of-line)
    (set-mark (line-beginning-position))
    (call-interactively eval-region)))

(defun p-eval-region-or-line (eval-region)
  "Evaluates active region or current line"
  (if (use-region-p)
      (call-interactively eval-region)
    (p-eval-line eval-region)))

(defun p-eval-py ()
  "Evaluatetes active region or current line as python code"
  (interactive)
  (p-eval-region-or-line 'python-shell-send-region))

(defun p-copy-to-clipboard (text)
  "Copies text to clipboard"
  (when text
    (kill-new text)
    (message "Text is copied to clipboard: %s" text)))

(defun p-get-file-name ()
  "Returns file path of the current buffer"
  (if (equal major-mode 'dired-mode)
      default-directory
    (buffer-file-name)))

(defun p-copy-file-name ()
  "Copies file name to clipboard"
  (interactive)
  (p-copy-to-clipboard (p-get-file-name)))

(defun p-copy-file-name-and-line-number ()
  "Copies file name with current line number to clipboard"
  (interactive)
  (p-copy-to-clipboard
   (concat (p-get-file-name) ":" (number-to-string (line-number-at-pos)))))

(defun p-magit-show-mine-commits ()
  "Logs mine commits"
  (interactive)
  (magit-log nil '("-n128" "--decorate" "--author=babanov")))

(defun p-shell-show-mine-commits ()
  "Logs mine commits"
  (interactive)
  (async-shell-command
   "git log --author='Ilya Babanov' --pretty=format:'%h - %an, %ar : %s' -n 10"))

(defun p-git-push ()
  "git pull && git push"
  (interactive)
  (bpr-spawn "git pull && git push"))

(defun p-git-pull ()
  "git pull"
  (interactive)
  (bpr-spawn "git pull"))

(defun p-insert-g-arg ()
  "Inserts ' -g*.' text"
  (interactive)
  (insert-for-yank " -g*"))

(defun p-insert-g-js-arg ()
  "Inserts ' -g*.js' text"
  (interactive)
  (insert-for-yank " -g*.js"))

(defun p-bpr-set-comint-filter (process)
  "Sets 'comint-output-filter to the process"
  (set-process-filter process 'comint-output-filter))

(defun p-evil-search-clear-highlight ()
  "Clear evil-search or evil-ex-search persistent highlights."
  (interactive)
  ;; (evil-search-highlight-persist-remove-all) ; `C-s' highlights
  (evil-ex-nohighlight))                     ; `/' highlights

(defun p-show-trailing-whitespace ()
  "Sets show-trailing-whitespace to t"
  (interactive)
  (setq show-trailing-whitespace t))

(defun p-toggle-show-trailing-whitespace ()
  "Toggles show-trailing-whitespace between t and nil"
  (interactive)
  (setq show-trailing-whitespace (not show-trailing-whitespace)))

(defun p-send-to-first-visible-shell ()
  (interactive)
  (if-let* ((comint-window (get-window-with-predicate 'p-is-comint-window)))
      (p-send-to-shell (buffer-name (window-buffer comint-window)))
    (message "No visible comint buffers")))

(defun p-is-comint-window (window)
  (with-current-buffer (window-buffer window)
    (derived-mode-p 'comint-mode)))

(defun p-send-to-shell (shell)
  (let ((string (p-get-string-based-on-context)))
    (process-send-string shell (p-format-string-for-process string))))

(defun p-get-string-based-on-context ()
  (if (use-region-p)
      (buffer-substring (region-beginning) (region-end))
    (thing-at-point 'line)))

(defun p-format-string-for-process (string)
  (concat string "\n"))

(defun p-quit ()
  (interactive)
  (evil-ex-nohighlight)
  (lsp-ui-doc-hide)
  (cond ((eq last-command 'mode-exited) nil)
	((region-active-p)
	 (deactivate-mark))
	((> (minibuffer-depth) 0)
	 (abort-recursive-edit))
	(current-prefix-arg
	 nil)
	((> (recursion-depth) 0)
	 (exit-recursive-edit))
	(buffer-quit-function
	 (funcall buffer-quit-function))
	((string-match "^\\*" (buffer-name (current-buffer)))
	 (delete-window))))

(defun p-flash-modeline ()
  "Set modeline foreground to red for 300 ms."
  (interactive)
  (let ((orig-fg (face-foreground 'mode-line)))
    (set-face-foreground 'mode-line "#F2804F")
    (run-with-idle-timer 0.3 nil
      (lambda (fg) (set-face-foreground 'mode-line fg))
      orig-fg)))

(defun p-split-window (splitter)
  "Create new window using SPLITTER function, select it, and open 'next' buffer in it."
  (let ((win (funcall splitter)))
    (select-window win)
    (next-buffer)))

(defun p-split-window-below ()
  "Create new window below the current one, select it, and open 'next' buffer in it."
  (interactive)
  (p-split-window 'split-window-below))

(defun p-split-window-right ()
  "Create new window to the right from the current one, select it, and open 'next' buffer in it."
  (interactive)
  (p-split-window 'split-window-right))

(defun p-enlarge-window-right ()
  "Enlarge current window horizontally."
  (interactive)
  (enlarge-window-horizontally 50))

(defun p-shrink-window-right ()
  "Shrink current window horizontally."
  (interactive)
  (shrink-window-horizontally 50))

(defun p-flycheck-use-eslint-from-node-modules ()
  "Ask flycheck to use eslint form local node_modules."
  (let* ((root (locate-dominating-file (or (buffer-file-name) default-directory) "node_modules"))
          (eslint (and root (expand-file-name "node_modules/eslint/bin/eslint.js" root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))

(provide 'funcs)
;;; funcs.el ends here

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-list
'(paredit ;; or personal preference. parinfer is also good
		cider
		clojure-mode
		nord-theme
		async
		ob-async
		ob-clojurescript
		org-babel-eval-in-repl
		eval-in-repl))

; activate all the packages
(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
(package-refresh-contents))

; install the missing packages
(dolist (package package-list)
(unless (package-installed-p package)
		(package-install package)))
(setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))
(use-package undo-fu) ;; Vim style undo not needed for emacs 28

(global-evil-leader-mode 1)
(evil-leader/set-leader "<SPC>")

(evil-leader/set-key
	"h" 'evil-window-left
	"j" 'evil-window-down
	"k" 'evil-window-up
	"l" 'evil-window-right

	"q" 'evil-window-delete
	"f" 'find-file
	"<SPC>" 'execute-extended-command
	"<RET>" 'org-open-at-point

	"H" 'evil-window-move-far-left
	"J" 'evil-window-move-very-bottom
	"K" 'evil-window-move-very-top
	"L" 'evil-window-move-far-right

	"w" 'save-buffer
	"b" 'switch-to-buffer
	"d" 'kill-buffer)


(define-key evil-normal-state-map (kbd "U") 'evil-redo)
(define-key evil-normal-state-map (kbd "J") 'scroll-up-line)
(define-key evil-normal-state-map (kbd "K") 'scroll-down-line)

(use-package evil
	:demand t
	:bind (("<escape>" . keyboard-escape-quit))
	:init
	(setq evil-wantintegration t
		evil-search-module 'evil-search
		evil-want-keybinding nil
		evil-undo-system 'undo-fu)
	:config
	(evil-mode 1))

;;; Vim Bindings Everywhere else
(use-package evil-collection
	:after evil
	:config
	(setq evil-want-integration t)
	(evil-collection-init))
(vertico-mode)
(linum-relative-mode)
(save-place-mode)
(global-auto-revert-mode t)

(blink-cursor-mode -1)
(tool-bar-mode -1)
(setq use-dialog-box nil)
(global-auto-revert-mode 1)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(server-start)
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-S-s") 'write-file)
;; (set-frame-font "Menlo 15" nil t)
(load-theme 'nord t)

(setq-default
 make-backup-files nil                            ; stop creating backup~ files
 auto-save-default nil                            ; stop creating #autosave# files
 create-lockfiles nil                             ; no lockfiles
 ad-redefinition-action 'accept                   ; Silence warnings for redefinition
 auto-window-vscroll nil                          ; Lighten vertical scroll
 confirm-kill-emacs 'yes-or-no-p                  ; Confirm before exiting Emacs
 display-time-default-load-average nil            ; Don't display load average
 display-time-mode 0                              ; Display time in frames
 display-time-format "%H:%M"                      ; Format the time string
 fill-column 80                                   ; Set width for automatic line breaks
 scroll-bar-mode nil
 help-window-select t                             ; Focus new help windows when opened
 inhibit-startup-screen t                         ; Disable start-up screen
 initial-scratch-message ""                       ; Empty the initial *scratch* buffer
 left-margin-width 1 right-margin-width 1         ; Add left and right margins
 mouse-yank-at-point t                            ; Yank at point rather than pointer
 ns-use-srgb-colorspace nil                       ; Don't use sRGB colors
 select-enable-clipboard t                        ; Merge system's and Emacs' clipboard
 sentence-end-double-space nil                    ; End a sentence after a dot and a space
 show-trailing-whitespace nil                     ; Display trailing whitespaces
 split-height-threshold nil                       ; Disable vertical window splitting
 split-width-threshold 1                          ; Disable horizontal window splitting
 tab-width 2                                      ; Set width for tabs
 uniquify-buffer-name-style 'forward              ; Uniquify buffer names
 window-combination-resize t                      ; Resize windows proportionally
 x-stretch-cursor t                               ; Stretch cursor to the glyph width
 scroll-step 1
 scroll-conservatively 10000)

(delete-selection-mode 1)                         ; Replace region when inserting text
(display-time-mode 0)                             ; Enable time in the mode-line
(fset 'yes-or-no-p 'y-or-n-p)                     ; Replace yes/no prompts with y/n
(menu-bar-mode 0)                                 ; Disable the menu bar
(put 'downcase-region 'disabled nil)              ; Enable downcase-region
(put 'upcase-region 'disabled nil)                ; Enable upcase-region
(set-default-coding-systems 'utf-8)               ; Default to utf-8 encoding
(add-hook 'focus-out-hook #'garbage-collect)
(setq nrepl-hide-special-buffers t
      cider-repl-clear-help-banner t
      cider-font-lock-dynamically nil
      cider-popup-stacktraces nil
      cider-repl-popup-stacktraces t
      cider-repl-use-pretty-printing t
      cider-repl-pop-to-buffer-on-connect t
      cider-repl-display-help-banner nil)

;; Allow cider-repl to be cleared with shortcut
(add-hook 'cider-repl-mode-hook
      '(lambda () (define-key cider-repl-mode-map (kbd "C-c M-b")
            'cider-repl-clear-buffer)))

(add-hook 'clojure-mode-hook #'cider-mode)

(add-hook 'cider-mode-hook (lambda () (show-paren-mode 1)))
(add-hook 'cider-mode-hook #'eldoc-mode)
(add-hook 'cider-mode-hook #'enable-paredit-mode)
(add-hook 'cider-repl-mode-hook #'enable-paredit-mode)
(add-hook 'cider-mode-hook #'imenu-add-menubar-index)
(add-hook 'clojurescript-mode #'enable-paredit-mode)
(require 'org)
(add-to-list 'org-modules 'org-tempo)
(setq org-startup-folded nil
		org-hide-emphasis-markers nil
		org-edit-src-content-indentation 0
		org-src-tab-acts-natively t
		org-src-fontify-natively t
		org-confirm-babel-evaluate nil
		org-support-shift-select 'always)

(add-hook 'org-mode-hook 'show-paren-mode)
(add-hook 'org-mode-hook 'turn-on-visual-line-mode)
(defun my-angle-bracket-fix ()
(modify-syntax-entry ?< "w")
(modify-syntax-entry ?> "w"))

(add-hook 'org-mode-hook 'my-angle-bracket-fix)
(defun my-paredit-in-code-block ()
(interactive)
(when (derived-mode-p 'org-mode)
		(unless (window-minibuffer-p)
		(if (org-babel-when-in-src-block)
				(paredit-mode 1)
				(paredit-mode 0)))))

(add-hook 'post-command-hook #'my-paredit-in-code-block)
;; Split Org Block using M-s
(define-key org-mode-map (kbd "M-s") 'org-babel-demarcate-block)

;; toggle paredit mode manually
(define-key org-mode-map (kbd "M-P") 'paredit-mode)
(remove-hook 'org-cycle-hook
						'org-optimize-window-after-visibility-change)
(eval-after-load 'org
(org-babel-do-load-languages
'org-babel-load-languages
'((clojure . t)
		(clojurescript . t)
		(emacs-lisp . t)
		(shell . t))))
(setq org-babel-clojure-backend 'cider
		org-babel-clojure-sync-nrepl-timeout nil)
(defun org-babel-expand-body:clojure (body params)
"Expand BODY according to PARAMS, return the expanded body."
(let* ((vars (org-babel--get-vars params))
				(ns (or (cdr (assq :ns params))
								(org-babel-clojure-cider-current-ns)))
				(result-params (cdr (assq :result-params params)))
				(print-level nil)
				(print-length nil)
				(body
				(org-trim
				(format "%s"
								;; Variables binding.
								(if (null vars) (org-trim body)
										(format "(let [%s]\n%s)"
														(mapconcat
														(lambda (var)
																(format "%S (quote %S)" (car var) (cdr var)))
														vars
														"\n      ")
														body))))))
		(if (or (member "code" result-params)
						(member "pp" result-params))
				(format "(clojure.pprint/pprint (do %s))" body)
		body)))
;; Sets M-<return> to evaluate code blocks in the REPL
(defun org-meta-return-around (org-fun &rest args)
"Run `ober-eval-in-repl' if in source code block,
`ober-eval-block-in-repl' if at header,
and `org-meta-return' otherwise."
		(if (org-in-block-p '("src"))
				(let* ((point (point))
						(element (org-element-at-point))
						(area (org-src--contents-area element))
						(beg (copy-marker (nth 0 area))))
				(if (< point beg)
						(ober-eval-block-in-repl)
						(ober-eval-in-repl)))
		(apply org-fun args)))

(advice-add 'org-meta-return :around #'org-meta-return-around)

;; Prevent eval in repl from moving cursor to the REPL
(with-eval-after-load "eval-in-repl"
(setq eir-jump-after-eval nil))
(defun org-babel-clojure-cider-current-ns ())

(defun tangle-on-save-org-mode-file ()
(when (and (string-match-p
						(regexp-quote ".org") (message "%s" (current-buffer)))
						(not (string-match-p
								(regexp-quote "[") (message "%s" (current-buffer)))))
		(org-babel-tangle)))

(add-hook 'after-save-hook 'tangle-on-save-org-mode-file)

(defun to-agenda-on-save-org-mode-file ()
(when (string= (message "%s" major-mode) "org-mode")
		(org-agenda-file-to-front)))

(add-hook 'after-save-hook 'to-agenda-on-save-org-mode-file)
(defun revert-all-buffers ()
"Refreshes all open buffers from their respective files."
(interactive)
(dolist (buf (buffer-list))
		(with-current-buffer buf
		(when (and (buffer-file-name)
		(file-exists-p (buffer-file-name))
		(not (buffer-modified-p)))
(revert-buffer t t t) )))
(message "Refreshed open files."))
(add-hook 'after-save-hook 'revert-all-buffers)
(setq help/default-gc-cons-threshold gc-cons-threshold)
(defun help/set-gc-cons-threshold (&optional multiplier notify)
"Set `gc-cons-threshold' either to its default value or a
`multiplier' thereof."
(let* ((new-multiplier (or multiplier 1))
				(new-threshold (* help/default-gc-cons-threshold
												new-multiplier)))
		(setq gc-cons-threshold new-threshold)
		(when notify (message "Setting `gc-cons-threshold' to %s"
												new-threshold))))
(defun help/double-gc-cons-threshold () "Double `gc-cons-threshold'." (help/set-gc-cons-threshold 2))
(add-hook 'org-babel-pre-tangle-hook #'help/double-gc-cons-threshold)
(add-hook 'org-babel-post-tangle-hook #'help/set-gc-cons-threshold)
(defun slurp (file)
(with-temp-buffer
		(insert-file-contents file)
		(buffer-substring-no-properties
		(point-min)
		(point-max))))
(defun template-reader (file replace)
(let ((lines (split-string (slurp file) "\n")))
		(->> lines
				(mapcar (lambda (x) (replace-regexp-in-string "_str_" replace x)))
				(mapcar (lambda (x) (concat x "\n")))
				(-concat)
				(apply 'concat))))
(define-skeleton cljc-lib-skeleton
"Inserts a .org template with user's project name input. 
Use in empty file and save to desired project directory.
Tangle will create project structure on save."
""
(template-reader "~/.emacs.d/templates/lib.org" (skeleton-read "Library name: ")))

(define-skeleton cljc-project-skeleton
"Inserts a .org template with user's project name input. 
Use in empty file and save to desired project directory.
Tangle will create project structure on save."
""
(template-reader "~/.emacs.d/templates/lib.org" (skeleton-read "Project name: ")))

(global-set-key (kbd "C-S-L") 'cljc-lib-skeleton)
(global-set-key (kbd "C-S-P") 'cljc-project-skeleton)

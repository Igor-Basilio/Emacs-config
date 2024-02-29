
;; straight.el config
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
;; Tell use-package to always use straight.el by default
(setq straight-use-package-by-default t)

(require 'rust-mode)
(require 'use-package)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes '(gruber-darker))
 '(custom-safe-themes
   '("ba4ab079778624e2eadbdc5d9345e6ada531dc3febeb24d257e6d31d5ed02577" default))
 '(dired-listing-switches "-lt")
 '(ispell-dictionary nil)
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/")))
 '(package-selected-packages
   '(markdown-mode powershell rust-mode glsl-mode rainbow-identifiers color-identifiers-mode modern-cpp-font-lock cmake-ide company flycheck irony evil gruber-darker-theme smex haskell-mode)))
(package-initialize)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'erase-buffer 'disabled nil)
(setq inhibit-startup-screen t)
(menu-bar-mode 0)
(tool-bar-mode 0)
(require 'ido)
(ido-mode t)
(set-frame-font "Ubuntu Mono-14")
(setq backup-directory-alist '(("." . "~/.emacs_saves")))

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; Enable Evil
(require 'evil)
(evil-mode 0)

;; Vim Movement JKLÇ keys without Evil
(defvar custom-keybindings-active-p nil)

(defun toggle-custom-keybindings ()
  (interactive)
  (if custom-keybindings-active-p
      (progn
        ;; Restore original keybindings
        (define-key key-translation-map (kbd "j") nil)
        (define-key key-translation-map (kbd "k") nil)
        (define-key key-translation-map (kbd "l") nil)
        (define-key key-translation-map (kbd "ç") nil)
	(define-key key-translation-map (kbd "C-j") nil)
        (define-key key-translation-map (kbd "C-k") nil)
        (define-key key-translation-map (kbd "C-l") nil)
        (define-key key-translation-map (kbd "C-ç") nil)
        (setq custom-keybindings-active-p nil))
    ;; Set custom keybindings
    (define-key key-translation-map (kbd "j") (kbd "<left>"))
    (define-key key-translation-map (kbd "k") (kbd "<up>"))
    (define-key key-translation-map (kbd "l") (kbd "<down>"))
    (define-key key-translation-map (kbd "ç") (kbd "<right>"))
    (define-key key-translation-map (kbd "C-j") (kbd "C-<left>"))
    (define-key key-translation-map (kbd "C-k") (kbd "C-<up>"))
    (define-key key-translation-map (kbd "C-l") (kbd "C-<down>"))
    (define-key key-translation-map (kbd "C-ç") (kbd "C-<right>"))
    (setq custom-keybindings-active-p t)))

(global-set-key (kbd "C-z") 'toggle-custom-keybindings)

(require 'cmake-ide)
(cmake-ide-setup)

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(global-display-line-numbers-mode)
(add-hook 'after-init-hook 'global-color-identifiers-mode)

(global-color-identifiers-mode)

(eval-after-load "dired-aux"
   '(add-to-list 'dired-compress-file-suffixes 
                 '("\\.zip\\'" ".zip" "unzip")))

(setq dired-listing-switches "-la")

;; Add Tcl mode for .do files
(add-to-list 'auto-mode-alist '("\\.do\\'" . tcl-mode))

;; Add Powershell highlighting for .ps1 files
(add-to-list 'auto-mode-alist '("\\.ps1\\'". powershell-mode))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Add Markdown highlighting for .md files
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))

;; Source bash profile to emacs
(setq shell-file-name "/bin/bash")
(setq shell-command-switch "-ic")

;; Package to deal with exec-paths
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; Set node to LST | i can't seem to get it to work with exec-path package
(setq exec-path (append exec-path '("~/.nvm/versions/node/v20.11.0/bin/node")))

;; Copilot Config
(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("dist" "*.el"))
  :ensure t)
(add-hook 'prog-mode-hook 'copilot-mode)

(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)
(define-key copilot-mode-map (kbd "<backtab>") 'copilot-complete)
(define-key copilot-mode-map (kbd "M-ç") 'copilot-next-completion)
(define-key copilot-mode-map (kbd "M-j") 'copilot-previous-completion)

(setq column-number-mode t)


;;(add-to-list 'load-path "~/emacs/")
;;(load "custom-file")

;; emacs-client start
;;(setq default-frame-alist '((cursor-color . "#FF00CD")))
(defun my/focus-new-client-frame ()
  (select-frame-set-input-focus (selected-frame)))
(add-hook 'server-after-make-frame-hook #'my/focus-new-client-frame)
(setq inhibit-x-resources 't)
;;(add-to-list 'default-frame-alist '(font . "Roboto Mono-13"))
;; emacs-client end

;; emacs startup
(setq-default inhibit-startup-screen t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(setq initial-major-mode 'fundamental-mode)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(line-number-mode t)
(show-paren-mode 1)
(delete-selection-mode 1)
(set-face-attribute 'region nil :background "#008080")
(global-set-key (kbd "M-o") 'other-window)
(setq overlay-arrow-string "") ;;arrow line in proof general
(global-set-key (kbd "C-M-d") 'down-list)
(global-set-key (kbd "C-M--") 'scroll-other-window-down)
;; emacs startup end

;; use `command` as `meta` in macOS.
(setq mac-command-modifier 'meta)
;; mac end

;; emacs custom files locations
(setq backup-directory-alist `(("." . "~/.saves")))
;;(setq custom-file "~/emacs/custom-file.el")
;; emacs custom files end

;; require and initialize package
(require 'package)
(package-initialize)

;; add melpa to archives
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
;; melpa end

;; install use-package (after melpa)
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))
;; install use-package end

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  )

;; theme 
(load-theme 'misterioso)
;; theme end

;; autocomplete company
(use-package company
    :ensure t
    :bind (:map company-active-map
		("C-n" . company-select-next)
		("C-p" . company-select-previous))
    :config
    (setq company-idle-delay 0.3)
    (global-company-mode t))
;; company end


;; magit start
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))
;; magit-end

;; smartparens
(use-package smartparens
  :ensure t
  :init
  (smartparens-global-mode))
;; smartparens end

;;disable mouse
;;(use-package disable-mouse
;;  :ensure t
;;  :init
(global-set-key [S-down-mouse-1] nil)
;;  (global-disable-mouse-mode))
;;disable mouse end

;; json start
(use-package json-mode
  :ensure t)
;; json end

;; ocaml begin
(and (require 'cl-lib)
      (use-package tuareg
        :ensure t
        :config
        (add-hook 'tuareg-mode-hook #'electric-pair-local-mode)
        ;; (add-hook 'tuareg-mode-hook 'tuareg-imenu-set-imenu)
        (setq auto-mode-alist
              (append '(("\\.ml[ily]?$" . tuareg-mode)
                        ("\\.topml$" . tuareg-mode))
                      auto-mode-alist)))
      
      (use-package merlin
        :ensure t
        :config
        (add-hook 'tuareg-mode-hook #'merlin-mode)
        (add-hook 'merlin-mode-hook #'company-mode)
        (setq merlin-error-after-save nil)
	(use-package flycheck-ocaml
	  :ensure t
	  :config
	  (flycheck-ocaml-setup)
	  (add-hook 'tuareg-mode-hook #'merlin-mode))
	)
      
      ;; utop configuration

      (use-package utop
        :ensure t
        :config
        (autoload 'utop-minor-mode "utop" "Minor mode for utop" t)
        (add-hook 'tuareg-mode-hook 'utop-minor-mode)
        )
      (use-package dune
	:ensure t)
      )

      ;;display type auto
      (use-package merlin-eldoc
       :ensure t
       :hook ((reason-mode tuareg-mode caml-mode) . merlin-eldoc-setup))
;; ocaml end

;;coq start
(use-package proof-general
  :ensure t
  :config
  (use-package company-coq
    :ensure t
    :config
    (add-hook 'coq-mod-hook #'company-coq-mod)))
;; coq end

;; projectile start
(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-x p") 'projectile-command-map)
  (projectile-mode +1))
;; PROJECTILE end

;;selectrum start
(use-package selectrum
  :ensure t
  :init
  (selectrum-mode +1)
  :config
  (use-package selectrum-prescient
    :ensure t
    :init
    (selectrum-prescient-mode +1)
    (prescient-persist-mode +1)))
;;selectrum end


;; html, json, js and css begin
(use-package web-mode
  :ensure t
  :mode ("\\.html$" . web-mode)
  :init
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq js-indent-level 2)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-auto-expanding t)
  (setq web-mode-enable-css-colorization t)
  (add-hook 'web-mode-hook 'electric-pair-mode))

(use-package web-beautify
  :ensure t
  :commands (web-beautify-css
             web-beautify-css-buffer
             web-beautify-html
             web-beautify-html-buffer
             web-beautify-js
             web-beautify-js-buffer))

(use-package emmet-mode
  :ensure t
  :diminish (emmet-mode . "ε")
  :bind* (("C-)" . emmet-next-edit-point)
          ("C-(" . emmet-prev-edit-point))
  :commands (emmet-mode
             emmet-next-edit-point
             emmet-prev-edit-point)
  :init
  (setq emmet-indentation 2)
  (setq emmet-move-cursor-between-quotes t)
  :config
  ;; Auto-start on any markup modes
  (add-hook 'sgml-mode-hook 'emmet-mode)
  (add-hook 'web-mode-hook 'emmet-mode))


(use-package nginx-mode
  :ensure t
  :commands (nginx-mode))

(use-package json-mode
  :ensure t
  :mode "\\.json\\'"
  :config
  (bind-key "{" #'paredit-open-curly json-mode-map)
  (bind-key "}" #'paredit-close-curly json-mode-map))
;; html, json, js and css end


(use-package bazel
  :ensure t
  )

(use-package treemacs
  :ensure t
  :bind
  (:map global-map
	([f8] . treemacs)
	("C-<f8>" . treemacs-select-window))
  :config
  (setq treemacs-is-never-other-window t))

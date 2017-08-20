;; fermat-mode.el -- Major mode for programming in Fermat computer algebra system
;; Author: Stephen D. Fox 
;; Created: 3/20/2011
;; Last updated: 9/9/12
;; Keywords: Fermat major-mode
;; For use with Fermat Computer Algebra System (http://home.bway.net/lewis/)

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of
;; the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU General Public License for more details.

;; You should have received a copy of the GNU General Public
;; License along with this program; if not, write to the Free
;; Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
;; MA 02111-1307 USA

;; This mode is based on the tutorial which can be found here:
;; http://two-wugs.net/emacs/mode-tutorial.html
;; Thanks to Scott Andrew Borton <scott@pp.htv.fi> for the tutorial

(defvar fermat-mode-hook nil)
(defvar fermat-mode-map
  (let ((fermat-mode-map (make-keymap)))
    (define-key fermat-mode-map "\C-m" 'newline-and-indent)
    fermat-mode-map)
  "Keymap for Fermat major mode")

;;#autoload fermat-mode command
;;I call fermat files anything that end in ".f"
;;You could change it to whatever extension you prefer to use.
;;If you would rather enter fermat-mode only manually, just comment this line out
(add-to-list 'auto-mode-alist '("\\.f\\'" . fermat-mode))


(defconst fermat-font-lock-keywords-1
  (list
   ; These are block font-lock keywords -- we will define our indentation on this as well
   '("\\<\\(\\.\\|Func\\(?:tion\\)?\\|do\\|f\\(?:i\\|or\\)\\|if\\|od\\|then\\|while\\|else\\)\\>" . font-lock-builtin-face)
   '("\\('\\w*\\)" . font-lock-variable-name-face))
  "Minimal highlighting for block expressions.")

(defconst fermat-font-lock-keywords-2
  (append fermat-font-lock-keywords-1
	  (list
	   '("\\<\\(A\\(?:ND\\|djoint\\|lt\\(?:mult\\|power\\)\\)\\|Bin\\|C\\(?:hpoly\\|o\\(?:deg\\|ef\\|l\\(?:reduce\\|s\\)\\|mpile\\|ntent\\)\\)\\|D\\(?:e\\(?:riv\\|[gt]\\)\\|i\\(?:ag\\|vides\\)\\)\\|Equal\\(?:neg\\)?\\|F\\(?:FLUC?\\|actor\\|lCoef\\)\\|GCD\\|H\\(?:ampath\\|e\\(?:ight\\|rmite\\)\\)\\|I\\(?:nteger\\|rred\\|szero\\)\\|L\\(?:CM\\|coef\\|evel\\|mon\\|o\\(?:g2\\|wer\\)\\|term\\)\\|M\\(?:Powermod\\|coef\\|fact\\|in\\(?:ors\\|poly\\)\\|o\\(?:d\\(?:mode\\|ulus\\)\\|ns\\|ve\\)\\)\\|N\\(?:ormalize\\|um\\(?:b\\|con\\|er\\|vars\\)\\)\\|OR\\|P\\(?:Divides\\|Root\\|owermod\\|r\\(?:ime\\|od\\)\\)\\|R\\(?:a\\(?:ise\\|nd\\|t\\)\\|coef\\|e\\(?:drowech\\|mquot\\)\\|owreduce\\)\\|S\\(?:Divide\\|igma\\|mith\\|parse\\|qfree\\|umup\\|w\\(?:ap\\|itch\\(?:col\\|row\\)\\)\\)\\|T\\(?:erms\\|otdeg\\|ra\\(?:ce\\|ns\\)\\)\\|Var\\)\\>" . font-lock-keyword-face)
	   '("\\<\\(True\\|False\\)\\>" . font-lock-constant-face)))
  "Additional Keywords to highlight in Fermat mode.")

(defvar fermat-font-lock-keywords fermat-font-lock-keywords-2
  "Default highlighting expressions for Fermat mode.")

(defun fermat-indent-line ()
  "Indent current line as fermat code."
  (interactive)
  (beginning-of-line)
  (if (bobp)
      (indent-line-to 0) ;; first line not indented
    (let ((not-indented t) cur-indent)
      (if (looking-at "^[ \t]*\\(fi\\|od\\|\\else\\|\\.\\)")
	  (progn
	    (save-excursion
	      (forward-line -1)
	      (setq cur-indent (- (current-indentation) default-tab-width)))
	    (if (< cur-indent 0)
		(setq cur-indent 0)))
	(save-excursion
	  (while not-indented
	    (forward-line -1)
	    (if (looking-at "^[ \t]*\\(fi\\|od\\|\\.\\)")
		(progn
		  (setq cur-indent (current-indentation))
		  (setq not-indented nil))
	      (if (looking-at "^[ \t]*\\(if\\|else\\|while\\|for\\|Function\\|Func\\)")
		  (progn
		    (setq cur-indent (+ (current-indentation) default-tab-width))
		    (setq not-indented nil))
		(if (bobp)
		    (setq not-indented nil)))))))
      (if cur-indent
	  (indent-line-to cur-indent)
	(indent-line-to 0)))))

(defvar fermat-mode-syntax-table
  (let ((fermat-mode-syntax-table (make-syntax-table)))
    (modify-syntax-entry ?_ "w" fermat-mode-syntax-table)
    (modify-syntax-entry ?{ "(}")
    (modify-syntax-entry ?} "){")
    fermat-mode-syntax-table)
  "Syntax Table for fermat-mode")

(defun fermat-mode ()
  (interactive)
  (kill-all-local-variables)
  (use-local-map fermat-mode-map)
  (set-syntax-table fermat-mode-syntax-table)
  (set (make-local-variable 'font-lock-defaults) '(fermat-font-lock-keywords))
  (set (make-local-variable 'indent-line-function) 'fermat-indent-line)
  (setq major-mode 'fermat-mode)
  (setq mode-name "fermat-el")
  (run-hooks 'fermat-mode-hook))

(provide 'fermat-mode)
;;fermat mode ends here

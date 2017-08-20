This provides fermat-mode for the Fermat Computer Algebra
System. Fermat was written and developed by Professor Robert H. Lewis
at Fordham University. It is the fastest computer algebra system for
polynomial and matrix computation.

Installation
============
Copy fermat.el to your ~/.emacs.d/styles/ directory

Copy these lines into your .emacs file:
(load-file "/home/stephen/.emacs.d/styles/fermat-style.el")
(add-to-list 'auto-mode-alist '("\\.f$" . fermat-mode))

Fermat
======
Fermat is an interpreted language with Pascal-like syntax.

Download is available from: https://home.bway.net/lewis/

Now go solve some crazy hard resultant problems that have been deemed
impossible computations for many!


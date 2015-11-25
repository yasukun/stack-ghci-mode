# stack-ghci-mode
Launch stack ghci in Emacs

## require

* [stack](http://docs.haskellstack.org/en/stable/README.html)
* haskell-mode


## git clone.

```bash
$ git clone https://github.com/yasukun/stack-ghci-mode
```

## append to .emacs

```elisp
(add-to-list 'load-path "/pathto/stack-ghci-mode/")
(autoload 'stack-ghci-mode "stack-ghci-mode" "Major mode for editing haskell." t)
(add-to-list 'auto-mode-alist '("\\.hs\\'" . stack-ghci-mode))

(add-hook 'stack-ghci-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'stack-ghci-mode-hook 'turn-on-haskell-indent)
(add-hook 'stack-ghci-mode-hook 'font-lock-mode)
(add-hook 'stack-ghci-mode-hook 'imenu-add-menubar-index)

```

## help

```
Major Mode Bindings Starting With C-c:
key             binding
---             -------

C-c C-b		stack-ghci-revert-buffer
C-c C-g		stack-ghci-repl
C-c C-l		stack-ghci-send-line
C-c C-r		stack-ghci-send-region
C-c C-s		stack-ghci-send-sprint
C-c C-t		stack-ghci-send-type

```

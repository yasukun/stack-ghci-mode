# stack-ghci-mode
Launch stack ghci in Emacs

```elisp
(add-to-list 'load-path "/pathto/stack-ghci-mode/")
(autoload 'stack-ghci-mode "stack-ghci-mode" "Major mode for editing haskell." t)
(add-to-list 'auto-mode-alist '("\\.hs\\'" . stack-ghci-mode))
```

#!/bin/bash

if [ ! -f ~/.spacemacs ]; then
    ln -s `pwd`/.spacemacs ~/
    echo "Linked ~/.spacemacs"
else
    echo "~/.spacemacs already exists"
fi

if [ ! -f ~/.emacs.d/private ]; then
    ln -s `pwd`/private ~/.emacs.d/
    echo "Linked ~/.emacs.d/private"
else
    echo "~/.emacs.d/private already exists"
fi

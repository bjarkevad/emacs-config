#!/bin/bash

if [ ! -f ~/.spacemacs ]; then
    ln -s `pwd`/.spacemacs ~/
    echo "Linked ~/.spacemacs"
else
    echo "~/.spacemacs already exists"
fi

if [ ! -d ~/.emacs.d/private ]; then
    ln -s `pwd`/private ~/.emacs.d/
    echo "Linked ~/.emacs.d/private"
else
    echo "~/.emacs.d/private already exists, deleting and linking"
    rm -rf ~/.emacs.d/private
    ln -s `pwd`/private ~/.emacs.d/
    echo "Linked ~/.emacs.d/private"
fi

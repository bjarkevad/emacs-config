#!/bin/bash

if [ ! -f ~/.spacemacs ]; then
    ln -s `pwd`/.spacemacs ~/
    echo "Linked ~/.spacemacs"
else
    echo "~/.spacemacs already exists"
fi

if [ ! -d ~/.emacsprivate/private ]; then
    ln -s `pwd`/private ~/.emacsprivate/
    echo "Linked ~/.emacsprivate/private"
else
    echo "~/.emacsprivate/private already exists, deleting and linking"
    rm -rf ~/.emacsprivate/private
    ln -s `pwd`/private ~/.emacsprivate/
    echo "Linked ~/.emacsprivate/private"
fi

if [ ! -d ~/.emacs.d/private/snippets/ ]; then
    ln -s `pwd`/private/snippets ~/.emacs.d/private/snippets
    echo "Linked ~/.emacs.d/private/snippets"
else
    echo "~/.emacs.d/private/snippets already exists, deleting and linking"
    rm -rf ~/.emacs.d/private/snippets
    ln -s `pwd`/private/snippets ~/.emacs.d/private/snippets
    echo "Linked ~/.emacs.d/private/snippets"
fi

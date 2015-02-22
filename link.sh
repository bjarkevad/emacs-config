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

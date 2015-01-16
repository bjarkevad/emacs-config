#!/bin/bash

cd ~/.emacs.d/
rm -rf private
git stash
git pull
cd ~/Workspace/emacs-config
./link.sh

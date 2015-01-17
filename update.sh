#!/bin/bash

configdir=`pwd`
cd ~/.emacs.d/
rm -rf private
git stash
git pull
git submodule sync
git submodule update
cd $configdir
echo $configdir
./link.sh

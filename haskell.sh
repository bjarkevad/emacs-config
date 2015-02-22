cabalDir=~/.cabal-emacs
if [ ! -d $cabalDir ]
then
    mkdir $cabalDir &&
    cd $cabalDir &&
    cabal sandbox init &&
    cabal update &&
    cabal install cabal-install-1.20.0.6 &&
    $cabalDir/.cabal-sandbox/bin/cabal install stylish-haskell hlint ghc-mod-5.2.1.2 &&

    echo "Installing ghci-ng" &&
    git clone https://github.com/chrisdone/ghci-ng.git &&
    $cabalDir/.cabal-sandbox/bin/cabal install ghci-ng/ && 
    echo "Update ~/.spacemacs with:" &&
    echo "(defun dotspacemacs/init ()"  &&
    echo "(add-to-list 'exec-path \"$cabalDir/.cabal-sandbox/bin/\"))"
else
    echo "Cabal directory already exists, aborting"
fi


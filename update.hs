#!/usr/bin/env runhaskell

{-# LANGUAGE OverloadedStrings #-}

import           Control.Applicative ((<$>))
import qualified Data.Text           as T
import           Turtle

-- man :: IO ExitCode
main = do
  configdir <- pwd
  emacsdir <- filePathAppend home ".emacs.d/"
  cd emacsdir
  private <- filePathAppend (return emacsdir) "private/"
  exists <- testdir private
  when exists $ rmtree private
  git "stash"
  git "pull origin"
  git "submodule sync"
  git "submodule update"
  cd configdir
  shell "./link.sh" ""

filePathAppend :: Functor f => f Turtle.FilePath -> Turtle.FilePath -> f Turtle.FilePath
filePathAppend x y = flip (</>) y <$> x

git :: Text -> IO ExitCode
git subcommand = shell ("git " `T.append` subcommand) ""

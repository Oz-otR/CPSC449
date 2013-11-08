module Main where

import System.IO

main=do
	handle<- openFile "haskellInput.txt" ReadMode
	contents <- hGetContents handle
	putStrLn contents
	hClose handle
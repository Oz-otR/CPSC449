

module Main where


import Data.Char
import System.Environment
main =
	do 
		
		print "What is your name?"
		name <- getLine
		putStrLn ("Hello, " ++ name ++ ". I think you will really like Haskell!")

cheese = "cheddar"
	   

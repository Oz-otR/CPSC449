module Main where

import System.IO
import System.Environment
import Data.List
import Data.Char
main = do
	args <- getArgs
	progName <- getProgName
	putStrLn "The arguments are:"
	print args
	putStrLn "The program name is:"
	putStrLn progName
	
	let readFile=args !! 0
	handle<- openFile readFile ReadMode
	contents <- hGetContents handle
	putStrLn contents
	hClose handle
	
	let myList=["(This ","will ","be ","awesome!!!)"]
	let newList=unwords myList
	
	let coolList=delete '(' newList
	
	
	let writeFile=args !! 1
	handle<-openFile writeFile WriteMode
	hPutStrLn handle (map toLower progName)
	hPrint handle (myList !! 0)
	hPrint handle (newList)
	hPrint handle (coolList)
	let someBool=checkForPartial(coolList)
	
	hClose handle
	
--Still working on this part	
checkForPartial::[Char]->[Char]	
checkForPartial x= do
	let tempString=delete 'd' x	
	
	return(tempString::String)
		
	
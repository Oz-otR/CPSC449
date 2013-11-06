module Printer
(printer)
where


import System.Environment
import System.IO
import Utils


printer :: (Solution,String)->IO()
printer (solution, []) = do
	--args<-getArgs
	--let writeFile = args !! 1
	handle<-openFile "output.txt" WriteMode
	let penalty = getPenalty solution
	let penaltyChar = show penalty
	let solutionk = map taskLetter (getAssignment solution)
	let solutionM = unwords(appendSpace solutionk)
	let prntStatement = ("Solution " ++ solutionM ++ "; Quality: " ++ penaltyChar)
	
	
	hPutStrLn handle (prntStatement)

	
printer (solution, error) = do
	--args<-getArgs
	--let writeFile = args !! 0
	handle<-openFile "output.txt" WriteMode
	hPrint handle error
	
	


appendSpace :: String->[String]
appendSpace x = map(\s -> [s] ++ " ") x
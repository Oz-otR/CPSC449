-- Print.hs 
-- More to follow later

import System.IO
import Data.Char
import Utils

-- If there is a solution
print (Solution solution _) = do
	fSolution = getAssignment (Solution solution _)
	fileHandle <- openFile "Output.txt" WriteMode
	hPrint fileHandle fsolution
	hClose fileHandle
	

-- If there is no solution, record penalty
print (Solution _ penalty ) = do
	fPenalty = getPenalty (Solution _ penalty)
	fileHandle <- openFile "Output.txt" WriteMode
	hPrint fileHandle fPenalty -- <-- NOT sure if this is how it works. Will update
	hClose fileHandle
	
	
	
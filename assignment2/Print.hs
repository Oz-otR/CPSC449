-- Print.hs 
-- More to follow later

import System.IO
import Data.Char
import Utils

-- If there is a solution
print (Solution solution _) = do
	solution = getAssignment (Solution solution _)
	fileHandle <- openFile "Output.txt" WriteMode
	hPrint fileHandle solution
	hClose fileHandle
	

-- If there is no solution, record penalty
print (Solution _ penalty ) = do
	penalty = getPenalty (Solution _ penalty)
	fileHandle <- openFile "Output.txt" WriteMode
	hPrint fileHandle penalty -- <-- NOT sure if this is how it works. Will update
	hClose fileHandle
	
	
	
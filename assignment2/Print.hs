-- Print.hs 
-- More to follow later

import System.IO
import Data.Char
import Utils

-- If there is a solution
print (Solution solution _) = do
	getAssignment (Solution solution _)
	-- etc etc

-- If there is no solution, record penalty
print (Solution _ penalty ) = do
	getPenalty (Solution _ penalty)
	-- etc etc
	
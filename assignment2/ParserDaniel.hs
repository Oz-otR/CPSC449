import Data.Char

parseFunction :: (Char a) => [a] -> [a]
parseFunction input
	|input == '\n':_= " " ++ parseFunction xs
	|input == "" 	= ""
	|otherwise 		= x ++ parseFunction xs
	where 	a=[x:xs]

splitSpace :: (Char a) => [a] -> [a]



parser :: (String a) => String -> [a]
-- output type: [[tooNearPen] (2D list of ints),[machinePen] (2D list in ints),[tooNear] (2D list of bool),[forbidden] (2D list of bool),[forced] (list of (machine-task pairs)),[optionalErrorMessage]]--
--input type? ["(a,b)","(c,d)","(e,f)","\n","Header2"...}--
--check current x of x:xs--
--if null then go to next datatype--
--otherwise [x:[currentdatatype]] ++ parser xs--
parser input 




parser x:xs = parseTooNear $ parseMachinePenalty $ parseForbiddenTooNear $ ParseForbiddenAssign $ parseForced x:xs
(a,b)
fst snd (a,b) = a


toValidNum :: a -> Int
toValidNumb a = case a of 	'a' -> 0
							'b' -> 1
							'c' -> 2
							'd' -> 3
							'e' -> 4
							'f' -> 5
							'g' -> 6
							'h' -> 7
							
							
							
{-							
(file)
.
.
.
.
.
-}
parse (file)
parse case getHeader file of:
								header1: (function1 file):returnVal ++ parse file --when nextLine == "", return everything so far--
								header2: (function2 file):returnVal ++ parse file
	otherwise	returnVal
	
ParseForbiddenTooNear :: ([Bool] a, Int b) => [String, b] -> [a, b]
{-	read next line
	if line==(x,y)
		assign True, a[x[y]] and parse to next line ParseForbiddenTooNear [a,b+1]
	if line == ""
		return [a,b+1]
-}
	
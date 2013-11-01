import Data.Char

parseFunction :: (Char a) => [a] -> [a]
parseFunction input
	|input == '\n':_= " " ++ parseFunction xs
	|input == "" 	= ""
	|otherwise 		= x ++ parseFunction xs
	where 	a=[x:xs]

splitSpace :: (Char a) => [a] -> [a]



parser :: (String a) => String -> [a]
-- output type: ([tooNearPen] (2D list of ints),[machinePen] (2D list in ints),[tooNear] (2D list of bool),[forbidden] (2D list of bool),[forced] (list of (machine-task pairs)),[optionalErrorMessage])--
toValidNum :: Int -> Int
toValidNum a 
	|a == 'a' = 0
	|a == 'b' = 1
	|a == 'c' = 2
	|a == 'd' = 3
	|a == 'e' = 4
	|a == 'f' = 5
	|a == 'g' = 6
	|a == 'h' = 7
	|otherwise	= -1

{-							
(file)
.
.
.
.
.
-}
{-
parse (file)
parse case getHeader file of:
								header1: (function1 file):returnVal ++ parse file --when nextLine == "", return everything so far--
								header2: (function2 file):returnVal ++ parse file
	otherwise	returnVal
-}

ParseForbiddenTooNear :: ([String a], [Bool] b, Int c) => [String, b, c] -> [a, b, c]
{-	read next line
	if line==(x,y)
		assign True, a[x[y]] and parse to next line ParseForbiddenTooNear [a,b+1]
	if line == ""
		return [a,b+1]
-}

ParseForbiddenTooNear [a,b,c]
		| 


--input type? ["(a,b)","(c,d)","(e,f)","\n","Header2"...}--
--check current x of x:xs--
--if null then go to next datatype--
--otherwise [x:[currentdatatype]] ++ parser xs--
parser input = parseTooNear $ parseMachinePenalty $ parseForbiddenTooNear $ ParseForbiddenAssign $ parseForced input

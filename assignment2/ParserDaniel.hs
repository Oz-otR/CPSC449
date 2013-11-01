import Data.Char

parseFunction :: (Char a) => [a] -> [a]
parseFunction input
	|input == '\n':_= " " ++ parseFunction xs
	|input == "" 	= ""
	|otherwise 		= x ++ parseFunction xs
	where 	a=[x:xs]

splitSpace :: (Char a) => [a] -> [a]



parser :: ([[Int]] a, [[Bool]] b, (Int, Int) c) => String -> (a, a, b, b, [c], String)
	parser input = parse input
-- output type: ([tooNearPen] (2D list of ints),[machinePen] (2D list in ints),[tooNear] (2D list of bool),[forbidden] (2D list of bool),[forced] (list of (machine,task pairs (example: 1,a)),[optionalErrorMessage])--
taskToValidNum :: Int -> Int
taskToValidNum a 
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

parseForbiddenTooNear :: ([String] a, [Bool] b, Int c) => (String, b, c) -> 
{-	read next line
	if line==(x,y)
		assign True, a[x[y]] and parse to next line ParseForbiddenTooNear [a,b+1]
	if line == ""
		return [a,b+1]
-}

parseForbiddenTooNear (a,b,c)
	|a == /n:_ = ""
	|a == "" = ""
	|otherwise = parseLineForbiddenTooNear (a,b,c)

parseLineForbiddenTooNear :: ([String a], [Bool] b, Int c) => (String, b, c) -> (a, b, c)
parseLineForbiddenTooNear (a,b,c) = parseForbiddenTooNear (a, parseB, c)
	where parseB = replace True x (b !! y)
		  x = (a !! c) !! 1
		  y = (a !! c) !! 2
--input type? ["(a,b)","(c,d)","(e,f)","\n","Header2"...}--
--check current x of x:xs--
--if null then go to next datatype--
--otherwise [x:[currentdatatype]] ++ parser xs--
parser input = parseTooNear $ parseMachinePenalty $ parseForbiddenTooNear $ ParseForbiddenAssign $ parseForced input



{- insert element 0 list = element:list
   insert element index (x:xs) = x:(insert element (index - 1) xs)
   
   replace element 0 (x:xs) = element:xs
   replace element index (x:xs) = x:(replace element (index - 1) xs)
   
   delete 0 x:xs = xs
   delete index x:xs = x:(delete (index - 1) xs) -} 
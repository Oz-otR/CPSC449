import Data.Char
{-
parseFunction :: (Char a) => [a] -> [a]
parseFunction input
	|input == '\n':_= " " ++ parseFunction xs
	|input == "" 	= ""
	|otherwise 		= x ++ parseFunction xs
	where 	a=[x:xs]

splitSpace :: (Char a) => [a] -> [a]
-}

parser :: ([[Int]] a, [[Bool]] b, (Int, Int) c) => [String] -> (a, a, b, b, [c], String)
	--parser input = parseTooNear $ parseMachinePen $ parseForbiddenTooNear $ ParseForbidden $ parseForced input - not sure about this for now, might be too complicated--
parser input = (a, b, d, e, f, g)
	|g \= ""		 = (_, _, _, _, _, g)
	|x == "header 1" = do
						x = parseTooNearPen(input, createBlank8by8list, c+1, g)
						parser(a', b, d, e, f, g1)
	|x == "header 2" = do
						x = parseMachinePen(input, createBlank8by8list, c+1, g)
						parser(a, b', d, e, f, g2)
	|x == "header 3" = do
						x = parseForbiddenTooNear(input, createBlank8by8boolList, c+1, g)
						parser(a, b, d', e, f, g3)
	|x == "header 4" = do
						x = parseForbidden(input, createBlank8by8boolList, c+1, g)
						parser(a, b, d, e', f, g4)
	|x == "header 5" = do
						x = (parseForced(input, "", c+1, g)
						parser(a, b, d, e, f', g5)
	|otherwise		 = (a, b, d, e, f, g)
	where input = x:xs
		a' = second(x)
		g1 = fourth(x)
		b' = second(x)
		g2 = fourth(x)
		d' = second(x)
		g3 = fourth(x)
		e' = second(x)
		g4 = fourth(x)
		f' = second(x)
		g5 = fourth(x)
-- output type: ([tooNearPen] (2D list of ints),[machinePen] (2D list in ints),[tooNear] (2D list of bool),[forbidden] (2D list of bool),[forced] (list of (machine,task pairs (example: 1,a)),[optionalErrorMessage])--

second :: (a, b, c, d) -> b
	second (_, z, _, _) = z

fourth :: (a, b, c, d) -> d
	fourth (_, _, _, z) = z

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

parseForbiddenTooNear :: ([String] a, [Bool] b) => (a, b, Int, String) -> (a, b, Int, String)
{-	read next line
	if line==(x,y)
		assign True, a[x[y]] and parse to next line ParseForbiddenTooNear [a,b+1]
	if line == "" or '\n':_
		return [a,b+1]
-}

parseForbiddenTooNear (a,b,c,d)
	|d \= "" = (a,b,c,d)
	|a == /n:_ = (a, b, c+1,d)
	|a == "" = (a, b, c+1,d)
	|otherwise = parseLineForbiddenTooNear (a,b,c,d)

parseLineForbiddenTooNear :: ([String] a, [Bool] b) => (a, b, Int, String) -> (a, b, Int, String)
parseLineForbiddenTooNear (a,b,c,d) = parseForbiddenTooNear (a, parseB, c+1, d)
	where parseB = replace True x (b !! y)
		  x = (a !! c) !! 1
		  y = (a !! c) !! 2


parseForbidden :: ([String] a, [Bool] b) => (a, b, Int, String) -> (a, b, Int, String)
{-	read next line
	if line==(x,y)
		assign True, a[x[y]] and parse to next line ParseForbidden [a,b+1]
	if line == "" or '\n':_
		return [a,b+1]
-}

parseForbidden (a,b,c,d)
	|d /= "" = (a,b,c,d)
	|a == /n:_ = (a, b, c+1,d)
	|a == "" = (a, b, c+1,d)
	|otherwise = parseLineForbidden (a,b,c,d)

parseLineForbidden :: ([String] a, [Bool] b, Int c, String d) => (a, b, c, d) -> (a, b, c, d)
parseLineForbidden (a,b,c,d) = parseForbidden (a, parseB, c+1, d)
	where parseB = replace True x (b !! y)
		  x = (a !! c) !! 1
		  y = (a !! c) !! 2
-- --
parseTooNearPen:: ([String] a, [Int] b) => (a, b, Int, String) -> (a, b, Int, String)
{-	read next line
	if line==(x,y)
		assign True, a[x[y]] and parse to next line ParseForbiddenTooNear [a,b+1]
	if line == "" or '\n':_
		return [a,b+1]
-}

parseTooNearPen (a,b,c,d)
	|d \= "" = (a,b,c,d)
	|a == /n:_ = (a, b, c+1, d)
	|a == "" = (a, b, c+1, d)
	|otherwise = parseLineForbiddenTooNear (a,b,c,d)

parseLineTooNearPen :: ([String] a, [Int] b) => (a, b, Int, String) -> (a, b, Int, String)
parseLineTooNearPen (a,b,c,d) = parseTooNearPen (a, parseB, c+1, d)
	where parseB = replace z x (b !! y)
		  x = (a !! c) !! 1
		  y = (a !! c) !! 2
		  z = (a !! c) !! 3



--check current x of x:xs--
--if null then go to next datatype--
--otherwise [x:[currentdatatype]] ++ parser xs--

{- insert element 0 list = element:list
   insert element index (x:xs) = x:(insert element (index - 1) xs)
   
   replace element 0 (x:xs) = element:xs
   replace element index (x:xs) = x:(replace element (index - 1) xs)
   
   delete 0 x:xs = xs
   delete index x:xs = x:(delete (index - 1) xs) -} 
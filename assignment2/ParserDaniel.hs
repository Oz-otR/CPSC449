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
parser (x:xs) = (a, b, d, e, f, g)
	|g \= ""		 = (_, _, _, _, _, g)
	|x == "header 1" = do
						q = parseTooNearPen(input, createBlank8by8list, c+1, g)
						parser(a', b, d, e, f, g1)
	|x == "header 2" = do
						q = parseMachinePen(input, createBlank8by8list, c+1, g)
						parser(a, b', d, e, f, g2)
	|x == "header 3" = do
						q = parseForbiddenTooNear(input, createBlank8by8boolList, c+1, g)
						parser(a, b, d', e, f, g3)
	|x == "header 4" = do
						q = parseForbidden(input, createBlank8by8boolList, c+1, g)
						parser(a, b, d, e', f, g4)
	|x == "header 5" = do
						q = (parseForced(input, "", c+1, g)
						parser(a, b, d, e, f', g5)
	|otherwise		 = (a, b, d, e, f, g)
	where
		a' = second(q)
		g1 = fourth(q)
		b' = second(q)
		g2 = fourth(q)
		d' = second(q)
		g3 = fourth(q)
		e' = second(q)
		g4 = fourth(q)
		f' = second(q)
		g5 = fourth(q)
-- output type: ([tooNearPen] (2D list of ints),[machinePen] (2D list in ints),[tooNear] (2D list of bool),[forbidden] (2D list of bool),[forced] (list of (machine,task pairs (example: 1,a)),[optionalErrorMessage])--

second :: (a, b, c, d) -> b
	second (_, z, _, _) = z

fourth :: (a, b, c, d) -> d
	fourth (_, _, _, z) = z

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
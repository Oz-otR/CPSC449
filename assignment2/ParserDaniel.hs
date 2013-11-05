import Data.Char
import Utils
{-
parseFunction :: (Char a) => [a] -> [a]
parseFunction input
	|input == '\n':_= " " ++ parseFunction xs
	|input == "" 	= ""
	|otherwise 		= x ++ parseFunction xs
	where 	a=[x:xs]

splitSpace :: (Char a) => [a] -> [a]
-}
		--tuple: (Constraint, Partials, error)--
--parser :: ([[Int]] a, [[Bool]] b, (Int, Int) c) => [String] -> (a, a, b, b, [c], String)
	--parser input = parseTooNear $ parseMachinePen $ parseForbiddenTooNear $ ParseForbidden $ parseForced input - not sure about this for now, might be too complicated--
{-parser (x:xs) = (a, b, d, e, f, g)
	|g \= ""		 = (_, _, _, _, _, g)
	|x == "header 1" = do
						q = parseTooNearPen(input, blank2d 8 8 0, c+1, g)
						parser(a', b, d, e, f, g1)
	|x == "header 2" = do
						q = parseMachinePen(input, blank2dInt 8 8 0, c+1, g)
						parser(a, b', d, e, f, g2)
	|x == "header 3" = do
						q = parseForbiddenTooNear(input, blank2dBool 8 8 False, c+1, g)
						parser(a, b, d', e, f, g3)
	|x == "header 4" = do
						q = parseForbidden(input, blank2dBool 8 8 False, c+1, g)
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
-}
firstOfThree :: (a,b,c) -> a
firstOfThree (x,_,_) = x

secondOfThree :: (a,b,c) -> b
secondOfThree (_,y,_) = y

thirdOfThree :: (a,b,c) -> c
thirdOfThree (_,_,z) = z

	
	
parse :: ([String] a, [(Integer, Integer)] b) => a -> (Constraint, b, String) -> (Constraint, b, String)
parse a (a1, b1, c1)
	|c1 /= "" = (a1, b1, c1)
	|q == "forced partial assignment:" = 
						let y = parseForcedPartials(a, [], "") in parse firstOfThree y ((getTooNearC a1, getMachineC a1, getTooNearP a1, getMachineP a1), secondOfThree y, thirdOfThree y)
	|q == "forbidden machine:" = 
						let y = parseForbiddenMachine(a, blank2dBool 8 8 False, "") in parse firstOfThree y ((getTooNearC a1, secondOfThree y, getTooNearP a1, getMachineP a1), b1, thirdOfThree y)
	|q == "too-near tasks:" = 
						let y = parseTooNearTasks(a, blank2dBool 8 8 False, "") in parse firstOfThree y ((secondOfThree y, getMachineC a1, getTooNearP a1, getMachineP a1), b1, thirdOfThree y)
	|q == "machine penalties:" = 
						let y = parseMachinePenalties(a, blank2dInt 8 8 0, "") in parse firstOfThree y ((getTooNearC a1, getMachineC a1, getTooNearP a1, secondOfThree y), b1, thirdOfThree y)
	|q == "too-near penalities" =
						let y = parseTooNearPenalties(a, blank2dInt 8 8 0, "") in parse firstOfThree y ((getTooNearC a1, getMachineC a1, secondOfThree y, getMachineP a1), b1, thirdOfThree y)
	|otherwise 				= parse a (a1, b1, c1)
	where q = extract a 0
	
	
	parseForcedPartials :: ([String] a, [(Int, Int)] b) => (a, b, String) -> (a, b, String)
	
	
	parseForbiddenMachine :: ([String] a, [[Bool]] b) => (a, b, String) -> (a, b, String)
	
	parseTooNearTasks :: ([String] a, [[Bool]] b) => (a, b, String) -> (a, b, String)
	
	parseMachinePenalties :: ([String] a, [[Integer]] b) => (a, b, String) -> (a, b, String)
	
	parseTooNearPenalties :: ([String] a, [[Integer]] b) => (a, b, String) -> (a, b, String)
	
	
--------------------------------------------------------------------------
--String functions to get the input we want
--Removes first and last element of [char]
removeBrackets xs = tail (init xs)  

--Splits [char] separated by comma to elements
splitComma xs = splitOn "," (removeBrackets xs)

--Splits [char] separated by space to elements
splitSpace xs = splitOn " " xs
	
	
	
	
	
	
	
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
{-
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
--otherwise [x:[currentdatatype]] ++ parser xs--}
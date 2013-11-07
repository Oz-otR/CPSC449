module ParserDaniel (
parser)
where 
import Data.Char
import Utils
import Debug.Trace

-- output type: ([tooNearPen] (2D list of ints),[machinePen] (2D list in ints),[tooNear] (2D list of bool),[forbidden] (2D list of bool),[forced] (list of (machine,task pairs (example: 1,a)),[optionalErrorMessage])--
firstOfThree :: (a,b,c) -> a
firstOfThree (x,_,_) = x

secondOfThree :: (a,b,c) -> b
secondOfThree (_,y,_) = y

thirdOfThree :: (a,b,c) -> c
thirdOfThree (_,_,z) = z

	

parser a = parse a (Constraint [] [] [] [], [], "")

parse :: [String] -> (Constraint, [(Int, Int)], String) -> (Constraint, [(Int, Int)], String)
parse strList (c, p, str) | trace ("Parse: " ++ (strList !! 0)) False = undefined

parse ("Name:":xs) (a1, b1, "") =
    parse (tail (tail xs)) (a1, b1, "")

parse ("forced partial assignment:":xs) (a1, b1, "") =
    parse (firstOfThree y) (a1, secondOfThree y, thirdOfThree y)
    where y = parseForcedPartials (xs, [], [])

parse ("forbidden machine:":xs) (a1, b1, "") =
    parse rem (Constraint (getTooNearC a1) con (getTooNearP a1) (getMachineP a1), b1, err)
    where (rem, con, err) = parseForbiddenMachine (xs, blank2dBool 8 8 False, [])

parse ("too-near tasks:":xs) (a1, b1, "") =
    parse rem (Constraint con (getMachineC a1) (getTooNearP a1) (getMachineP a1), b1, err)
    where (rem, con, err) = parseTooNearTasks (xs, blank2dBool 8 8 False, []) 

parse ("machine penalties:":xs) (a1, b1, "") =
    parse rem (Constraint (getTooNearC a1) (getMachineC a1) (getTooNearP a1) con, b1, err)
    where (rem, con, err) = parseMachinePenalties (xs, blank2dInt 8 8 0, [])

parse ("too-near penalities":xs) (a1, b1, "") =
    parse rem (Constraint (getTooNearC a1) (getMachineC a1) con (getMachineP a1), b1, err)
    where (rem, con, err) = parseTooNearPenalties (xs, blank2dInt 8 8 0, [])

parse [] (a1, b1, "") = (a1, b1, "")
--parse (x:xs) (a1, b1, "") = parse xs (a1, b1, "")
parse (x:xs) (a, b, []) = (a, b, "Error parsing input file.")
parse (x:xs) (a1, b1, c1) = (a1, b1, c1)
	
parseForcedPartials ::  ([String], [(Int, Int)], String) -> ([String], [(Int, Int)], String)
parseForcedPartials(a, b, c)
    |head a == []		= ((tail a),b,c)
    |otherwise			= parseForcedPartials(tail a, ((firstInteger a),(taskNumber(secondCharacter a))):b, c)

parseForbiddenMachine :: ([String], [[Bool]], String) -> ([String], [[Bool]], String)
parseForbiddenMachine (a,b,c)
    |c /= "" = (a,b,c)
    |a == [] = (a,b,c)
    |head a == "" = (tail a, b, c)
    |otherwise = parseLineForbidden (a,b,c)

parseLineForbidden :: ([String], [[Bool]], String) -> ([String], [[Bool]], String)
parseLineForbidden (a,b,c) 
    |c /= "" = (a,b,c)
    |head a == "" = (a,b,c)
    |(firstInteger a) `notElem` [0..7] = (a,b,"invalid machine/task")
    |(secondCharacter a) `notElem` ['A'..'H'] = (a,b,"invalid machine/task")
    |otherwise = parseForbiddenMachine (tail a, parseB b (firstInteger a) (taskNumber (secondCharacter a)), c)
    where parseB r s t = replace (replace True t (r !! s)) s r
	
parseTooNearTasks :: ([String], [[Bool]], String) -> ([String], [[Bool]], String)
parseTooNearTasks (a,b,c)
    |c /= [] = (a,b,c)
    |head a == "\n" = (tail a,b,c)
    |head a == "" = (tail a, b, c)
    |otherwise = parseLineTooNearTasks (a,b,c)


parseLineTooNearTasks :: ([String], [[Bool]], String) -> ([String], [[Bool]], String)
parseLineTooNearTasks (a,b,c) 
    |c /= "" = (a,b,c)
    |head a == "" = (a,b,c)
    |(firstInteger a) `notElem` [0..7] = (a,b,"invalid machine/task")
    |(secondCharacter a) `notElem` ['A'..'H'] = (a,b,"invalid machine/task")
    |otherwise = parseTooNearTasks (tail a, parseB b (taskNumber (firstCharacter a)) (taskNumber (secondCharacter a)), c)
    where parseB r s t = replace (replace True t (r !! s)) s r
	
	
parseMachinePenalties :: ([String], [[Int]], String) -> ([String], [[Int]], String)
parseMachinePenalties (("":xs),b,c) = (xs, b, c)
parseMachinePenalties (a,b,c) = parseMachineReturn(parseMachineHelper (a,b,c,1))
{-machine penalties:
i i i i i i i i
j j j j j j j j-}
parseMachineHelper :: ([String], [[Int]], String, Int) -> ([String], [[Int]], String, Int)
parseMachineHelper (a,b,c,d)
    |d > 8 =	(a,b,c,d)
    |otherwise = parseMachineHelper (tail a, replace (map read $ words (head a) :: [Int]) d b, c, d+1)

parseMachineReturn :: ([String], [[Int]], String, Int) -> ([String], [[Int]], String)
parseMachineReturn (a,b,c,d) = (a,b,c)
	
	
parseTooNearPenalties :: ([String], [[Int]], String) -> ([String], [[Int]], String)
parseTooNearPenalties (a,b,c)
    |c /= "" = (a,b,c)
    |head a == "" = (a, b, c)
    |otherwise = parseLineTooNearPenalties (a,b,c)

parseLineTooNearPenalties :: ([String], [[Int]], String) -> ([String], [[Int]], String)
parseLineTooNearPenalties (a,b,c) = parseTooNearPenalties (tail a, parseB, c)
    where parseB = replace (replace (thirdInteger a) (taskNumber (firstCharacter a)) (b !! taskNumber (secondCharacter a))) (taskNumber (secondCharacter a)) b
	
--------------------------------------------------------------------------
--String functions to get the input we want
--Removes first and last element of [char]
removeBrackets xs = tail (init xs)  

--Splits [char] separated by comma to elements
splitComma xs = splitOn ',' (removeBrackets xs)

--Splits [char] separated by space to elements
splitSpace xs = splitOn ' ' xs -- DOES NOT WORK! Ended up using (map read $ words) instead.

--gets the Integer found at the first element
firstInteger a = (read ((splitComma (head a)) !! 0) :: Int) - 1

--gets the Integer found at the third element
thirdInteger a = (read ((splitComma (head a)) !! 2) :: Int) - 1

--gets the Char found at the first element
firstCharacter a = ((splitComma (head a)) !! 0) !! 0

--gets the Char found at the second element
secondCharacter a = ((splitComma (head a)) !! 1) !! 0

module ParserDaniel (
parser)
where 
import Data.Char
import Utils
import Debug.Trace

-- output type: ([tooNearPen] (2D list of ints),[machinePen] (2D list in ints),[tooNear] (2D list of bool),[forbidden] (2D list of bool),[forced] (list of (machine,task pairs (example: 1,a)),[optionalErrorMessage])--

parser a = parse a (Constraint [] [] [] [], [], "")

parse :: [String] -> (Constraint, [(Int, Int)], String) -> (Constraint, [(Int, Int)], String)
parse strList (c, p, str) | trace ("Parse: " ++ (strList !! 0)) False = undefined

parse ("Name:":xs) (a1, b1, "") =
    parse (tail (tail xs)) (a1, b1, "")

parse ("forced partial assignment:":xs) (a1, b1, "") =
    parse rem (a1, con, err)
    where (rem, con, err) = parseForcedPartials (xs, [], [])

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

parse (x:xs) (Constraint [] w y z, b1, "") = (Constraint [] w y z, b1, err_parsing)
parse (x:xs) (Constraint w [] y z, b1, "") = (Constraint w [] y z, b1, err_parsing)
parse (x:xs) (Constraint w y [] z, b1, "") = (Constraint w y [] z, b1, err_parsing)
parse (x:xs) (Constraint w y z [], b1, "") = (Constraint w y z [], b1, err_parsing)
parse (x:xs) (a1, b1, "") = (a1, b1, err_parsing)
parse [] (a1, b1, "") = (a1, b1, "")
parse (x:xs) (a1, b1, c1) = (a1, b1, c1)
	
parseForcedPartials ::  ([String], [(Int, Int)], String) -> ([String], [(Int, Int)], String)
parseForcedPartials (strList,b,c) | trace ("parseForcedPartials: " ++ (strList !! 0)) False = undefined
parseForcedPartials (a, b, c)
    |head a == []		      = ((tail a),b,c)
    |pair `elem` b        = (a, b, "partial assignment error")
    |isValidTuple (head a) = parseForcedPartials(tail a, pair:b, c)
    |otherwise			      = (a, b, err_parsing)
    where
      first = firstInteger (head a)
      second = secondCharacter (head a)
      pair = (first, (taskNumber second))

parseForbiddenMachine :: ([String], [[Bool]], String) -> ([String], [[Bool]], String)
parseForbiddenMachine (strList,b,c) | trace ("parseForbiddenMachine: " ++ (show strList)) False = undefined
parseForbiddenMachine (a,b,c)
    |c /= "" = (a,b,c)
    |head a == "\n" = (tail a, b, c)
    |head a == "" = (tail a, b, c)
    |head a == " " = (tail a, b, c)
    |otherwise = parseLineForbidden (a,b,c)

parseLineForbidden :: ([String], [[Bool]], String) -> ([String], [[Bool]], String)
parseLineForbidden (strList,b,c) | trace ("parseLineForbidden:'" ++ (strList !! 0) ++ "'") False = undefined
parseLineForbidden (strList,table,err) 
    |err /= ""    = (strList,table,err)
    |word == "\n" = (rem,table,err)
    |word == ""   = (rem,table,err)
    |first `notElem` [0..7]      = (strList,table,err_machine_task)
    |second `notElem` ['A'..'H'] = (strList,table,err_machine_task)
    |otherwise = parseForbiddenMachine (rem, insertBool table first (taskNumber second), err)
    where word   = head strList
          rem    = tail strList
          first  = firstInteger word
          second = secondCharacter word
    --where insertBool r s t = replace (replace True t (r !! s)) s r
insertBool bools machine task | trace ("insertBool: " ++ (show machine) ++ ", " ++ (show task)) False = undefined
insertBool bools machine task = replace (replace True task (bools !! machine)) machine bools
findElem (x:xs) 0       = x
findElem (x:xs) y = findElem xs (y - 1)

parseTooNearTasks :: ([String], [[Bool]], String) -> ([String], [[Bool]], String)
parseTooNearTasks (strList,b,c) | trace ("parseTooNearTasks: " ++ (strList !! 0)) False = undefined
parseTooNearTasks (a,b,c)
    |c /= [] = (a,b,c)
    |head a == "\n" = (tail a,b,c)
    |head a == "" = (tail a, b, c)
    |otherwise = parseLineTooNearTasks (a,b,c)


parseLineTooNearTasks :: ([String], [[Bool]], String) -> ([String], [[Bool]], String)
parseLineTooNearTasks (strList,b,c) | trace ("parseLineTooNearTasks: " ++ (strList !! 0)) False = undefined
parseLineTooNearTasks (a,b,c) 
    |c /= "" = (a,b,c)
    |head a == "" = (a,b,c)
    |first `notElem` ['A'..'H'] = (a,b,err_machine_task)
    |second `notElem` ['A'..'H'] = (a,b,err_machine_task)
    |otherwise = parseTooNearTasks (tail a, insertBool b (taskNumber first) (taskNumber second), c)
    where first  = firstCharacter (head a)
          second = secondCharacter (head a)
	
	
parseMachinePenalties :: ([String], [[Int]], String) -> ([String], [[Int]], String)
parseMachinePenalties (strList,b,c) | trace ("parseMachinePenalties: " ++ (strList !! 0)) False = undefined
parseMachinePenalties (("":xs),b,c) = (xs, b, err_machinePenalty)
parseMachinePenalties (a,b,c) = parseMachineReturn(parseMachineHelper (a,b,c,0))
{-machine penalties:
i i i i i i i i
j j j j j j j j-}
parseMachineHelper :: ([String], [[Int]], String, Int) -> ([String], [[Int]], String, Int)
parseMachineHelper (a,b,c,d)
    |d > 7 =	(a,b,c,d)
    |(head a) == "" = (a,b,err_machinePenalty,d)   
    |length (map read $ words (head a) :: [Int]) /= 8 = (a,b,err_machinePenalty,d)
    |otherwise = parseMachineHelper (tail a, replace (map read $ words (head a) :: [Int]) d b, c, d+1)

parseMachineReturn :: ([String], [[Int]], String, Int) -> ([String], [[Int]], String)
parseMachineReturn (a,b,c,d) = (a,b,c)
	
	
parseTooNearPenalties :: ([String], [[Int]], String) -> ([String], [[Int]], String)
parseTooNearPenalties (strList,b,c) | trace ("parseTooNearPenalties: " ++ (strList !! 0)) False = undefined
parseTooNearPenalties (a,b,c)
    |c /= "" = (a,b,c)
    |head a == "" = (a, b, c)
    |otherwise = parseLineTooNearPenalties (a,b,c)

parseLineTooNearPenalties :: ([String], [[Int]], String) -> ([String], [[Int]], String)
parseLineTooNearPenalties (a,b,c)
    |first `notElem` ['A'..'H'] = (a,b,"invalid task")
    |second `notElem` ['A'..'H'] = (a,b,"invalid task")
    |otherwise = parseTooNearPenalties (tail a, parseB, c)
    where 
      first = firstCharacter (head a)
      second = secondCharacter (head a)
      third = thirdInteger (head a)
      parseB = replace (replace third (taskNumber first) (b !! taskNumber second)) (taskNumber second) b
	
err_machinePenalty = "machine penalty error"
err_tooNearPenalty = "toonear penalty error"
err_machine_task   = "invalid machine/task"
err_parsing        = "Error parsing input file."

--------------------------------------------------------------------------
--String functions to get the input we want

-- Check if a string matches the format "(..,..)" with no spaces.
isValidTuple :: String -> Bool
isValidTuple str =
  (hasBrackets rstr) && (noSpaces rstr)
  where rstr = rtrim str

noSpaces [] = True
noSpaces (' ':xs) = False
noSpaces (x:xs) = noSpaces xs

hasBrackets [] = False
hasBrackets str = (head str) == '(' && (last str) == ')'

rtrim str
  | str == []       = []
  | last str == ' ' = rtrim (init str)
  | otherwise       = str

--Removes first and last element of [char]
removeBrackets xs = tail (init xs)  

--Splits [char] separated by comma to elements
splitComma xs = splitOn ',' (removeBrackets xs)

--Splits [char] separated by space to elements
splitSpace xs = splitOn ' ' xs -- DOES NOT WORK! Ended up using (map read $ words) instead.

--gets the Integer found at the first element
firstInteger str = (read ((splitComma str) !! 0) :: Int) - 1

--gets the Integer found at the third element
thirdInteger a = (read ((splitComma a) !! 2) :: Int) - 1

--gets the Char found at the first element
firstCharacter a = ((splitComma a) !! 0) !! 0

--gets the Char found at the second element
secondCharacter a = ((splitComma a) !! 1) !! 0

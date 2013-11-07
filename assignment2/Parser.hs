-- Assignment 2 T01 Group 04
import Data.Char
import Data.List
import Data.List.Split
import Utils

{-
parseConstraint:: Constraint -> [String] -> Int -> Constraint
parseConstraint constraint (x:xs)
	| xs == [] = constraint
	| x == "" = parseConstraint xs 
	| x == "Name:" = parseName xs
	| x == "forced partial assignment:" = parsePartial constraint xs
	| x == "forbidden machine:" = parseForbidden constraint xs
	| x == "too-near tasks:" =  parseNearTasks constraint xs
	| x == "machine penalties:" = parsePenalty constraint xs
	| x == "too-near penalities" = parseNearPenalty constraint xs
	--| xxs == "" --end
	--| xxs == [] = --end
	| otherwise --error 
	-}

parser contents =
	(parseNearPenalty . parsePenalty . parseNearTasks . parseForbidden . parsePartial . parseName) ((Constraint [] [] [] []), [], contents, [])
	
parseName :: (Constraint, [(Int, Int)], [String], String) -> (Constraint, [String], String)
parseName (constraint, partials, (x:xs), error)
	|error /= "" = (constraint [] [] error)
	|x == "" = parseName constraint xs error
	|x == "Name:" = (constraint [] (tail tail xs) [])
	
parsePartial :: (Constraint, [(Int,Int)], [String], String) -> (Constraint, [String], String)
parsePartial (constraint, partials, (x:xs), error)
	|error /= "" = (constraint [] error)
	|x == "forced partial assignment:" = (parsePartialInner constraint partials xs [])
	|otherwise = (constraint [] [] "Error while parsing input file")

parseForbidden :: (Constraint, [(Int,Int)], [String], String) -> (Constraint, [String], String)
parseForbidden (constraint, partials, (x:xs), error)
	|error /= [] = (constraint [] [] error)
	|x == "forbidden machine:" = (parsePartialInner constraint partials xs [])
	|otherwise = (constraint [] [] "Error while parsing input file")
	
parseNearTasks :: (Constraint, [(Int,Int)], [String], String) -> (Constraint, [String], String)
parseNearTasks (constraint, partials, (x:xs), error)
	|error /= [] = (constraint [] [] error)
	|x == "too-near tasks:" = (parsePartialInner constraint partials xs [])
	|otherwise = (constraint [] [] "Error while parsing input file")
	
parsePenalty :: (Constraint, [(Int,Int)], [String], String) -> (Constraint, [String], String)	
parsePenalty (constraint, partials, (x:xs), error)
	|error /= [] = (constraint [] [] error)
	|x == "machine penalties:" = (parsePenaltyInner constraint partials xs [])
	|otherwise = (constraint [] [] "Error while parsing input file")
	
parseNearPenalty :: (Constraint, [(Int,Int)], [String], String) -> (Constraint, [String], String)
parseNearPenalty (constraint, partials, (x:xs), error)
	|error /= [] = (constraint [] [] error)
	|x == "too-near penalities" = (parsePenaltyInner constraint partials xs [])
	|otherwise = (constraint [] [] "Error while parsing input file")



parsePartialInner :: (Constraint, [(Int,Int)], [String], String) -> (Constraint, [String], String)	
parsePartialInner (constraint, partials, (x:xs), error)
	|error /= [] = (constraint [] [] error)
	|x == [] = (constraint, partials, xs, error)
	|otherwise = (constraint [] [] "Error while parsing input file") 

	
parsePenaltyInner :: (Constraint, [(Int,Int)], [String], String) -> (Constraint, [String], String)	
parsePenaltyInner (constraint, partials, (x:xs), error)
	|error /= [] = (constraint [] [] error)
	|x == [] = (constraint, partials, xs, error)
	|otherwise = (constraint,[],[],"Error while parsing input file") 
	
	
	
{-
parsePartial :: [String] -> [(int,int)]	
parsePartial (x:xs)
	|
-}
--------------------------------------------------------------------------
--String functions to get the input we want
--Removes first and last element of [char]
removeBrackets xs = tail (init xs)  

--Splits [char] separated by comma to elements
splitComma xs = splitOn "," (removeBrackets xs)

--Splits [char] separated by space to elements
splitSpace xs = splitOn " " xs
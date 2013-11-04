module Utils 
(
Constraint(Constraint),
getTooNearC,
getTooNearP,
getMachineC,
getMachineP,
Solution(Solution),
getAssignment,
getPenalty,
remove,
extract,
allTrue,
insert,
replace,
delete,
blank2d,
blank
)
where

data Constraint = Constraint [[Bool]] [[Bool]] [[Int]] [[Int]] deriving (Show)

getTooNearC (Constraint c_tooNear _ _ _) = c_tooNear
getTooNearP (Constraint _ _ p_tooNear _) = p_tooNear
getMachineC (Constraint _ c_machine _ _) = c_machine
getMachineP (Constraint _ _ _ p_machine) = p_machine

data Solution = Solution [Int] Int deriving (Show)

getAssignment (Solution solution _) = solution
getPenalty  (Solution _ penalty ) = penalty

-- Removes element at index from the list -------------------------------------
remove (x:xs) 0     = xs
remove (x:[]) index = x:[]
remove (x:xs) index = x:(remove xs (index - 1))

-- Extracts element at index from the list ------------------------------------
extract list element = (list !! element, remove list element)

-- Determines whether a whole list is true ------------------------------------
allTrue :: [Bool] -> Bool
allTrue (True:xs) = allTrue xs
allTrue (False:xs) = False
allTrue (x:[]) = x

-- Inserts an element at an index in a list -----------------------------------
insert element 0 list = element:list
insert element index (x:xs) = x:(insert element (index - 1) xs)

-- Replaces an element at an index in a list ----------------------------------
replace element 0 (x:xs) = element:xs
replace element index (x:xs) = x:(replace element (index - 1) xs)

-- Deletes an element equal to item in a list ---------------------------------
delete item (x:xs)
              | x == item = xs
              | xs == [] = x:[]
              | otherwise = x:(delete item xs)

-- Blank --
blank2d sizeX 0     init = []
blank2d sizeX sizeY init = (blank sizeX init):(blank2d sizeX (sizeY - 1) init)

blank 0 init = []
blank size init = init:(blank (size - 1) init)

-- Translate task numbers --
taskNumber 'A' = 0
taskNumber 'B' = 1
taskNumber 'C' = 2
taskNumber 'D' = 3
taskNumber 'E' = 4
taskNumber 'F' = 5
taskNumber 'G' = 6
taskNumber '7' = 7
taskNumber c = -1

taskLetter 0 = 'A'
taskLetter 1 = 'B'
taskLetter 2 = 'C'
taskLetter 3 = 'D'
taskLetter 4 = 'E'
taskLetter 5 = 'F'
taskLetter 6 = 'G'
taskLetter 7 = 'H'
taskLetter c = ''

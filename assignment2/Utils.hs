module Utils 
(
Constraint,
getTooNearC,
getTooNearP,
getMachineC,
getMachineP,
Solution,
getSolution,
getPenalty,
remove,
allTrue,
insert,
replace,
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

getSolution (Solution solution _) = solution
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


-- Blank --
blank2d sizeX 0     init = []
blank2d sizeX sizeY init = (blank sizeX init):(blank2d sizeX (sizeY - 1) init)

blank 0 init = []
blank size init = init:(blank (size - 1) init)

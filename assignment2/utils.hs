module Utils where
(remove, allTrue, insert, replace, blank2d, blank)

-- Removes element at index from the list -------------------------------------
remove (x:[]) index = x:[]
remove (x:xs) 0     = xs
remove (x:xs) index = x:(remove xs (index - 1))

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
blank2d sizeX 0     = []
blank2d sizeX sizeY = (blank sizeX):(blank2d sizeX (sizeY - 1))

blank 0 = []
blank size = 0:(blank (size - 1))

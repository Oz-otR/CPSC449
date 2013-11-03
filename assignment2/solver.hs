import Data.List (foldl)
import Utils.*

-- The solver ! ---------------------------------------------------------------
solver :: ([[Int]], [[Int]], [[Bool]], [[Bool]], [(Int,Int)], [Char]) -> ([Int], Int, [Char])

solver (p_tooNear, p_machine, c_tooNear, c_machine, partials, []) =
  solve (setup partials, c_tooNear, c_machine) [] 999999

solver (p_tooNear, p_machine, c_tooNear, c_machine, partials, error) = ([], 0, error)


solve :: [[Bool]] -> [[Bool]] -> [[Int]] -> [[Int]] -> ([Int],[Char]) -> ([Int], Int, [Char])


solveInterior c_tooNear c_machine p_tooNear p_machine assignments machine task best p =
  solveArrangement

solveArrangement c_tooNear c_machine p_tooNear p_machine assignments remaining best p =
  if (valid assignments c_tooNear c_machine) && (penalties assignments p_tooNear p_machine < p)
    then solveInterior


-- Set up initial state -------------------------------------------------------
setup :: [(Int,Int)] ->  [[Bool]] -> [[Bool]] -> [Int] -> ([Int],[Char])
setup ((machine, task):[])    c_tooNear c_machine assignments =
  if valid next c_tooNear c_machine
    then (next, [])
    else ([], 0, "no valid solution possible!")
  where next = insert task machine assignments

setup ((machine, task):pairs) c_tooNear c_machine assignments =
  if assignments !! machine /= -1 && valid next c_tooNear c_machine
    then ([], "no valid solution possible!")
    else setup pairs c_tooNear c_machine next
  where next = insert task machine assignments

    
-- Constraint functions -------------------------------------------------------
valid :: [Int] -> [[Bool]] -> [[Bool]] -> Bool
valid assignments c_tooNear c_machine = 
  allTrue (map (validAssignments assignments c_tooNear c_machine) [0..7])

validAssignments :: [Int] -> [[Bool]] -> [[Bool]] -> Int -> Bool
validAssignments assignments c_tooNear c_machine machine =
  (validMachine machine assignments c_machine)
  && (validTooNear machine assignments c_tooNear)

  -- Check against the invalid machine constraints:
validMachine :: Int -> [Int] -> [[Bool]] -> Bool
validMachine 7 assignments c_machine =
  isValidMachine 7 (assignments !! 7    ) c_machine

validMachine index assignments c_machine =
  isValidMachine index (assignments !! index) c_machine
  && validMachine (succ index) assignments c_machine

isValidMachine :: Int -> Int -> [[Bool]] -> Bool
isValidMachine machine (-1) c_machine = True
isValidMachine machine task c_machine = (c_machine !! machine) !! task

  -- Check against the too-near task constraints:
validTooNear :: Int -> [Int] -> [[Bool]] -> Bool
validTooNear 7     assignments c_tooNear = 
  isValidTooNear (assignments !! 7    ) (assignments !! 0           ) c_tooNear

validTooNear index assignments c_tooNear = 
  isValidTooNear (assignments !! index) (assignments !! (succ index)) c_tooNear
  && validTooNear (succ index) assignments c_tooNear

isValidTooNear :: Int -> Int -> [[Bool]] -> Bool
isValidTooNear (-1) task' c_tooNear = True
isValidTooNear task (-1)  c_tooNear = True
isValidTooNear task task' c_tooNear = (c_tooNear !! task) !! task'


-- Penalty functions ----------------------------------------------------------
penalties :: [Int] -> [[Int]] -> [[Int]] -> Int
penalties assignments p_tooNear p_machine = 
  foldl (+) 0 (map (penalty assignments p_tooNear p_machine) [0..7])

penalty :: [Int] -> [[Int]] -> [[Int]] -> Int -> Int
penalty assignments p_tooNear p_machine machine = 
  (+) (tooNearPenalty assignments machine p_tooNear)
      (machinePenalty assignments machine p_machine)

  -- Get the machine penalty:
machinePenalty :: [Int] -> Int -> [[Int]] -> Int
machinePenalty assignments machine p_machine = 
  if task >= 0
    then (p_machine !! (succ machine)) !! (succ task)
    else 0
  where task = assignments !! machine

  -- Get the too-near penalty:
tooNearPenalty :: [Int] -> Int -> [[Int]] -> Int
tooNearPenalty assignments 7 p_tooNear = 
  superRadFunction (assignments !! 7) (assignments !! 0) p_tooNear

tooNearPenalty assignments machine p_tooNear = 
  if (length assignments > (succ machine))
    then superRadFunction (assignments !! machine) (assignments !! (succ machine)) p_tooNear
    else 0

superRadFunction :: Int -> Int -> [[Int]] -> Int
superRadFunction (-1) task' p_tooNear = 0
superRadFunction task (-1)  p_tooNear = 0
superRadFunction task task' p_tooNear = (p_tooNear !! (succ task)) !! (succ task')


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

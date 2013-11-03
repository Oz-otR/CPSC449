import Data.List (foldl)
import Utils
-------------------------------------------------------------------------------
-- The solver ! 
-------------------------------------------------------------------------------
{-
solver :: (Constraint, [(Int,Int)], [Char]) -> ([Int], Int, [Char])

solver (constraint, partials, []) =

solver (constraint, partials, error) = ([], 0, error)

-}

-------------------------------------------------------------------------------
-- Set up initial state 
-------------------------------------------------------------------------------
setup :: Constraint -> [(Int, Int)] -> [Int] -> ([Int],[Char])
setup constraint partials [] =
  setup constraint partials (blank 8 (-1))

setup constraint ((machine, task):[]) assignments =
  if valid constraint next
    then (next, [])
    else ([], "no valid solution possible!")
  where next = replace task machine assignments

setup constraint ((machine, task):pairs) assignments =
  if assignments !! machine /= -1 && valid constraint next
    then ([], "no valid solution possible!")
    else setup constraint pairs next
  where next = replace task machine assignments

    
-------------------------------------------------------------------------------
-- Constraint functions
-------------------------------------------------------------------------------
valid :: Constraint -> [Int] -> Bool
valid constraint assignments = 
  allTrue (map (validAssignments constraint assignments) [0..7])

validAssignments :: Constraint -> [Int] -> Int -> Bool
validAssignments constraint assignments machine =
  (validMachine constraint assignments machine)
  && (validTooNear constraint assignments machine)

  -- Check against the invalid machine constraints ----------------------------
validMachine :: Constraint -> [Int] -> Int -> Bool
validMachine constraint assignments 7 =
  isValidMachine constraint 7 (assignments !! 7    )

validMachine constraint assignments index =
  isValidMachine constraint index (assignments !! index)
  && validMachine constraint assignments (succ index) 

isValidMachine :: Constraint -> Int -> Int -> Bool
isValidMachine constraint machine (-1) = True
isValidMachine constraint machine task = ((getMachineC constraint)!! machine) !! task

  -- Check against the too-near task constraints ------------------------------
validTooNear :: Constraint -> [Int] -> Int -> Bool
validTooNear constraint assignments 7 = 
  isValidTooNear constraint (assignments !! 7    ) (assignments !! 0           )

validTooNear constraint assignments index = 
  isValidTooNear constraint (assignments !! index) (assignments !! (succ index))
  && validTooNear constraint assignments (succ index)

isValidTooNear :: Constraint -> Int -> Int -> Bool
isValidTooNear constraint (-1) task' = True
isValidTooNear constraint task (-1)  = True
isValidTooNear constraint task task' = ((getTooNearC constraint) !! task) !! task'


-------------------------------------------------------------------------------
-- Penalty functions 
-------------------------------------------------------------------------------
penalties :: Constraint -> [Int] -> Int
penalties constraint assignments = 
  foldl (+) 0 (map (penalty constraint assignments) [0..7])

penalty :: Constraint -> [Int] -> Int -> Int
penalty constraint assignments machine = 
  (+) (tooNearPenalty constraint assignments machine)
      (machinePenalty constraint assignments machine)

  -- Get the machine penalty --------------------------------------------------
machinePenalty :: Constraint -> [Int] -> Int -> Int
machinePenalty constraint assignments machine = 
  if task >= 0
    then ((getMachineP constraint) !! machine) !! task
    else 0
  where task = assignments !! machine

  -- Get the too-near penalty -------------------------------------------------
tooNearPenalty :: Constraint -> [Int] -> Int -> Int
tooNearPenalty constraint assignments 7 = 
  superRadFunction constraint (assignments !! 7) (assignments !! 0)

tooNearPenalty constraint assignments machine = 
  if (length assignments > (succ machine))
    then superRadFunction constraint (assignments !! machine) (assignments !! (succ machine))
    else 0

superRadFunction :: Constraint -> Int -> Int -> Int
superRadFunction constraint (-1) task' = 0
superRadFunction constraint task (-1)  = 0
superRadFunction constraint task task' = ((getTooNearP constraint) !! task) !! task'


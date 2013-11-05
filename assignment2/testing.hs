import Utils
import Solver

testCase1 = (getConstraint1, getPartials1, getError1)

getConstraint1 = Constraint getTooNearC1 getMachineC1 getTooNearP1 getMachineP1
getTooNearC1 = blank2dBool 8 8 True
getMachineC1 = blank2dBool 8 8 True
getTooNearP1 = blank2dInt  8 8 0
getMachineP1 = blank2dInt  8 8 0

getPartials1 :: [(Int,Int)]
getPartials1 = [(0,0),(1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7)]
getError1    = []

testCase2 = (getConstraint2, getPartials2, getError2)
getConstraint2 = Constraint getTooNearC2 getMachineC2 getTooNearP2 getMachineP2
getTooNearC2 = blank2dBool 8 8 False
getMachineC2 = blank2dBool 8 8 False
getTooNearP2 = blank2dInt 8 8 0
getMachineP2 = blank2dInt 8 8 1

getPartials2 :: [(Int, Int)]
getPartials2 = []
getError2    = []

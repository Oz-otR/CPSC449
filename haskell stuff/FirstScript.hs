--import Data.List


-- concat . Data.List.intersperse pat . splitKeepEnd pat = id,
  -- length (splitKeepEnd pattern target) ==
    --           length (nonOverlappingIndices pattern target) + 1,


main::IO()
main = do

name::String
numbers::Integer

let name="Hello"
let numbers=5


name2::String
let name2="Heyman"
splitStuff name2


splitStuff::String
let splitStuff x=do
	splitAt 1 "hello"
	putStrLn("Hi")











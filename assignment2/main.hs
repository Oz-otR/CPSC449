

import System.IO
import System.Environment
import Data.List

import Solver
import ParserDaniel
import Printer
import Utils

main = do

  args <- getArgs
  let readFile=args !! 0
  handle<- openFile readFile ReadMode
  contents <- hGetContents handle
  --print (solver(parser(lines contents)))
  printer(solver(parser(lines contents)))

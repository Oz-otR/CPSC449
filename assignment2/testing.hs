import Utils
import Solver
import Parser

testCase1 =
  ["Name:","whatever",
  "","forced partial assignment:",
  "(0,a)","",
  "forbidden machine:",
  "(2,d)",
  "(3,f)",
  "",
  "too-near tasks:",
  "(c,h)",
  "",
  "machine penalties:",
  "9 9 9 9 9 9 9 9",
  "9 1 9 9 9 9 9 9",
  "9 9 1 9 9 9 9 9",
  "9 9 9 1 9 9 9 9",
  "9 9 9 9 1 9 9 9",
  "9 9 9 9 9 1 9 9",
  "9 9 9 9 9 9 1 9",
  "9 9 9 9 9 9 9 1",
  "",
  "too-near penalities",
  "(a,b,100)",
  "(b,c,100)",
  "(d,e,100)",
  "(e,f,100)",
  "(f,g,100)"]

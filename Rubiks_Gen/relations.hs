--Sam Baugh
--relations.hs
--This module provides the logic-based relationships for the program

module Relations where

import CubeTypes
import Helpers


--A solved cube, used as a starting point
solvedCube :: Cube
solvedCube = zipWith (,) fIDList (map (index . replicate 9) ["White","Red","Green","Blue","Orange","Yellow"])

--List of face-names, or FIDs
fIDList :: [FID]
fIDList = ["Front","Back","Left","Right","Up","Down"]

--Tool for sorting
sortingTool :: [(Int,FID)]
sortingTool = [(1,"Front"),(2,"Back"),(3,"Left"),(4,"Right"),(5,"Up"),(6,"Down")]

--Note: The following "Adj-Lists" establish the program's knowledge of the faces' relationship
frontAdj, backAdj, leftAdj, rightAdj, upAdj, downAdj :: AdjList
frontAdj = [(3,"col","Left"),(1,"row","Up"),(1,"col","Right"),(1,"row","Down")]
backAdj = [(3,"col","Right"),(3,"row","Up"),(1,"col","Left"),(3,"row","Down")]
leftAdj = [(3,"col","Back"),(1,"col","Up"),(1,"col","Front"),(1,"col","Down")]
rightAdj = [(3,"col","Front"),(3,"col","Up"),(1,"col","Back"),(3,"col","Down")]
upAdj = [(1,"row","Left"),(1,"row","Front"),(1,"row","Right"),(1,"row","Back")]
downAdj = [(3,"row","Left"),(3,"row","Back"),(3,"row","Right"),(3,"row","Front")]

--Creates a general map with all of the AdjLists
adjMap :: [(FID,AdjList)]
adjMap = zip fIDList [frontAdj,backAdj,leftAdj,rightAdj,upAdj,downAdj]

--An ordering of rows and columns for the puproses of rotating a face
rowcolList :: [(Dir,Int)]
rowcolList = [("row",1),("col",3),("row",3),("col",1)]


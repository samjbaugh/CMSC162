--Sam Baugh
--rotate.hs
--This module provides functions for use in rotating Faces

module Rotate where

import Helpers
import CubeTypes
import Data.List
import Relations


--Given a side and a direction, rotates a cube (returns the new cube)
rotate :: Dir  -> FID -> Cube -> Cube
rotate dir faceid cube = fixUp cube ((rotate_face dir faceid cube) ++ (rotate_others dir faceid cube))

--Fixes a cube to have a standardized ordering of faces
fixUp :: Cube -> Cube -> Cube
fixUp oldcube newcube = sortBy (\(x,_) -> \(y,_) -> compare (lookBy2 sortingTool (==x)) (lookBy2 sortingTool (==y))) toBeSortedCube 
    where subForm = (map (\(x,_) -> x) oldcube)\\(map (\(x,_) -> x) newcube)
          tempID = head subForm
          toBeSortedCube = (tempID,(lookBy oldcube (==tempID))):newcube

--Rotates all of the adjecent sides to the face being rotated
rotate_others :: Dir -> FID -> Cube -> Cube
rotate_others dir fid cube = translatedFaces
    where myAdjList = lookBy adjMap (==fid)
          master_store = map (\(num,rowcol,faceid) -> store rowcol num (lookBy cube (==faceid))) myAdjList
          transAdjList = if dir=="right" then offsetR myAdjList else offsetL myAdjList
          translatedFaces = zipWith (\(num,rowcol,faceid) -> \storeVal -> (,) faceid $ move rowcol num storeVal (lookBy cube (==faceid))) transAdjList master_store

--Rotates the particular face being rotated
rotate_face :: Dir -> FID -> Cube -> Cube
rotate_face dir fid cube = [(,) fid $ apply transList face]
    where face = lookBy cube (==fid)
          rowcolTrans = if dir=="right" then offsetR rowcolList else offsetL rowcolList
          master_store = map (\(rowcol,n) -> store rowcol n face) rowcolList
          transList = zipWith (\(rowcol,n) -> \storeStr -> move rowcol n storeStr) rowcolTrans master_store

--Stores a row of values into a list of strings, accepts a row or column of any indexing
store :: String -> Int -> Face -> [String]
store c n face
   | c=="row" = clean $ map (\((row,_),color)-> if row==n then color else  "") face
   | c=="col" = clean $ map (\((_,col),color)-> if col==n then color else  "") face

--This function complements the "store" function as it takes the output list of strings and moves to another row/column indexing
move :: String -> Int -> [String] -> Face -> Face
move c n storeStr face
   | c=="row" = zipWith (\newcolor -> \((row,col),old) -> if row==n then ((row,col),newcolor) else ((row,col),old)) nStr face
   | c=="col" = zipWith (\newcolor -> \((row,col),old) -> if col==n then ((row,col),newcolor) else ((row,col),old)) nStr face
   where nStr = concat $ map (replicate 3) storeStr





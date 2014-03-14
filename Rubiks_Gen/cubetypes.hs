--Sam Baugh
--cubetypes.hs
--This module provides the type infrastructure (there are no actual data types, these are used only for clarity)

module CubeTypes where

import Control.Monad.State
import System.Random

--These following type-names are for clarity
type Cube = [(FID,Face)]

--The "Face ID" (as determined by a string)
type FID = String

--A face, which is simply a list of squares and their respective IDs
type Face = [(SID,Square)]

--A two-dimensional "square ID". Note: all faces are indexed downwards (or frontwards in the case of the top and bottom faces) and from left-to-right 
type SID = (Int,Int)

--A square, determined by its color
type Square = String

--A direction, always "left" or "right"
type Dir = String

--List of adjacent sides to a particular FID:
type AdjList = [(Int,String,FID)]

--A state monad for randomization
type RandState = State StdGen

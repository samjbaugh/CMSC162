--Sam Baugh
--rukes_gen_IO.hs
--These functions assist in the random selection of turns for the program

module RandCube where

import System.Random
import Control.Monad.State
import Rotate
import CubeTypes
import Helpers
import Relations

--Randomly selects a face to rotate
randFace :: RandState Int
randFace = state $ randomR (0,6)>>=return

--Randomly selects a direction in which to rotate the face
randDir :: RandState Dir
randDir = do
    dir <- state $ randomR (False,True)
    if dir then return "left" else return "right"

--Turns a face in a direction at random using the above two functions 
randTurn :: Cube -> RandState Cube
randTurn cube = state $ \s -> 
    let (mydir,fstGen) = runState randDir s in 
    let (myfnum,sndGen) = runState randFace fstGen in 
   (rotate mydir (lookBy sortingTool (==myfnum)) cube,sndGen)

--Accepts a number, does multipley random turns
randTurns :: Int -> Cube -> RandState Cube
randTurns 1 cube = (randTurn cube)>>=return
randTurns x cube = state $ \s -> let (newcube,newGen) = runState (randTurn cube) s in runState (randTurns (x-1) newcube) newGen

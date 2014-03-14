import Data.List
import System.Random
import Control.Monad.State
import Rotate
import Helpers
import Relations
import CubeTypes
import RandCube


--Main method, current set to randomly rotate the cube 4 times
main :: IO()
main = do
    g <- getStdGen
    let myCube = evalState (randTurns 4 solvedCube) g
    putStr (cubeToString myCube)

--Turns a cube into a string for visualization purposes
cubeToString :: Cube -> String
cubeToString mycube = concat $ map (\(fid,myface) -> ("\n FID: " ++ fid ++ (faceToString myface) ++ "\n")) mycube

--Turns a face into a string for visualization purposes
faceToString :: Face -> String
faceToString myface = concat $ map (\(sid,square) -> ("\nSID: " ++ show(sid) ++ square)) myface











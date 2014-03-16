--GoFish_IO.sh
--A program for playing a game of Go Fish (in Haskell)
--I have borrowed some of ideas from Lee Ehudin's Python Solution
import System.Random
import System.IO
import Control.Monad.State
import Data.List
import Data.Maybe

import PlayFunctions
import DeckFunctions
import WarTypes

--This is the main method that introduces the game to the player
main :: IO()
main = do
    putStr "Welcome to War! This game is played against the computer. The object is to take all of your opponents cards by playing higher-value carsd (King is high)"
    g <- getStdGen
    let my_game = evalState setup g
    domoves my_game

--This is the recursive function that moves the game forward. It terminates once a player has won the game.
domoves :: Game -> IO ()
domoves my_game = do
    firstgame <- play my_game
    let win = winners firstgame
    putStr $ "\nYou have " ++ (show $ length (fst firstgame)) ++ " card(s) remaining. The computer has: " ++ (show $ length (snd firstgame)) ++ " card(s) remaining.\n"
    if win== Nothing then domoves firstgame else putStr (fromJust win)





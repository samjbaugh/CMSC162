--GoFish_IO.sh
--A program for playing a game of Go Fish (in Haskell)
--I have borrowed some of ideas from Lee Ehudin's Python Solution
import System.Random
import System.IO
import Control.Monad.State
import Data.List

import PlayFunctions
import DeckFunctions
import GoFishTypes
import InfoSets



match_list :: [(Player,Hand)]
match_list = []


main :: IO()
main = do
    putStr "Welcome to Go Fish! This game is multiplayer, played through hotseat."
    g <- getStdGen
    let my_game = evalState setup g
    domoves my_game

domoves :: Game -> IO ()
domoves my_game = do
    firstgame <- move my_game
    let jay = winners firstgame
    if jay==[] then domoves firstgame else putStr $ "The winners as are following: " ++ (concat jay)

move :: Game -> IO Game
move my_game = do
    let (deck,myHands,currentPlayer) = my_game
    putStr $ "Player " ++ currentPlayer ++ "Please select a player, and a card:\n"
    putStr $ "Players: " ++ (concatMap (\(x,y) -> (show x) ++ ": " ++ y ++ "\t") playerIDs) ++ "\n"
    putStr "Player (by number): "
    n' <- getLine
    putStr "Card Number: "
    c <- getLine
    let n = ((read n')::Int)-1
    let a = playersList!!n
    putStr $ a ++ " do you have any " ++ c ++ "\'s?"
    let (mybool,nextgame,(mycard:_)) = askForCard (c,"null") currentPlayer my_game 
    putStr $ show mybool
    putStr $ "\n" ++ c
    if not mybool then do putStr $ "\nGo fish! " ++ "You got a " ++ (cardToString mycard) ++ "!\n" else do putStr "\nsuccessful transfer!\n"
 
    let (newmatches,newergame) = checkMatches nextgame

    if newmatches==[] then do putStr "\n" else do putStr $ "You put down " ++ (concatMap cardToString newmatches) ++ "!"

    let finalgame = nextPlayer newergame

    return finalgame

    



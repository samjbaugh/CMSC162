module PlayFunctions where

import System.Random 
import Control.Monad.State
import DeckFunctions
import Data.List
import Data.Maybe
import WarTypes

--This function does the actual moves of the game: it "plays" a card from each player and compares them. It them announces who won the round: if there's a tie it goes to the faceOff round.
play :: Game -> IO Game
play ((card1:xs),(card2:ys)) = do
    if value1==value2 then do 
        putStr $ showCards ++ "Tie! Going into a faceoff!"
        _ <- getLine
        faceOff [card1,card2] (xs,ys) 
    else if value1>value2 then do
        putStr $ showCards ++ "You won, you get both cards!"
        _ <- getLine
        return (xs,(ys ++ [card1,card2])) 
    else do
        putStr $ showCards ++ "The computer won, they get both cards :("
        _ <- getLine
        return (xs ++ [card1,card2],ys)
    where showCards = "\nYou: " ++ (show card1) ++ "\nComputer: " ++ (show card2) ++"\n"
          (Card value1 _) = card1
          (Card value2 _) = card2

--This function represents "faceoffs" in War. 
faceOff :: [Card] -> Game -> IO Game
faceOff current my_game@(player1,player2) = do
    if player2==[] || c1>c2 then do
        putStr $ showCards ++ "You won, you get all of the cards placed in that faceoff!"
        return (player1++newcurrent,p2cards)
    else if player1==[] || c1<c2 then do
        putStr $ showCards ++ "Computer gets the cards!"
        _ <- getLine
        return (p1cards,player2++newcurrent)
    else {-c1==c2-} do
        let new1 = drop 3 player1; new2 = drop 3 player2
        putStr $ showCards ++ "Tie again? Time for another face-off!"
        _ <- getLine
        faceOff newcurrent (new1,new2)
    where p1cards = take 3 player1
          p2cards = take 3 player2
          c1 = tail p1cards
          c2 = tail p2cards
          newcurrent = current ++ p1cards ++ p2cards
          showCards = concatMap (\(card1,card2) -> "\nYou: " ++ (show card1) ++ "\nComputer: " ++ (show card2) ++"\n") (zip p1cards p2cards)

--This is a simple function to determine if there is a winner (and returns who it is if there is a winner)
winners :: Game -> Maybe String
winners (player1,player2)
    | player1==[] = Just "Computer won!"
    | player2==[] = Just "You won!"
    | otherwise = Nothing

--This randomly sets up a War game
setup :: RandState Game
setup = state $ \s -> let (((_,player1):(_,player2):[]),_) = deal ((length start_deck) `quot` 2) [Human,Computer] (evalState (shuffle_deck start_deck) s) in ((player1,player2),s)









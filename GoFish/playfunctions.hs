module PlayFunctions where

import GoFishTypes
import System.Random 
import Control.Monad.State
import DeckFunctions
import Helper
import Data.List
import InfoSets


pid :: Player -> Int
pid player = lookBy2 playerIDs (==player)

deal :: Int -> [Player] -> Deck -> ([(Player,Hand)],Deck)
deal handsize players deck = (final,finaldeck) where

    playerT :: [(Player,[Card])]
    playerT = map (flip (,) []) players

    appList :: [Hand]
    (appList,finaldeck) = deal' handsize (length players) deck

    jay :: [[(Player,Hand)] -> [(Player,Hand)]] 
    jay = map (zipWith (\hand -> \(player,handL) -> (player,hand:handL))) appList

    final :: [(Player,Hand)]
    final = apply jay playerT

    deal' :: Int -> Int -> Deck -> ([Hand],Deck)
    deal' 0 _ result = ([],result)
    deal' handsize numplayers mydeck = (toAdd:one,two)
        where (toAdd,toKeep) = takeX numplayers mydeck
              (one,two) = deal' (handsize-1) numplayers toKeep

insertHand :: Player -> Hand -> [(Player,Hand)] -> [(Player,Hand)]
insertHand currentPlayer insertHand handList = insertBy (\(x,_) -> \(y,_) -> compare (pid x) (pid y)) (currentPlayer,insertHand) handList

checkMatches :: Game -> ([Card],Game)
checkMatches a@(mydeck,myhands,currentPlayer)
    | length(matches)==0 = ([],a)
    | otherwise = let (putDown,handRemaining) = takeMany matches currentHand 
                  in (putDown,(mydeck,insertHand currentPlayer handRemaining myhands,currentPlayer))
    where currentHand = lookBy myhands (==currentPlayer)
          matches = nub2 currentHand

nextPlayer ::  Game -> Game
nextPlayer (mydeck,myhands,currentPlayer) = (mydeck,myhands,fst $ (!!) myhands $ ((elemPos myhands (\(x,_) -> x==currentPlayer)) + 1) `mod` mylen)
    where mylen = length myhands


askForCard :: Card -> Player -> Game -> (Bool,Game,[Card])
askForCard card@(cardValue,suit) playerAsked a@(mydeck,myhands,playerAsking)
    | takenList /= [] = let newhand = map key myhands in (True,(mydeck,newhand,playerAsking),takenList)
    | otherwise = let (newgame,drawncard) = drawCard a in (False,newgame,[drawncard])
    where playerAskedHand = lookBy myhands (==playerAsked)
          (takenList,resultL) = takeAll (\(value,_) -> value==cardValue) playerAskedHand
          key :: (Player,Hand) -> (Player,Hand)
          key (q,hand)
              | q==playerAsking = (q,hand++takenList)
              | q==playerAsked = (q,[])
              | otherwise = (q,hand)

compareValues :: Card -> Card -> Bool
compareValues (value1,_) (value2,_) = value1==value2

winners :: Game -> [Player]
winners (_,handlist,_) = winners' handlist where
    winners' [] = []
    winners' ((one,two):xs)
        | two==[] = one:(winners' xs)
        | otherwise = winners' xs


drawCard :: Game -> (Game,Card)
drawCard a@(mydeck,myhands,currentPlayer) = ((newdeck,map key myhands,currentPlayer),drawnCard)
    where ((drawnCard:_),newdeck) = takeX 1 mydeck
          key (player,hand)
              | player==currentPlayer = (player,hand++[drawnCard]) 
              | otherwise = (player,hand)

setup :: RandState Game
setup = state $ \s -> let (mydeck,nextGen) = runState (shuffle_deck start_deck) s in let (hands,newdeck) = deal 5 playersList mydeck in ((newdeck,hands,head playersList),nextGen)

gameToString :: Game -> String
gameToString (deck,myhands,currentPlayer) = "\nDeck:\n\n" ++ (deckToString deck) ++ "\n\nHands:\n" ++ (concatMap handsToString myhands) ++ "\n\n Current Player: " ++ currentPlayer ++ "\n"

handsToString :: (Player,Hand) -> String
handsToString (player,hand) = "\n\nPlayer: " ++ player ++  (deckToString hand)

deckToString :: Deck -> String
deckToString deck = concatMap cardToString deck

cardToString :: Card -> String
cardToString (value,suit) = value ++ " " ++ suit

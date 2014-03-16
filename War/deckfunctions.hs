module DeckFunctions where

import WarTypes
import System.Random
import Control.Monad.State
import Helper

values = [One,Two,Three,Four,Five,Six,Seven,Eight,Nine,Ten,Jack,Queen,King]

suits = [Hearts,Diamonds,Spades,Clubs]

start_deck :: Deck
start_deck = zipWith Card values suits

shuffle_deck :: Deck -> RandState Deck
shuffle_deck [] = state $ \s -> ([],s)
shuffle_deck oldDeck = state $ \s -> (let ((item,newDeck),newGen) = runState (takerm oldDeck) s in item:(evalState (shuffle_deck newDeck) newGen), s)


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


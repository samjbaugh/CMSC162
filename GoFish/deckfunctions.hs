module DeckFunctions where

import GoFishTypes
import System.Random
import Control.Monad.State
import InfoSets
import Helper
 

start_deck :: Deck
start_deck = concat $ map (\x -> map ((,) x) suits) values

shuffle_deck :: Deck -> RandState Deck
shuffle_deck [] = state $ \s -> ([],s)
shuffle_deck oldDeck = state $ \s -> (let ((item,newDeck),newGen) = runState (takerm oldDeck) s in item:(evalState (shuffle_deck newDeck) newGen), s)


module GoFishTypes where

import Control.Monad.State
import System.Random 


type RandState = State StdGen
type Value = String
type Suit = String
type Card = (Value,Suit)
type Player = String
type Game = (Deck,[(Player,Hand)],Player)
type Hand = [Card]
type Deck = [Card]

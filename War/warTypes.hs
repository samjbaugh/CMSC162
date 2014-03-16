module WarTypes where

import Control.Monad.State
import System.Random 

--This stores the value of a card
data Value = One | Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten | Jack | Queen | King
    deriving(Eq,Ord,Show)

--This datatype stores the suit of a card
data Suit = Hearts | Diamonds | Spades | Clubs
    deriving(Eq,Ord,Show)

--This stores the two players of the game
data Player = Human | Computer

--This stores a card
data Card = Card Value Suit
    deriving(Eq,Show)

--Cards are compared by their values, not their sutis
instance Ord Card where
    compare (Card value suit) (Card value2 suit2) = compare value value2

--Random state (for shuffling, mostly)
type RandState = State StdGen

--Typedefs for clarity
type Hand = [Card]
type Game = (Deck,Deck)
type Deck = [Card]

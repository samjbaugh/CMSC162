--Sam Baugh
--helpers.hs
--This module provides helper functions to the rest of the program

module Helpers where

--A function that is similar to lookup but doesn't worry about the maybe monad. 
lookBy :: Eq a => [(a,b)] -> (a->Bool) -> b
lookBy ((xa,xb):[]) _ = xb
lookBy ((xa,xb):xs) f
    | f xa = xb
    | otherwise = lookBy xs f

--A function that is similar to lookup but doesn't worry about the maybe monad, also looks by the second tuple value as opposed to the first
lookBy2 :: Eq a => [(a,b)] -> (b->Bool) -> a
lookBy2 ((xa,xb):[]) _ = xa
lookBy2 ((xa,xb):xs) f
    | f xb = xa
    | otherwise = lookBy2 xs f

--Out of a list of a supposedly square value length, creates a two-dimensional indexing
index :: [a] -> [((Int,Int),a)]
index a = indexBoard' a (round $ sqrt $ fromIntegral $ length a) (1,1)
    where k = 1
          indexBoard' [] _ _ = []
          indexBoard' (x:xs) k (i,j)
              | j<k = ((i,j),x):(indexBoard' xs k (i,j+1))
              | i<k = ((i,j),x):(indexBoard' xs k (i+1,1)) 
              | otherwise = [((i,j),x)]

--Offsets a list by one in the "left" direction, used for rotation
offsetL :: [a] -> [a]
offsetL (z:zs) = offsetL' z zs
    where offsetL' :: a -> [a] -> [a]
          offsetL' x (a:as) = a:(offsetL' x as)
          offsetL' x [] = [x]

--Offsets a list by one in the "right" direction, used for rotation
offsetR :: [a] -> [a]
offsetR (z:zs) = offsetR' z zs
    where offsetR' :: a -> [a] -> [a]
          offsetR' x (a:as) = a:(offsetR' x as)
          offsetR' x [] = [x]

--Cleans up a list of strings by removing all of the empty strings
clean :: [String] -> [String]
clean [] = []
clean (x:xs)
    | x=="" = clean xs
    | otherwise = x:(clean xs)

--Applys a list of functions to a single value
apply :: [(a->a)] -> a -> a
apply [] store = store
apply (f:fs) store = apply fs (f store)


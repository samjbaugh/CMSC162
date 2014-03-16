module Helper where

import Control.Monad.State
import Data.List
import System.Random


--takerm stands for "take and remove", it randomly selects an item from a list, removes it from the list, and returns both in a tuple.
takerm :: Eq a => [a] -> State StdGen (a,[a])
takerm as = do
    ix <- state $ randomR (0,length as - 1)
    return $ (as !! ix,Data.List.delete (as!!ix) as)

--select randomly selects an item from a list and returns it (courtesy of Kurtz's lecture notes).
select :: [a] -> State StdGen a
select as = do
    ix <- state $ randomR (0,length as - 1)
    return $ (as !! ix)

--This is takes a list of functions and applies all of those functions to a single value
apply :: [(a->a)] -> a -> a
apply [] store = store
apply (f:fs) store = apply fs (f store)

--This finds the position of a certain element and returns the position
elemPos :: Eq a => [a] -> (a->Bool) -> Int
elemPos list f = elemPos' list f 0 where
    elemPos' [] _ _ = -1
    elemPos' (x:xs) f j
        | f x = j
        | otherwise = elemPos' xs f (j+1)

--This is a special version of nub that only returns whichever list items are in the list twice or more
nub2 :: Eq a => [a] -> [a]
nub2 list = specialNub' $ tail list' where
    list' = sort list
    specialNub' [] = []
    specialNub' (a:[]) = [a]
    specialNub' (a:b:xs)
        | a==b = specialNub' (b:xs)
        | otherwise = a:(specialNub' xs)

--Takes a value an 'X' number of times
takeX :: Int -> [a] -> ([a],[a])
takeX _ [] = ([],[])
takeX 0 xs = ([],xs)
takeX j (x:xs) = (x:thing,store)
    where (thing,store) = takeX (j-1) xs

--Looks up a value by a function
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

--Returns the list with the items removed and the number removed
takeBy :: Eq a => (a->Bool) -> [a] -> (Int,[a])
takeBy _ [] = (0,[])
takeBy f (x:xs)
    | f x = let (store,thing) = takeBy f xs in (store+1,thing)
    | otherwise = let (store,thing) = takeBy f xs in (store,x:thing)

--The multiplicative form of "takeBy"
takeAll :: Eq a => (a->Bool) -> [a] -> ([a],[a])
takeAll _ [] = ([],[])
takeAll f (x:xs)
    | f x = let (store,thing) = takeAll f xs in (x:store,thing)
    | otherwise = let (store,thing) = takeAll f xs in (store,x:thing)

--Takes a list of items to be removed from list2 and returns the list with items removed and the list of items removed
takeMany :: Eq a => [a] -> [a] -> ([a],[a])
takeMany [] toTakeFrom = ([],toTakeFrom)
takeMany (x:xs) toTakeFrom = (resultL++deletedList,resultList)
    where (resultL,shorterList) = takeAll (==x) toTakeFrom 
          (deletedList,resultList) = takeMany xs shorterList


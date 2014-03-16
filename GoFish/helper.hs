module Helper where

import Control.Monad.State
import Data.List
import System.Random
import GoFishTypes

--takerm stands for "take and remove", it randomly selects an item from a list, removes it from the list, and returns both in a tuple.
takerm :: Eq a => [a] -> RandState (a,[a])
takerm as = do
    ix <- state $ randomR (0,length as - 1)
    return $ (as !! ix,Data.List.delete (as!!ix) as)

--select randomly selects an item from a list and returns it (courtesy of Kurtz's lecture notes).
select :: [a] -> RandState a
select as = do
    ix <- state $ randomR (0,length as - 1)
    return $ (as !! ix)

apply :: [(a->a)] -> a -> a
apply [] store = store
apply (f:fs) store = apply fs (f store)

elemPos :: Eq a => [a] -> (a->Bool) -> Int
elemPos list f = elemPos' list f 0 where
    elemPos' [] _ _ = -1
    elemPos' (x:xs) f j
        | f x = j
        | otherwise = elemPos' xs f (j+1)


nub2 :: Eq a => [a] -> [a]
nub2 list = specialNub' $ tail list where
    specialNub' [] = []
    specialNub' (a:[]) = [a]
    specialNub' (a:b:xs)
        | a==b = specialNub' (b:xs)
        | otherwise = a:(specialNub' xs)

takeX :: Int -> [a] -> ([a],[a])
takeX 0 xs = ([],xs)
takeX j (x:xs) = (x:thing,store)
    where (thing,store) = takeX (j-1) xs

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

takeBy :: Eq a => (a->Bool) -> [a] -> (Int,[a])
takeBy _ [] = (0,[])
takeBy f (x:xs)
    | f x = let (store,thing) = takeBy f xs in (store+1,thing)
    | otherwise = let (store,thing) = takeBy f xs in (store,x:thing)

takeAll :: Eq a => (a->Bool) -> [a] -> ([a],[a])
takeAll _ [] = ([],[])
takeAll f (x:xs)
    | f x = let (store,thing) = takeAll f xs in (x:store,thing)
    | otherwise = let (store,thing) = takeAll f xs in (store,x:thing)

takeMany :: Eq a => [a] -> [a] -> ([a],[a])
takeMany [] toTakeFrom = ([],toTakeFrom)
takeMany (x:xs) toTakeFrom = (resultL++deletedList,resultList)
    where (resultL,shorterList) = takeAll (==x) toTakeFrom 
          (deletedList,resultList) = takeMany xs shorterList


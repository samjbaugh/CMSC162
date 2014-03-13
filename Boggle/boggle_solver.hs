module BoggleSolver where

import BoggleBoard
import Data.Map
import Data.List
import System.Random
import System.IO
import Control.Monad.State
import Data.Char
import Data.Maybe

type WordList = [String]
type Index = (Integer,Integer)
type Path = [Index]
type Bound = Integer
type ScoreList = [(String,Int)]


------------Solving Functions------------

--This function does the actual board-solving. It does this through the following:
--1. Taking the first step by generating a list of length-two paths for each letter on the board.
--2. Recursively testing if each is a valid path. If valid path returns a list of words, it runs solveBoard' again on the next step. These "deeperLevels" continue until no more words can be found in the path.
--3. If valid path returns true, it adds the de-coded path to its output list. 
solveBoard :: BoggleBoard -> WordList -> [String]
solveBoard board wordList = concat $ Data.List.map (\x -> solveBoard' x (betterList wordList $ firstChar x) board) firstStep where
   firstStep = Data.List.map (\x -> nextStep x (last x) (bound board)) (boardToPaths board)
   firstChar x = toLower $ board!(head $ head x)
   solveBoard' [] _ _ = []
   solveBoard' (x:xs) wordList board
     | newWordList == [] = nextInList
     | wordBool = [(toString path board)] ++ deeperLevel ++ nextInList
     | otherwise = deeperLevel ++ nextInList
     where (path,newWordList,wordBool) = validPath x wordList board
           deeperLevel = solveBoard' (nextStep x (last x) (bound board)) newWordList board
           nextInList = solveBoard' xs wordList board

--This function serves two important functions:
--1. Determines if the decoded path is a valid word. In that case it returns true, otherwise it returns false.
--2. Determines if there are any more words that can be found based off of continuing this path. If it does, it returns the new list of words (to use for the next step).
validPath :: Path -> WordList-> BoggleBoard -> (Path,WordList,Bool)
validPath path wordList board
    | not $ newWordList==[] = (path,newWordList,wordBool)
    | otherwise = ([],[],wordBool) where
    (newWordList,wordBool) = validPath' (toString path board) wordList
    validPath' _ [] = ([],False) 
    validPath' myWordUpper (dictWord:xs) 
        | myWord == dictWord = let (list,bool) = (validPath' myWord xs) in (dictWord:list,True || bool )
        | myWord<dictWord && startsWith myWord dictWord = let (list,bool) = (validPath' myWord xs) in (dictWord:list,False || bool)
        | myWord>dictWord = let (list,bool) = (validPath' myWord xs) in (list,False || bool)
        | otherwise = ([],False)
        where myWord = lowerCase myWordUpper

--This function takes a path, that path's index, and the board's bounds and returns a list of all possible paths for the "next step".
nextStep :: Path -> Index -> Bound -> [Path]
nextStep path index bound = zipWith (\x -> \y -> x++[y]) (replicate (length q) path) q
   where q = rmInvalidIndex (increment index) bound path
         j = last path


------------IO Helping Functions------------

--The "getWords" IO function extracts the list of around 250,000 english words.
getWords :: String -> IO WordList
getWords fileName = do
   h <- readFile fileName
   return $ lines h

--Turns a list of words and, from this list, ouputs a map of their scores (remember, scoring is determined by the number of letters minus 2).
findScores :: [String] -> ScoreList
findScores [] = []
findScores (x:xs) =  (x,scoreWord x):(findScores xs)

 
--A simple helper function that essentially aligns the number of spaces in the output strings.
numberSpaces :: Int -> String
numberSpaces 20 = []
numberSpaces x = " " ++ (numberSpaces (x+1))

--This function takes a score list and returns a list of only the highest-scoring words.
maxScores :: ScoreList -> ScoreList
maxScores [] = []
maxScores myList = maxScore' (findGreatest myList) myList where
    maxScore' _ [] = []
    maxScore' max ((a@(_,score)):xs)
        | score==max = a:(maxScore' max xs)
        | otherwise = maxScore' max xs

--Finds the greatest score given a score list.
findGreatest :: ScoreList-> Int
findGreatest [] = 1
findGreatest ((word,score):xs)
    | score>top = score
    | otherwise = top
    where top = findGreatest xs

--Scores a word
scoreWord :: String -> Int
scoreWord myWord = (length myWord) - 2

--This function turns a score list into a string containing all of the words.
putWords :: ScoreList -> String
putWords [] = []
putWords ((a,_):xs) = a ++ " " ++ (putWords xs)

--This function turns a score list into a string containing all of the words, their scores, and respective newline characters.
putScores :: ScoreList -> String
putScores [] = []
putScores ((a,b):xs) = a ++ (numberSpaces $ length a) ++ (show b) ++ "\n" ++ (putScores xs)

--This function does nothing more than generating x newline characters.
genLines :: Int -> String
genLines x 
    | x==0 = ""
    | otherwise = "\n" ++ (genLines (x-1))

------------Process Helping Functions------------


--Turns a BoggleBoard object into a list of Paths (for the first step)
boardToPaths :: BoggleBoard -> [Path]
boardToPaths board = Data.List.map (\(a,b) -> [a]) (toList board)

--Simple function that turns a string into lower case (for checking upper case boggle letters against lower case dictionary entries)
lowerCase :: String -> String
lowerCase = Data.List.map toLower

upperCase :: String -> String
upperCase = Data.List.map toUpper

--Function that returns True of False depending on a word (in this usage, a dictionary word) starts with a string of characters (in this case the decoded path)
startsWith :: String -> String -> Bool
startsWith [] [] = True
startsWith [] _ = True
startsWith _ [] = False
startsWith (x:xs) (y:ys)
    | (toLower x)==(toLower y) = startsWith xs ys
    | otherwise = False

--This function "decodes" a path into a string using a boggle board as the key.
toString :: Path -> BoggleBoard -> String
toString [] _ = []
toString (x:xs) board = (board!x):(toString xs board)

--This function takes an index and recurisvely increments it's indexes in all directions. For example, if this function takes (2,2), it will return [(1,1),(1,2),(1,3),(2,1),(2,2),(2,3),(3,1),(3,2),(3,3)]
increment :: Index -> [Index]
increment (a,b) = j:(increment' (replicate 8 $ j) j) where
    j = (a-1,b-1)
    increment' [] _ = []
    increment' ((a0,b0):xs) (a1,b1)
      | b1-b0<2 = (a1,b1+1):(increment' xs (a1,b1+1))
      | a1-a0<2 = (a1+1,b0):(increment' xs (a1+1,b0))

--This function, meaning "remove invalid inexes", takes a list of indexes, a "Bound" object (an integer representing the dimensions of the boggle board) and a path. It remvoes indexes if they are (1) out of the board's bounds and (2) members of the path.
rmInvalidIndex :: [Index] -> Bound -> Path -> [Index]
rmInvalidIndex [] _ _= []
rmInvalidIndex ((a,b):xs) bound path 
    | a<1 || b<1 || a>bound || b>bound || isIn path  = rmInvalidIndex xs bound path
    | otherwise = (a,b):(rmInvalidIndex xs bound path)
    where isIn = any (\x -> (a,b)==x)

--This function takes a list of words (in this case the dictionary list) and only returns the words that start with the given character. This function makes the solver work much faster than starting at the two-digit length.
betterList :: WordList -> Char -> WordList
betterList [] _ = []
betterList (dictWord@(dictChar:_):xs) myChar
    | dictChar<myChar = betterList xs myChar 
    | dictChar==myChar = dictWord:(betterList xs myChar)
    | dictChar>myChar = []



------------Test Variables------------

{-testPath = [(1,1),(1,2),(1,3)]
testBoard :: BoggleBoard
testBoard = fromList [((1,1),'C'),((1,2),'A'),((1,3),'T'),((1,4),'S'),((2,1),'X'),((2,2),'L'),((2,3),'L'),((2,4),'X'),((3,1),'X'),((3,2),'X'),((3,3),'X'),((3,4),'X'),((4,1),'X'),((4,2),'X'),((4,3),'X'),((4,4),'X')]
testWordList = sort $ ["cx","cads","cat","cats","catomania","jaundlice","call"]
testNextStep = nextStep testPath (last testPath) (bound testBoard)
(testpath1,testnewList,testwordBool) = validPath (head testNextStep) testWordList testBoard-}


 





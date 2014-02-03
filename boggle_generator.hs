module BoggleBoard where

import Data.Map
import Data.List
import System.Random
import System.IO
import Control.Monad.State

type BoggleBoard = Map (Integer,Integer) Char
type RandState = State StdGen
type Dice = [Char]

{-

This program is a Boggle Board generator written in Haskell. It simulates "shaking up" a real boggle board: there are sixteen dice (or fifteen for the 5x5 version) that are randomly assigned a position/index. Then each dice is "rolled", randomly choosing one of its six values. There are two dice sets in this program; the standard dice set for the 4x4 grid and for teh 5x5 grid, however they can easily be edited without interferring with the program. This program in particular doesn't have any other functionality, except for a simple IO that prompts the user as to whether or not they want a 5x5 or a 4x4 Boggle grid generated. 
-Sam Baugh

-}

bound :: BoggleBoard -> Integer
bound board
    | (1,5) `member` board = 5
    | (1,4) `member` board = 4

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

--throwDice randomly arranges any amount of dice you "throw" at it.
throwDice :: [Dice] -> RandState [String]
throwDice [] = state $ \s -> ([],s)
throwDice myDice = state $ (\s -> let ((item,list),myGen) = runState (takerm myDice) s in (item:(evalState (throwDice list) myGen), myGen))

--rollDice rolls the dice as ouputted in the throwDice function. These functions must be in that order because once a dice is rolled, it becomes a char instead of a string.
rollDice :: RandState [String] -> RandState [Char]
rollDice g = state $ \s -> let (a,b) = runState g s in (subFunction (a,b),b)
    where subFunction ([],a) = []
          subFunction ((x:xs),firstGen) = let (letter,myGen) = runState (select x) firstGen in letter:(subFunction (xs,myGen))

--index gives each element in a list a two-dimensional index.
index :: [a] -> [((Integer,Integer),a)]
index a = indexBoard' a (round $ sqrt $ fromIntegral $ length a) (1,1)
    where k = 1
          indexBoard' [] _ _ = []
          indexBoard' (x:xs) k (i,j)
              | j<k = ((i,j),x):(indexBoard' xs k (i,j+1))
              | i<k = ((i,j),x):(indexBoard' xs k (i+1,1)) 
              | otherwise = [((i,j),x)]
        
--makeboard makes a board given a set of dice.
makeBoard :: [Dice] -> RandState BoggleBoard
makeBoard myDice =  state $ \s -> let (board,myGen) = runState (rollDice (throwDice myDice)) s in (fromList $ index board,myGen)

--quickBoard4 makes a board using the 4x4 dice set, only requires a StdGen.
quickBoard4 :: StdGen -> BoggleBoard
quickBoard4 = evalState (makeBoard diceSet4)

--quickBoard5 makes a board using the 5x5 dice set, only requires a StdGen.
quickBoard5 :: StdGen -> BoggleBoard
quickBoard5 = evalState (makeBoard diceSet5)

--diceSet4 is the set of dice for the 4x4 grid (16 dice). These are the dice for standard Boggle. They can be edited, new dice can be added. Because this a program, the dice don't even have to have 6 letter each.
diceSet4 :: [Dice]
diceSet4 = [dice2,dice3,dice4,dice5,dice6,dice7,dice8,dice9,dice10,dice11,dice12,dice13,dice14,dice15,dice16,dice1]
dice1 = "AAEEGN"
dice2 = "ELRTTY"
dice3 = "AOOTTW"   
dice4 = "ABBJOO"   
dice5 = "EHRTVW"  
dice6 = "CIMOTU"
dice7 = "DISTTY"  
dice8 = "EIOSST" 
dice9 = "DELRVY" 
dice10 = "ACHOPS"
dice11 = "HIMNQU"  
dice12 = "EEINSU"  
dice13 = "EEGHNW"  
dice14 = "AFFKPS" 
dice15 = "HLNNRZ"  
dice16 = "DEILRX"

--diceSet5 is the set of dice for the 5x5 grid.
diceSet5 :: [Dice]
diceSet5 = [dice1',dice2',dice3',dice4',dice5',dice6',dice7',dice8',dice9',dice10',dice11',dice12',dice13',dice14',dice15',dice16',dice17',dice18',dice19',dice20',dice21',dice22',dice23',dice24',dice25']
dice1' = "AAAFRS" 
dice2' = "AAEEE"
dice3' = "AAFIRS"
dice4' = "ADENNN"
dice5' = "AEEEEM"

dice6' = "AEEGMU"
dice7' = "AEGMNN"
dice8' = "AFIRSY"
dice9' = "BJKQXZ"
dice10' = "CCENST"

dice11' = "CEIILT"
dice12' = "CEILPT"
dice13' = "CEIPST"
dice14' = "DDHNOT"
dice15' = "DHHLOR"

dice16' = "DHLNOR"
dice17' = "DHLNOR"
dice18' = "EIIITT"
dice19' = "EMOTTT"
dice20' = "ENSSSU"

dice21' = "FIPRSY"
dice22' = "GORRVW"
dice23' = "IPRRRY"
dice24' = "NOOTUW"
dice25' = "OOOTTU"

--printRow creates a string that represents a row of the boggle board, this string is then printed in the show instance of BoggleBoardImpl.
printRow :: BoggleBoard -> Integer -> String
printRow board i = [board!(i,1)] ++ printRow' board i 2
    where fourRow = (1,5) `notMember` board
          printRow' board i a 
              | a==5 && fourRow = "" 
              | a==6 = ""
              | otherwise = " | " ++ [board!(i,a)] ++ printRow' board i (a+1)

--I created a simple type for the BoggleBoard to live in. This is mainly to use the system's "show" class.
data BoggleBoardImpl = Construct BoggleBoard

instance Show BoggleBoardImpl where
    show (Construct board) = if (1,5) `notMember` board 
        then "     1   2   3   4  \n" ++ "1  [ " ++ (printRow board 1) ++ " ]  \n"++ "2  [ " ++ (printRow board 2) ++ " ]  \n"++ "3  [ " ++ (printRow board 3) ++ " ]  \n"++ "4  [ " ++ (printRow board 4) ++ " ]  \n" 
        else "     1   2   3   4   5  \n" ++ "1  [ " ++ (printRow board 1) ++ " ]  \n"++ "2  [ " ++ (printRow board 2) ++ " ]  \n"++ "3  [ " ++ (printRow board 3) ++ " ]  \n"++ "4  [ " ++ (printRow board 4) ++ " ]  \n" ++ "5  [ " ++ (printRow board 5) ++ " ]  \n" 

--This is a simple IO that asks the user which type of Boggle Board they would like to generate. The program then prints a generated board and terminates.
sample :: IO ()
sample = do
    g <- getStdGen
    putStr "\n \n \n This is a Boggle board generator. Would you like to generate a 4x4 or a 5x5 Boggle board? \n (Enger either '4' or '5'.) \n"
    a <- getLine
    if a=="4" then putStr $ "\n \n \n" ++ (show $ Construct $ quickBoard4 g) else if a=="5" then putStr $ "\n \n \n" ++ (show $ Construct $ quickBoard5 g) else putStr "Invalid Input."
    putStr "\n \n \n Thank you."




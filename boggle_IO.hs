module Main where

import BoggleSolver
import BoggleBoard
import System.Random
import System.IO
import Data.List
import Data.Char

--This function runs the Boggle simulation. It asks you whether you want a 4x4 or a 5x5 grid, and after you play it tells you your score and asks if you want any additional information about the board.
main :: IO ()
main = do
    let filename = "words.txt"
    g <- getStdGen
    putStr $ (genLines 20) ++ "Welcome to Boggle! The point of the game is to find as many words in the grid as you can by connecting adjacent letters. You cannot backtrack on letters you have already used in the same word. You cannot repeat words, and only non-proper English words greater than two characters count for points. Points are determined per word by the amount of letters minus two. \n \n Would you like to play on a 4x4 grid, or a 5x5 grid? \n (Type either 4 or 5 and 'enter'). \n"
    a <- getLine
    putStr "\n Allright, hit any key when you're ready to play! Type in the string \"done!\" when you've found all of the words you can find.\n"
    _ <- getLine
    putStr "Go!"
    masterWordList <- getWords filename
    let board = if a == "4" then quickBoard4 g else quickBoard5 g
    let correctList = filter (\x -> (length x)>2) $ nub $ solveBoard board masterWordList  
    putStr $ show $ Construct board
    score <- run correctList

    putStr $ "\nCongragulations! Your Score is " ++ (show score) ++ " points! \n \n Would you like to see this board's highest scoring words, its list of the words, or both? \n Enter one of the following: 'Both', 'Highest', 'All Words', or 'Neither'. \n"
    c <- getLine
    let myScores = findScores correctList
    if (toUpper $ head c) == 'H' || (toUpper $ head c) == 'B' then do  
        let topScores = maxScores $ myScores   
        putStr $ "The highest scoring words are: " ++ (putWords topScores) ++ "all with a score of " ++ (show $ snd $ head topScores) ++ " points. \n"
        else do putStr ""
    if (toUpper $ head c) == 'A' || (toUpper $ head c) == 'B'then do 
        putStr $ "The words that can be found in this Boggle board are: \n" ++ (putScores myScores)
        else do putStr ""
    putStr "\n Thank you for playing! \n"
   
--This function recursively prompts for words, and then tells you if the word is invalid and adds that word's score if the word is valid.
run :: WordList -> IO (Int)
run correctWords = do
    myWord' <- getLine
    let myWord = upperCase myWord'
    if myWord == "DONE!" then do return 0
    else if elem myWord correctWords then do 
        thing <- run (delete myWord correctWords)
        return $ (thing + (scoreWord myWord))
    else do
        putStr "Not acceptable! Try again.\n"
        run correctWords


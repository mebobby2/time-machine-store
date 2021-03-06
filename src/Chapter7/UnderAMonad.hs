module Chapter7.UnderAMonad where

--import Control.Monad
import Control.Monad.Reader
import Control.Monad.Writer

addPrefix :: String -> Reader String String
addPrefix s = ask >>= \p -> return $ p ++ s

-- :t map addPrefix
-- Gives: map addPrefix :: [String] -> [Reader String String]
-- Which isn't what we want. So we have to use mapM
addPrefixL :: [String] -> Reader String [String]
addPrefixL = mapM addPrefix
--runReader (addPrefixL ["one","two"]) "**-"

logInformation :: [String] -> Writer String ()
logInformation = mapM_ (\s -> tell (s ++ "\n"))
--runWriter $ logInformation ["one", "two"]

logInformation2 :: [String] -> Writer String ()
logInformation2 infos = forM_ infos $ \s ->
                         tell (s ++ "\n")
--runWriter $ logInformation2 ["one", "two"]

factorialSteps :: Integer -> Writer (Sum Integer) Integer
factorialSteps n = foldM (\f x -> tell (Sum 1) >> return (f*x)) 1 [1 .. n]

--We can use foldM to sum a list and print the intermediate sum at each step:
--Monads> foldM (\a b ->
--               putStrLn (show a ++ "+" ++ show b ++
--                         "=" ++ show (a+b)) >>
--               return (a+b)) 0 [1..5]
--0+1=1
--1+2=3
--3+3=6
--6+4=10
--10+5=15
--Monads> it
--15

powerset :: [a] -> [[a]]
powerset = filterM (\_ -> [False, True])
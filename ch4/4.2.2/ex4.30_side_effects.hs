
main = do
  let x = print "This will not print until x is forced"
  putStrLn "Hello, world!"
  x  -- `print` is executed only here

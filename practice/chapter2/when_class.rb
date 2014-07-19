# obj = 'Robin Smith'
# obj = 123
obj = 1.23

decision = case obj
when String
  "It's a String!"
when Integer
  "It's an Integer!"
when Float
  "It's a Float!"
else
  "Don't know what it is!"
end

printf "decision: %s", decision
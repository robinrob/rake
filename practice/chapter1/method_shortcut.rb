#Ruby methods return the last value evaluated!
#So you don't need a return statement in this case:

def sayGoodnightTo(name)
  result = "Goodnight, #{name}!"
end

puts sayGoodnightTo("Robin Smith")
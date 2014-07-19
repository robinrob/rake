def calculate(op1, operator, op2)
  string = op1.to_s + operator + op2.to_s
    # operator is assumed to be a string; make one big
    # string of it and the two operands
  eval(string)   # Evaluate and return a value
end

@alpha = 25
@beta = 12

puts calculate(2, "+", 2)        # Prints 4
puts calculate(5, "*", "@alpha") # Prints 125
puts calculate("@beta", "**", 3) # Prints 1728

puts "Yes!" if eval('true')
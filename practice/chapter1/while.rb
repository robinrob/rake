#Multiplication table

# i = 0
# while i < 5
#   puts "Hello!"
#   i += 1
# end

MAX = 5

def print_line(i, max)
  j = 0
  while j < max
    printf "%-5s", (i * j).to_s()
    j += 1
  end 
  
  puts
  
end

i = 0
j = 0
while i < MAX
  print_line(i, MAX)
  i += 1
end



#One-line while loop
# while square < 1000
#    square = square * square
# end
# 
# Alternatively-written using statement modifier
# square = square * square while square < 1000
format = "%-15s"

print format % "enter input: "
input = gets

puts format % "in: " + input.gsub("\n", "\\n")
puts format % "chomped: " + input.chomp!().gsub("\n", "\\n")
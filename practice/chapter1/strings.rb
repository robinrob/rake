#double-quoted strings replace escaped characters with actual (binary) values
#single-quoted strings display all characters literally
word1 = 'word up!\ni said word up!'
word2 = "word up! \ni said word up!"

puts 'single-quoted string:'
puts word1
puts

puts "double-quoted string:"
puts word2
standard = { "key" => "value", 1 => 2, true => false }

puts standard["key"]
puts standard[1]
puts standard[true]

puts

tokens = { :robin => "Robin", :pi => 3.14 }

puts tokens[:robin]
puts tokens[:pi]

puts

tokens_short = { robin: 'Russ', pi: 3.14 }

puts tokens[:robin]
puts tokens[:pi]
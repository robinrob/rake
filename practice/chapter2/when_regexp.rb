word = gets

case word
when /Robin .*/
  puts 'Maybe Robin Smith?'
when /Hello .*/
  puts 'Maybe Hello World?'
when /Barry .*/
  puts 'Maybe Barry Mate!?'
else
  puts 'Absolutely no idea...'
end

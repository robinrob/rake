def echo_all( *args )
  args.each { |arg| puts arg }
end

echo_all("Robin ", "Smith ", "knows that (pi is about ", 3.14, ") is ", true)
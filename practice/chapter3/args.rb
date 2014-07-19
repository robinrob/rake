def args(first_arg, *middle_args, last_arg)
  puts first_arg
  middle_args.each{ |arg| puts arg }
  puts last_arg
end

args("hello", "robin", "andrew", "smith")
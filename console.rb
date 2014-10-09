require 'colorize'
require 'differ'

module Console
  def self.thefuckout(msg)
    $stdout, $stderr = STDOUT, STDERR
    $stdout.puts "\nBEGIN OUTPUT>>>".cyan
    $stdout.puts msg.yellow
    $stdout.puts "<<<END OUTPUT".cyan
  end

  def self.diff(str1, str2)
    puts "\n" << Differ.diff(str1, str2).to_s.yellow
  end
end
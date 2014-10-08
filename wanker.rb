require 'colorize'

module Wanker
  def self.thefuckout(msg)
    $stdout, $stderr = STDOUT, STDERR
    $stdout.puts "\nBEGIN OUTPUT>>>".cyan
    $stdout.puts msg.yellow
    $stdout.puts "<<<END OUTPUT".cyan
  end
end
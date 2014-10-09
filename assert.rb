require 'exceptions'
require 'console'
require 'differ'

module Assert

  def self.equal_strings(expected, actual)
    if expected != actual
      Console.thefuckout "Should be:".light_red
      Console.thefuckout expected.green
      Console.thefuckout "Actually:".light_red
      Console.thefuckout actual.yellow
      Console.thefuckout "Diff:".light_red
      Console.thefuckout "\n" << Differ.diff_by_line(actual, expected).to_s.light_red
    end
  end


  def self.assert &block
    raise AssertionError unless yield
  end
end
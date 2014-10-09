require 'exceptions'
require 'console'
require 'differ'

module Assert

  def self.equal_strings(str1, str2)
    if str1 != str2
      Console.thefuckout "\n" << Differ.diff_by_line(str1, str2).to_s.yellow
    end
    # assert_equal(str1, str2)
  end


  def self.assert &block
    raise AssertionError unless yield
  end
end
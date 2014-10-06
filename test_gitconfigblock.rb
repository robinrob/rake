$LOAD_PATH << '.'

require 'test/unit'

require 'gitconfigblock'


class TestGitConfigBlock < Test::Unit::TestCase

  def test_should_convert_block_to_string()
    block = GitConfigBlock.new({:type => 'submodule', :name => 'rake', :attrs => [{:name => 'path', :value => 'rake'}]})

    str = block.to_s

    expected = <<-END
    [submodule = "rake"]
      path = rake
    END
    assert_equal(expected, str)
  end

end

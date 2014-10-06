$LOAD_PATH << '.'

require 'test/unit'

require 'gitconfigblock'


class TestGitConfigBlock < Test::Unit::TestCase

  def test_should_convert_block_to_string()
    block = GitConfigBlock.new({:type => 'submodule',
                                :name => 'rake',
                                :attrs => [{:name => 'path', :value => 'rake'},
                                           {:url => 'git@bitbucket.org:robinrob/rakefile.git'}
                                ]})
    expected = <<-END
[submodule = "rake"]
  path = rake
    END

    str = block.to_s

    assert_equal(expected, str)
  end

end

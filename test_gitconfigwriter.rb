$LOAD_PATH << '.'

require 'test/unit'
require 'gitconfigwriter'


class TestGitConfigWriter < Test::Unit::TestCase

  TestString = <<-END
[submodule = "rake"]
  path = rake
  url = git@bitbucket.org:robinrob/rakefile.git
  END

  TestFilename = '.gitconfig_test'


  def teardown
    `rm .gitconfig_test`
  end


  def test_should_write_1_block
    blocks = [GitConfigBlock.new(TestString)]
    expected = <<-END
[submodule = "rake"]
  path = rake
  url = git@bitbucket.org:robinrob/rakefile.git
  owner = robinrob
END

    GitConfigWriter.new.write(blocks, filename=TestFilename)

    contents = `cat #{TestFilename}`
    assert_equal(expected, contents)
  end

end

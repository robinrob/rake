$LOAD_PATH << '.'

require 'test/unit'
require 'gitconfigwriter'
require 'gitconfigblock'


class TestGitConfigWriter < Test::Unit::TestCase

  Block1 = <<-END
[submodule "rake"]
  path = rake
  url = git@bitbucket.org:robinrob/rakefile.git
  END

  Block2 = <<-END
[submodule "robin.com"]
  path = robin
  url = git@bitbucket.org:robinrob/robin.git
  END

  Blocks = [Block1, Block2]

  TestFilename = '.gitconfig_test'


  def teardown
    File.delete(TestFilename)
  end


  def file_contents(filename)
    File.open(filename, "r") do |infile|
      contents = ""
      while (line = infile.gets)
        contents << line
      end
      contents
    end
  end


  def test_should_write_1_block_into_new_config
    blocks = [GitConfigBlock.new(Block1)]

    GitConfigWriter.new.write(blocks, filename=TestFilename)

    assert_equal(Block1, file_contents(TestFilename))
  end


  def test_should_write_2_blocks_into_new_config
    blocks = [GitConfigBlock.new(Block1), GitConfigBlock.new(Block2)]
    expected = [Block1, Block2].join

    GitConfigWriter.new.write(blocks, filename=TestFilename)

    assert_equal(expected, file_contents(TestFilename))
  end


  def test_should_write_1_block_over_existing_config
    File.open(TestFilename, File::WRONLY | File::CREAT) { |file| file.write(Block1) }
    blocks = [GitConfigBlock.new(Block1)]

    GitConfigWriter.new.write(blocks, filename=TestFilename)

    assert_equal(Block1, file_contents(TestFilename))
  end

end
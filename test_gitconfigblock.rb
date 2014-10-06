$LOAD_PATH << '.'

require 'test/unit'
require 'gitconfigblock'


class TestGitConfigBlock < Test::Unit::TestCase

  TestString = <<-END
[submodule = "rake"]
  path = rake
  url = git@bitbucket.org:robinrob/rakefile.git
END


  def test_should_read_block
    lines = TestString

    block = GitConfigBlock.new(lines)

    assert(block.instance_of?(GitConfigBlock))
  end


  def test_should_read_block_type
    lines = TestString

    block = GitConfigBlock.new(lines)

    assert_equal('submodule', block.type)
  end


  def test_should_read_block_name
    lines = TestString

    block = GitConfigBlock.new(lines)

    assert_equal('rake', block.name)
  end


  def test_should_read_path_attr
    lines = TestString

    block = GitConfigBlock.new(lines)

    assert_equal('rake', block.attrs[:path])
  end


  def test_should_read_url_attr
    lines = TestString

    block = GitConfigBlock.new(lines)

    assert_equal('git@bitbucket.org:robinrob/rakefile.git', block.attrs[:url])
  end


  def test_should_generate_owner_attr
    lines = TestString

    block = GitConfigBlock.new(lines)

    assert_equal('robinrob', block.attrs[:owner])
  end


  def test_should_convert_block_to_string
    lines = TestString
    expected = <<-END
[submodule = "rake"]
  path = rake
  url = git@bitbucket.org:robinrob/rakefile.git
  owner = robinrob
END

    block = GitConfigBlock.new(lines)

    assert_equal(expected, block.to_s)
  end

end

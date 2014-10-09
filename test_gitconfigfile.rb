$LOAD_PATH << '.'

require 'test/unit'

require 'gitconfigfile'
require 'gitconfigblockbuilder'
require 'differ'
require 'console'
require 'exceptions'


class TestGitConfigFile < Test::Unit::TestCase

  TestFilename = '.gitconfig_test'

  EditedContents = <<-END
[submodule "awk"]
  path = awk
  url = git@bitbucket.org:robinrob/awk.git
  branch = master
[submodule "c"]
  path = c
  url = git@bitbucket.org:robinrob/c.git
  branch = master
[submodule "force.com"]
  path = force.com
  url = git@bitbucket.org:robinrob/force.com.git
  branch = master
[submodule "java"]
  path = java
  url = git@bitbucket.org:robinrob/java.git
  branch = master
[submodule "javascript"]
  path = javascript
  url = git@bitbucket.org:robinrob/javascript.git
  branch = master
[submodule "perl"]
  path = perl
  url = git@bitbucket.org:robinrob/perl.git
  branch = master
[submodule "python"]
  path = python
  url = git@bitbucket.org:robinrob/python.git
  branch = master
END

  def setup
    gitconfig_contents = <<-END
[submodule "awk"]
  path = awk
  url = git@bitbucket.org:robinrob/awk.git
  branch = master
[submodule "c"]
  path = c
  url = git@bitbucket.org:robinrob/c.git
  branch = master
[submodule "force.com"]
  path = force.com
  url = git@bitbucket.org:robinrob/force.com.git
  branch = master
[submodule "ruby"]
  path = ruby
  url = git@bitbucket.org:robinrob/ruby.git
  branch = master
[submodule "java"]
  path = java
  url = git@bitbucket.org:robinrob/java.git
  branch = master
[submodule "javascript"]
  path = javascript
  url = git@bitbucket.org:robinrob/javascript.git
  branch = master
[submodule "perl"]
  path = perl
  url = git@bitbucket.org:robinrob/perl.git
  branch = master
[submodule "python"]
  path = python
  url = git@bitbucket.org:robinrob/python.git
  branch = master
END
    File.open(TestFilename, File::WRONLY | File::CREAT) do |file|
      file.write(gitconfig_contents)
    end
  end


  def teardown
    File.delete TestFilename
  end


  def test_should_get_gitconfig_contents_by_default
    expected = "hello Robin"
    filename = '.gitconfig'
    File.open(filename, 'w') {|file| file.write(expected)}
    file = GitConfigFile.new

    contents = file.contents

    assert_equal(expected, contents)
    File.delete(filename)
  end


  def test_should_get_gitsubmodule_contents
    expected = "hello Robin"
    filename = '.gitsubmodules'
    File.open(filename, 'w') {|file| file.write(expected)}
    file = GitConfigFile.new(:filename => filename)

    contents = file.contents

    assert_equal(expected, contents)
    File.delete(filename)
  end


  def test_should_raise_file_not_found_exception_when_file_does_not_exist
    assert_raises FileNotFoundException do
      GitConfigFile.new
    end
  end


  def test_should_serialize_1_gitconfigblock
    type = 'submodule'
    name = 'robin'
    attrs = {:url => 'git@bitbucker.org:robinrob/robin.git', :path => 'robin'}
    blocks = [GitConfigBlockBuilder.new.with_type(type).with_name(name).with_attrs(attrs).build]
    file = GitConfigFile.new(:blocks => blocks)
    expected = <<-END
[submodule "robin"]
  url = git@bitbucker.org:robinrob/robin.git
  path = robin
END

    str = file.serialize

    assert_equal(expected, str)
  end


  def test_should_serialize_10_gitconfigblocks
    type = 'submodule'
    name = 'robin'
    attrs = {:url => 'git@bitbucker.org:robinrob/robin.git', :path => 'robin'}
    blocks = [GitConfigBlockBuilder.new.with_type(type).with_name(name).with_attrs(attrs).build] * 10
    file = GitConfigFile.new(:blocks => blocks)
    expected = <<-END
[submodule "robin"]
  url = git@bitbucker.org:robinrob/robin.git
  path = robin
END
    expected = ([expected] * 10).join

    str = file.serialize

    assert_equal(expected, str)
  end


  def test_should_get_ruby_submodule_block()
    file = GitConfigFile.new(:filename => TestFilename)
    expected = <<-END
[submodule "ruby"]
  path = ruby
  url = git@bitbucket.org:robinrob/ruby.git
  branch = master
END

    block = file.get_block 'ruby'

    # Console.diff expected, block.to_s
    Assert.equal_strings(expected, block.to_s)
  end


  def test_should_delete_ruby_submodule_block()
    file = GitConfigFile.new(:filename => TestFilename)

    block = file.del_block 'ruby'

    assert_equal('ruby', block.name)
  end


  def test_should_delete_1_block()
    file = GitConfigFile.new(:filename => TestFilename)
  
    file.del_block 'ruby'

    assert_equal(9, file.blocks.length)
  end


  def test_should_save_edits_to_file
    file = GitConfigFile.new(:filename => TestFilename)
    file.del_block 'ruby'
    expected = EditedContents

    file.save

    Assert.equal_strings(expected, file.contents)
  end

end

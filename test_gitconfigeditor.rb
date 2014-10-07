require 'test/unit'

require 'gitconfigeditor'


class TestGitConfigEditor < Test::Unit::TestCase

  TestFilename = '.gitconfig_test'

  EditedContents = <<-END
[submodule "awk"]
  path = awk
  url = git@bitbucket.org:robinrob/awk.git
  branch = master
END

  def setup
    gitconfig_contents = <<-END
[submodule "awk"]
  path = awk
  url = git@bitbucket.org:robinrob/awk.git
  branch = master
[submodule "ruby"]
  path = ruby
  url = git@bitbucket.org:robinrob/ruby.git
  branch = master
END
    File.open(TestFilename, File::WRONLY | File::CREAT) do |file|
      file.write(gitconfig_contents)
    end
  end


  def teardown
    File.delete TestFilename
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


  def test_should_get_10_blocks()
    editor = GitConfigEditor.new(TestFilename)

    blocks = editor.blocks

    assert_equal(10, blocks.length)
  end


  def test_should_get_ruby_submodule_block()
    editor = GitConfigEditor.new(TestFilename)

    block = editor.get_block 'ruby'

    assert_equal('ruby', block.name)
  end


  def test_should_delete_ruby_submodule_block()
    editor = GitConfigEditor.new(TestFilename)

    block = editor.del_block 'ruby'

    assert_equal('ruby', block.name)
  end


  def test_should_delete_1_block()
    editor = GitConfigEditor.new(TestFilename)

    editor.del_block 'ruby'

    assert_equal(9, editor.blocks.length)
  end


  def test_should_save_edits_to_file
    editor = GitConfigEditor.new(TestFilename)
    editor.del_block 'ruby'

    editor.save

    assert_equal(EditedContents, file_contents(TestFilename))
  end

end

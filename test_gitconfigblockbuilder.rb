$LOAD_PATH << '.'

require 'test/unit'

require 'gitconfigblockbuilder'


class TestGitConfigBlockBuilder < Test::Unit::TestCase


  def test_build_gitconfigblock_with_type
    name = 'Robin Smith'

    block = GitConfigBlockBuilder.with_name(name)

    assert_equal(name, block.name)
  end

end

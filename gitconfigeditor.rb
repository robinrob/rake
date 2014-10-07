require 'gitconfigreader'
require 'gitconfigwriter'

class GitConfigEditor

  attr_accessor :blocks


  def initialize(filename)
    @filename = filename
    @blocks = GitConfigReader.new.read(filename)
  end


  def get_block(block_name)
    @blocks.find { |block| block.name == block_name }
  end


  def del_block(block_name)
    @blocks.delete(get_block(block_name))
  end


  def save
    GitConfigWriter.new.write(@blocks, @filename)
  end

end
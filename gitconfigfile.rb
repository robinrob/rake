require 'assert'

require 'gitconfigreader'
require 'gitconfigwriter'
require 'wanker'

class GitConfigFile

  attr_accessor :blocks


  def initialize(filename='.gitconfig', deblocks=nil)
    Wanker.thefuckout "WANKER!!!!" if deblocks.nil?

    @filename = filename

    if blocks.nil?
      if File.exists? filename
        @blocks = GitConfigReader.new.read(filename)
      else
        raise FileNotFoundException
      end

    else
      @blocks = blocks
    end

  end


  def serialize
    str = ""
    @blocks.each do |block|
      str += block.to_s
    end
    str
  end


  def save
    File.open(@filename, File::WRONLY | File::CREAT) do |file|
      file.write(serialize)
    end
  end


  def contents
    File.open(@filename, "r") do |infile|
      contents = ""
      while (line = infile.gets)
        contents << line
      end
      contents
    end
  end


  def contents=(contents)
    File.open(filename, File::WRONLY | File::CREAT) do |file|
      file.write(contents)
    end
  end


  def get_block(block_name)
    @blocks.find { |block| block.name == block_name }
  end


  def del_block(block_name)
    @blocks.delete(get_block(block_name))
  end

end
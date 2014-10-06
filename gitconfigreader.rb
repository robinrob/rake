$LOAD_PATH << '.'

require 'gitconfigblock'

# Reads a file with format of .gitconfig, for example .gitmodules and returns an array of hashes.
# Each hash represents a block of the config file, containing the config in a 'flat' csv-like structure.
class GitConfigReader

  def read(filename='.gitconfig')
    text = `cat #{filename}`
    text.strip!

    blocks = []

    unless text == ''
      text.split(/(\[.*\])/)[1..-1].each_slice(2) { |block_str| blocks << GitConfigBlock.new(block_str.join) }
    end

    blocks
  end

end
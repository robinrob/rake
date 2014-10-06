$LOAD_PATH << '.'


class GitConfigWriter

  def write(blocks, filename='.gitconfig')
    File.open(filename, File::WRONLY | File::CREAT) do |file|
      blocks.each do |block|
        file.write(block.to_s)
      end
    end
  end
end
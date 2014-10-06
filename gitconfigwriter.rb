class GitConfigWriter

  def write(sections, filename='.gitconfig')
    File.open(filename, File:WRONLY) do |file|
      file.write(section)
    end
  end
end
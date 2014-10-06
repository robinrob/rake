# Reads a with format of .gitconfig, for example .gitmodules and returns an array of hashes.
# Each hash represents a section of the config file, containing the config in a 'flat' csv-like structure.
class GitConfigReader

  Indent=4

  def read(filename='.gitconfig')
    text = `cat #{filename}`
    text.strip()

    sections = []

    unless text == ''
      text.split(/(\[.*\])/)[1..-1].each_slice(2) { |s| sections << read_section(s.join.split("\n")) }
    end

    sections
  end

  private
  def read_section(lines)
    section = {}

    counter = 0
    lines[0..-1].each do |line|
      if counter == 0
        comps = line.gsub('[', '').gsub(']', '').split(' ')
        section[:type] = comps[0]
        if comps.length == 2 then section[:name] = comps[1] end

      elsif line.match(/.*=.*/)
        comps = line.split('=')

        key = comps[0].strip()
        val = comps[1].strip()

        section[key.to_sym] = val
      end

      counter += 1
    end
    section[:owner] = parse_owner(section[:url])
    section
  end


  def parse_owner(repo)
    repo.strip!
    if repo.include?('https')
      repo.split('/')[3].split('/')[0]
    else
      repo.split(':')[1].split('/')[0]
    end
  end

end
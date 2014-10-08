class GitConfigBlock
  AttributeIndent = 2

  attr_accessor :name, :type, :attrs, :derived_attrs


  def initialize(hash)
    @type = hash[:type]
    @name = hash[:name]
    @attrs = hash[:attrs]
    @derived_attrs = hash[:derived_attrs]
  end


  def initialize(lines)
    block = read(lines)

    @type = block[:type]
    @name = block[:name]
    @attrs = block[:attrs]
    @derived_attrs = block[:derived_attrs]
  end


  def to_s
    str = "[#{@type} \"#{@name}\"]\n"
    @attrs.keys.each do |key|
      str += "  #{key} = #{@attrs[key]}\n"
    end
    str
  end


  private
  def read(lines)
    block = {}
    block[:attrs] = {}
    block[:derived_attrs] = {}

    lines.each_line.with_index do |line, index|
      if index == 0
        comps = line.scan(/[^\"\s\[\]]+/)
        block[:type] = comps[0]
        block[:name] = comps[1]

      elsif line.match(/.*=.*/)
        key, val = line.split('=').collect {|comp| comp.strip!}
        block[:attrs][key.to_sym] = val
      end
    end
    block = calc_derived_attrs(block)

    block
  end


  def read_attr(line)
    {key.to_sym => val}
  end


  def calc_derived_attrs(block)
    unless block[:attrs][:url].nil?
      block[:derived_attrs][:owner] = parse_owner(block[:attrs][:url])
    end

    block
  end


  def parse_owner(repo_url)
    repo_url.scan(/(?:bitbucket.org|github.com)(?::|\/)(\w+)\/.*/)[0][0]
  end
end
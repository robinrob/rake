class GitConfigBlock
  attr_accessor :name, :type, :attrs

  def initialize(block)
    @type = block[:type]
    @name = block[:name]
    @attrs = block[:attrs]
  end


  def to_s
    str = "[#{@type} = \"#{@name}\"]\n"
    @attrs.each do |attr|
      str += "  #{attr[:name]} = #{attr[:value]}\n"
    end
    str
  end
end
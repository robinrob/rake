class GitConfigBlock
  AttributeIndent = 2

  attr_accessor :name, :type, :attrs

  def initialize(block)
    @type = block[:type]
    @name = block[:name]
    @attrs = block[:attrs]
  end


  def to_s
    str = "[#{@type} = \"#{@name}\"]\n"
    @attrs.each do |attr|
      str += (" " * AttributeIndent) << "#{attr[:name]} = #{attr[:value]}\n"
    end
    str
  end
end
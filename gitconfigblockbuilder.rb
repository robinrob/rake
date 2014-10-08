require 'gitconfigblock'

class GitConfigBlockBuilder

  def initialize
    @type = nil
    @name = nil
    @attrs = nil
    @derived_attrs = nil
  end


  def withType(type)
    @type = type
    self
  end


  def withName(name)
    @name = name
    self
  end


  def with_attrs(attrs)
    @attrs = attrs
    self
  end


  def with_derived_attrs(derived_attrs)
    @derived_attrs = derived_attrs
    self
  end


  def build
    GitConfigBlock.new({
                           :type => @type,
                           :name => @name,
                           :attrs => @attrs,
                           :derived_attrs => @derived_attrs
                       })
  end

end
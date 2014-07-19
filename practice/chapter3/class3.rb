class MyClass

  NAME = "Class Name" # class constant
  @@count = 0 #  Initialize a class variable
  
  attr_accessor :myvar
  
  def initialize # called when object is allocated
    @@count += 1  
    @myvar = 10
  end

  def MyClass.getcount # class method
    @@count # class variable
  end

  def getcount # instance returns class variable!
    @@count # class variable
  end
  
end

foo = MyClass.new # @myvar is 10
puts foo.myvar

foo.myvar = 20 # @myvar is 30
puts foo.myvar
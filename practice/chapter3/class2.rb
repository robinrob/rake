class MyClass

  NAME = "Class Name" # class constant
  @@count = 0 #  Initialize a class variable
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

  def getmyvar # instance method
    @myvar # instance variable
  end

  def setmyvar(val) # instance method sets @myvar
    @myvar = val
  end

  def myvar=(val) # Another way to set @myvar
    @myvar = val
  end
end

foo = MyClass.new # @myvar is 10
puts foo.getmyvar

foo.setmyvar 20 # @myvar is 20
puts foo.getmyvar

foo.myvar = 30 # @myvar is 30
puts foo.getmyvar

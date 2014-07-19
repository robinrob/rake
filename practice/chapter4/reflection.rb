class Robin
  ROBIN="SMITH"
  
  private
  
  def smith
  end
end

print "respond_to?: ", Robin.new().respond_to?('smith'), "\n"

print "respond_to?: ", Robin.respond_to?('smith'), "\n"

print "is_a?: ", Robin.new().is_a?(Robin), "\n"

print "is_a?: ",  Robin.is_a?(Robin), "\n"

print "kind_of?: ", Robin.new().kind_of?(Robin), "\n"

print "methods: ", Robin.new().methods()[0], "\n"

print "methods: ", Robin.methods()[0], "\n"

print "private_instance_methods: ", Robin.private_instance_methods()[0], "\n"

print "protected_instance_methods: ", Robin.protected_instance_methods(), "\n"

print "public_instance_methods: ", Robin.public_instance_methods()[0], "\n"

print "superclass: ", Robin.superclass(), "\n"

print "superclass: ", Object.superclass(), "\n"

print "superclass: ", ("nil" if BasicObject.superclass() == nil), "\n"

print "constants: ", Robin.constants().to_s(), "\n"
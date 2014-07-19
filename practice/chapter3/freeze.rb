#str = "Robin Smith"
#
#puts str
#
#str.freeze
#
#puts str.gsub("Smith", "Robin")
#
#puts str
#
#str.freeze

#Variable assignment causes object references to be shared.
y = "abc"
x = y
puts x         # "abc"
puts y         # "abc"
puts

#After executing x = y, variables x and y both refer to the same object:
puts x.object_id     # 53732208
puts y.object_id     # 53732208
puts

#If the object is mutable, a modification done to one variable will be reflected in the other:
puts x.gsub!(/a/,"x")
puts y                 # "xbc"
puts

#Reassigning one of these variables has no effect on the other, however:
# Continuing previous example...
puts x = "abc"
puts y                 # still has value "xbc"
puts

#A mutable object can be made immutable using the freeze method:
x.freeze
puts x.gsub!(/b/,"y")  # Error!